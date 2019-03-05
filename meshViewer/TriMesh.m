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
    function this = TriMesh(varargin)
        
        if isnumeric(varargin{1})
            this.Vertices = varargin{1};
            this.Faces = varargin{2};
            
        elseif isstruct(varargin{1})
            var1 = varargin{1};
            this.Vertices = var1.Vertices;
            this.Faces = var1.Faces;
        end
        
    end
end

%% General use methods
methods
    function nv = vertexNumber(this)
        nv = size(this.Vertices, 1);
    end
    
    function nf = faceNumber(this)
        nf = size(this.Faces, 1);
    end
    
    function ne = edgeNumber(this)
        ne = size(this.Edges, 1);
    end
end

%% Serialization methods
methods
    function str = toStruct(this)
        % Convert to a structure to facilitate serialization
        str = struct('type', 'TriMesh', ...
            'vertices', this.Vertices, ...
            'faces', this.Faces);
        if ~isempty(this.Edges)
            str.edges = this.Edges;
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