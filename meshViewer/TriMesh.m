classdef TriMesh < handle
%TRIMESH Class for representing a triangular 3D mesh
%
%   output = TriMesh(input)
%
%   Example
%   TriMesh
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-05-03,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - Cepia Software Platform.

properties
    % Coordinates of mesh vertices, as a Nv-by-3 array
    Vertices;
    
    % indices of vertices of each face, as a Nf-by-3 array of integers
    Faces;
    
    % optionnal information about edges, as a Ne-by-2 array of integers
    Edges = [];
    
    % more topological information
    VertexFaces = {};
    VertexEdges = {};
    EdgeFaces = [];
    FaceEdges = [];
    
    % some geometrical informations
    FaceNormals = [];
    EdgeNormals = [];
    VertexNormals = [];
end

%% Constructor
methods
    function obj = TriMesh(varargin)
        
        % Parse input arguments
        if isnumeric(varargin{1})
            obj.Vertices = varargin{1};
            obj.Faces = varargin{2};
            
        elseif isstruct(varargin{1})
            var1 = varargin{1};
            obj.Vertices = var1.Vertices;
            obj.Faces = var1.Faces;
        end
       
        % ensure faces is N-by-3
        if size(obj.Faces, 2) > 3
            obj.Faces = triangulateFaces(obj.Faces);
        end
    end
end

%% Geometric inforamtion about mesh
methods
    function vol = volume(obj)
        % (signed) volume enclosed by this mesh
        %
        % See Also
        %   meshVolume

        % initialize an array of volume
        nFaces = size(obj.Faces, 1);
        vols = zeros(nFaces, 1);

        % Shift all vertices to the mesh centroid
        centroid = mean(obj.Vertices, 1);
        
        % compute volume of each tetraedron
        for iFace = 1:nFaces
            % consider the tetrahedron formed by face and mesh centroid
            tetra = obj.Vertices(obj.Faces(iFace, :), :);
            tetra = bsxfun(@minus, tetra, centroid);
            
            % volume of current tetrahedron
            vols(iFace) = det(tetra) / 6;
        end
        
        vol = sum(vols);
    end
    
    function area = surfaceArea(obj)
        % surface area of mesh faces
        %
        % See Also
        %   meshSurfaceArea
        
        % compute two direction vectors of each trinagular face, using the
        % first vertex of each face as origin
        v1 = obj.Vertices(obj.Faces(:, 2), :) - obj.Vertices(obj.Faces(:, 1), :);
        v2 = obj.Vertices(obj.Faces(:, 3), :) - obj.Vertices(obj.Faces(:, 1), :);
        
        % area of each triangle is half the cross product norm
        vn = vectorNorm3d(crossProduct3d(v1, v2));
        
        % sum up and normalize
        area = sum(vn) / 2;
    end
    
    function mb = meanBreadth(obj)
        % Mean breadth of this mesh
        % Mean breadth is proportionnal to the integral of mean curvature
        %
        % See Also
        %   trimeshMeanBreadth
        
        mb = trimeshMeanBreadth(obj.Vertices, obj.Faces);
    end
end


%% Basic information about mesh
methods
    function nv = vertexNumber(obj)
        nv = size(obj.Vertices, 1);
    end
    
    function nf = faceNumber(obj)
        nf = size(obj.Faces, 1);
    end
    
    function ne = edgeNumber(obj)
        ne = size(obj.Edges, 1);
    end
end


%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization
        str = struct('type', 'TriMesh', ...
            'vertices', obj.Vertices, ...
            'faces', obj.Faces);
        if ~isempty(obj.Edges)
            str.edges = obj.Edges;
        end
    end
end
methods (Static)
    function mesh = fromStruct(str)
        % Create a new instance from a structure
        if ~(isfield(str, 'vertices') && isfield(str, 'faces'))
            error('Requires fields vertices and faces');
        end
        if size(str.faces, 2) ~= 3
            error('Requires a triangular face array');
        end
        mesh = TriMesh(str);
    end
end

end