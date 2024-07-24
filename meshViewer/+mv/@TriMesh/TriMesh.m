classdef TriMesh < handle
%TRIMESH Class for representing a triangular 3D mesh.
%
%   MESH = TriMesh(V, F)
%
%   Restricted to manifold triangular meshes. Can have boundaries.
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
    % Coordinates of mesh vertices, as a Nv-by-3 array.
    Vertices;
    
    % indices of vertices of each face, as a Nf-by-3 array of integers.
    Faces;
    
    % optionnal information about edges, as a Ne-by-2 array of integers.
    Edges = [];
    
    % The list of faces adjacent to each vertex.
    VertexFaces = {};
    
    % The list of edges adjacent to each vertex.
    VertexEdges = {};

    % The two faces around each edge, as a NE-by-2 array of face indices.
    EdgeFaces = [];

    % The three edges around each fave, as a NF-by-3 array of edge indices.
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
            obj.Vertices = var1.vertices;
            obj.Faces = var1.faces;
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
        % (signed) volume enclosed by this mesh.
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
        % Surface area of mesh faces.
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
        % Mean breadth of this mesh.
        %
        % Mean breadth is proportionnal to the integral of mean curvature.
        %
        % See Also
        %   trimeshMeanBreadth
        
        mb = trimeshMeanBreadth(obj.Vertices, obj.Faces);
    end
end


%% Vertex management methods
methods
    function nv = vertexCount(obj)
        % Return the number of vertices within the mesh.
        nv = size(obj.Vertices, 1);
    end
end


%% Edge management methods
methods
    function ne = edgeCount(obj)
        % Return the number of edges within the mesh.
        ne = size(obj.Edges, 1);
    end

    function ensureValidEdges(obj)
        % Compute the Edges property if it is empty.
        if isempty(obj.Edges)
            computeEdges(obj);
        end
    end

    function ensureValidEdgeFaces(obj)
        % Compute the EdgeFaces property if it is empty.
        if isempty(obj.EdgeFaces)
            computeEdgeFaces(obj);
        end
    end
end



%% Face management methods
methods
    function nf = faceCount(obj)
        % Return the number of faces within the mesh.
        nf = size(obj.Faces, 1);
    end
    
    function ensureValidFaceEdges(obj)
        % Compute the FaceEdges property if it is empty.
        if isempty(obj.FaceEdges)
            computeFaceEdges(obj);
        end
    end
end


%% private topology computation methods
methods (Access = private)
    function computeEdges(obj)
        % Update the property Edges.
        
        % create initial edge array (including duplicates)
        edges = [...
            obj.Faces(:,1) obj.Faces(:,2) ; ...
            obj.Faces(:,2) obj.Faces(:,3) ; ...
            obj.Faces(:,3) obj.Faces(:,1)];
        
        % remove duplicate edges (result is sorted)
        obj.Edges = unique(sort(edges, 2), 'rows');
    end
    
    function computeEdgesAndFaces(obj)
        % Update the properties Edges, EdgeFaces and FaceEdges.
        %
        % Making the initialization together allows to make it slightly
        % faster than separately.
        
        % create initial edge array (including duplicates)
        edges = [...
            obj.Faces(:,1) obj.Faces(:,2) ; ...
            obj.Faces(:,2) obj.Faces(:,3) ; ...
            obj.Faces(:,3) obj.Faces(:,1)];
        
        % identify unique edges
        [obj.Edges, ~, ib] = unique(sort(edges, 2), 'rows');
        nEdges = size(obj.Edges, 1);
        
        % create linear array of face index for each edge in initial array
        nFaces = size(obj.Faces, 1);
        edgeFaces0 = repmat((1:nFaces)', 3, 1);
        
        % For each edge, retrieve index of the 1 or 2 adjacent face(s)
        obj.EdgeFaces = zeros(nEdges,2);
        for ie = 1:nEdges
            inds = edgeFaces0(ib == ie);
            obj.EdgeFaces(ie, 1:length(inds)) = inds;
        end
        % check manifold-ness of the mesh
        if size(obj.EdgeFaces, 2) > 2
            error('Non-manifold mesh: some edges are adjacent to more than two faces.');
        end

        % For each face, retrieve index of the 3 adjacent edges
        obj.FaceEdges = zeros(nFaces,3);
        for iFace = 1:nFaces
            obj.FaceEdges(iFace, :) = ib(edgeFaces0 == iFace);
        end
    end

    function edgeFaces = computeEdgeFaces(obj)
        % Update the property EdgeFaces.
        
        % ensure edge array is computed
        ensureValidEdges(obj);
        
        % allocate memory for result
        nEdges = size(obj.Edges, 1);
        obj.EdgeFaces = cell(1, nEdges);
        
        % iterate on faces
        nFaces = size(obj.Faces, 1);
        for iFace = 1:nFaces
            face = obj.Faces(iFace, :);
            
            % iterate on edges of current face
            for j = 1:3
                % vertex indices of current edge
                iv1 = face(j);
                iv2 = face(mod(j, 3) + 1);
                
                % do not process edges with same vertices
                if iv1 == iv2
                    continue;
                end
                
                iEdge = all(ismember(obj.Edges, [iv1 iv2]), 2);
                obj.EdgeFaces{iEdge} = [obj.EdgeFaces{iEdge} iFace];
            end
        end
        
        edgeFaces = obj.EdgeFaces;
    end
    
    function computeFaceEdges(obj)
        % Update the property FaceEdges.
        %
        % Used by:
        %   subdivide
        
        % ensure edge array is computed (edges are sorted)
        ensureValidEdges(obj);
        
        % allocate result
        nFaces = faceCount(obj);
        obj.FaceEdges = zeros(nFaces, 3);
        
        % compute edge indices for each face
        for iFace = 1:nFaces
            % extract vertex indices of current face
            face = obj.Faces(iFace, :);
            
            % for each pair of adjacent vertices, find the index of the matching
            % row in the edges array
            fei = zeros(1, 3);
            for iEdge = 1:3
                % compute index of each edge vertex
                edge = sort([face(iEdge) face(mod(iEdge, 3) + 1)]);
                v1 = edge(1);
                v2 = edge(2);
                
                % find the matching row
                ind = find(obj.Edges(:,1) == v1 & obj.Edges(:,2) == v2);
                fei(iEdge) = ind;
            end
            obj.FaceEdges(iFace, :) = fei;
        end
    end
end


%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization.
        str = struct('Type', 'mv.TriMesh', ...
            'Vertices', obj.Vertices, ...
            'Faces', obj.Faces);
        if ~isempty(obj.Edges)
            str.edges = obj.Edges;
        end
    end
end

methods (Static)
    function mesh = fromStruct(str)
        % Create a new instance from a structure.
        
        names = fieldnames(str);
        indV = find(strcmpi(names, 'vertices'), 1);
        indF = find(strcmpi(names, 'faces'), 1);
        
        if isempty(indV) || isempty(indF)
            error('Requires struct with two fields "vertices" and "faces"');
        end
        if size(str.(names{indF}), 2) ~= 3
            error('Requires a triangular face array');
        end

        mesh = mv.TriMesh(str.(names{indV}), str.(names{indF}));
    end
end

end