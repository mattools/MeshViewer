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

%% Static factories
methods (Static)
    mesh = createCube()
    mesh = createOctahedron(varargin)
    mesh = createIcosahedron(varargin)
    mesh = createDodecahedron(varargin)
    mesh = createTetrahedron(varargin)
    mesh = createCubeOctahedron(varargin)
    mesh = createRhombododecahedron(varargin)
    mesh = createTruncatedOctahedron(varargin)
    mesh = createSoccerBall(varargin)
end


%% Properties
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
    
    % Some geometrical informations (may be managed by properties)
    FaceNormals = [];
    EdgeNormals = [];
    VertexNormals = [];

    % A map of properties for each vertex
    VertexProperties;
    % A map of properties for each edge
    EdgeProperties;
    % A map of properties for each face
    FaceProperties;
end


%% Constructor
methods
    function obj = TriMesh(varargin)
        % Create a new mesh.
        %
        %  Usage:
        %   MESH = mv.TriMesh(V, F);
        %   MESH = mv.TriMesh(MESHSTRUCT);
        
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
        if size(obj.Faces, 2) > 3 || iscell(obj.Faces)
            obj.Faces = triangulateFaces(obj.Faces);
        end

        % initialize properties
        obj.VertexProperties = containers.Map;
        obj.EdgeProperties = containers.Map;
        obj.FaceProperties = containers.Map;
    end
end


%% Geometric information about mesh
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
        %   faceArea, volume, meanBreadth, 
        %   meshSurfaceArea
        
        % sum up and normalize
        area = sum(faceArea(obj));
    end
    
    function areas = faceArea(obj)
        % Compute the area of each face within the mesh.

        % compute two direction vectors of each triangular face, using the
        % first vertex of each face as origin
        v1 = obj.Vertices(obj.Faces(:, 2), :) - obj.Vertices(obj.Faces(:, 1), :);
        v2 = obj.Vertices(obj.Faces(:, 3), :) - obj.Vertices(obj.Faces(:, 1), :);
        
        % area of each triangle is half the cross product norm
        areas = vectorNorm3d(crossProduct3d(v1, v2)) / 2;
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


%% Management of Edge properties

methods
    function setEdgeProperties(obj, propName, propValues)
        % Set an edge property for all edges in the mesh.
        % 
        % Usage:
        %   setEdgeProperties(MESH, PROPNAME, VALUES);
        % PROPNAME must be a char array. VALUES must be either a numeric
        % array or a cell array with a size in the first dimension equal to
        % the number of edges. 
        %
        % Example:
        %  normals = randn(edgeCount(mesh),3);
        %  setEdgeProperties(mesh, 'normal', normals);
        ensureValidEdges(obj);
        obj.EdgeProperties(propName) = propValues;
    end

    function value = getEdgeProperty(obj, propName, iEdge)
        % Return the property value of a given edge.
        %
        % Usage:
        %   VALUE = getEdgeProperty(MESH, PROPNAME, IEDGE);
        % PROPNAME must be a char array. IEDGE is the index of the edge,
        % between 1 and the edge count.
        
        if ~isKey(obj.EdgeProperties, propName)
            error('Mesh has no edge property with name %s', propName);
        end
        props = obj.EdgeProperties(propName);
        if isnumeric(props)
            value = props(iEdge, :);
        elseif iscell(props)
            value = props{iEdge};
        else
            error('Property must by either a numeric or a cell array');
        end
    end

    function setEdgeProperty(obj, propName, iEdge, value)
        % Change the property value of a given edge.
        %
        % Usage:
        %   setEdgeProperty(MESH, PROPNAME, IEDGE, NEWVALUE);
        % PROPNAME must be a char array. IEDGE is the index of the edge,
        % between 1 and the edge count. NEWVALUE is the new value of the
        % property for the selected edge.

        ensureValidEdges(obj);

        if isKey(obj.EdgeProperties, propName)
            props = obj.EdgeProperties(propName);
            if isnumeric(value)
                props(iEdge, :) = value;
            elseif iscell(value)
                props(iEdge) = value;
            else
                error('Property value must by either a numeric or a cell');
            end
            obj.EdgeProperties(propName) = props;
        else
            % initialize default property
            ne = edgeCount(obj);
            if isnumeric(value)
                props = zeros(ne, size(value, 2));
                props(iEdge, :) = value;
            elseif iscell(value)
                props = cell(ne, 1);
                props(iEdge) = value;
            else
                error('Property value must by either a numeric or a cell');
            end
            obj.EdgeProperties(propName) = props;
        end
    end
end

%% Management of Vertex properties

methods
    function setVertexProperties(obj, propName, propValues)
        % Set a vertex property for all vertices in the mesh.
        % 
        % Usage:
        %   setVertexProperties(MESH, PROPNAME, VALUES);
        % PROPNAME must be a char array. VALUES must be either a numeric
        % array or a cell array with a size in the first dimension equal to
        % the number of vertices. 
        %
        % Example:
        %  normals = randn(vertexCount(mesh),3);
        %  setVertexProperties(mesh, 'normal', normals);
        obj.VertexProperties(propName) = propValues;
    end

    function value = getVertexProperty(obj, propName, iVertex)
        % Return the property value of a given vertex.
        %
        % Usage:
        %   VALUE = getVertexProperty(MESH, PROPNAME, IVERTEX);
        % PROPNAME must be a char array. IVERTEX is the index of the vertex,
        % between 1 and the vertex count.
        if ~isKey(obj.VertexProperties, propName)
            error('Mesh has no vertex property with name %s', propName);
        end
        props = obj.VertexProperties(propName);
        if isnumeric(props)
            value = props(iVertex, :);
        elseif iscell(props)
            value = props{iVertex};
        else
            error('Property must by either a numeric or a cell array');
        end
    end

    function setVertexProperty(obj, propName, iVertex, value)
        % Change the property value of a given vertex.
        %
        % Usage:
        %   setVertexProperty(MESH, PROPNAME, IVERTEX, NEWVALUE);
        % PROPNAME must be a char array. IVERTEX is the index of the vertex,
        % between 1 and the vertex count. NEWVALUE is the new value of the
        % property for the selected vertex.
        if isKey(obj.VertexProperties, propName)
            props = obj.VertexProperties(propName);
            if isnumeric(value)
                props(iVertex, :) = value;
            elseif iscell(value)
                props(iVertex) = value;
            else
                error('Property value must by either a numeric or a cell');
            end
            obj.VertexProperties(propName) = props;
        else
            % initialize default property
            nv = vertexCount(obj);
            if isnumeric(value)
                props = zeros(nv, size(value, 2));
                props(iVertex, :) = value;
            elseif iscell(value)
                props = cell(nv, 1);
                props(iVertex) = value;
            else
                error('Property value must by either a numeric or a cell');
            end
            obj.VertexProperties(propName) = props;
        end
    end
end


%% Management of Face properties

methods
    function setFaceProperties(obj, propName, propValues)
        % Set a face property for all faces in the mesh.
        % 
        % Usage:
        %   setFaceProperties(MESH, PROPNAME, VALUES);
        % PROPNAME must be a char array. VALUES must be either a numeric
        % array or a cell array with a size in the first dimension equal to
        % the number of faces. 
        %
        % Example:
        %  normals = randn(faceCount(mesh),3);
        %  setFaceProperties(mesh, 'normal', normals);
        obj.FaceProperties(propName) = propValues;
    end

    function value = getFaceProperty(obj, propName, iFace)
        % Return the property value of a given face.
        %
        % Usage:
        %   VALUE = getFaceProperty(MESH, PROPNAME, IFACE);
        % PROPNAME must be a char array. IFACE is the index of the face,
        % between 1 and the face count.
        if ~isKey(obj.FaceProperties, propName)
            error('Mesh has no face property with name %s', propName);
        end
        props = obj.FaceProperties(propName);
        if isnumeric(props)
            value = props(iFace, :);
        elseif iscell(props)
            value = props{iFace};
        else
            error('Property must by either a numeric or a cell array');
        end
    end

    function setFaceProperty(obj, propName, iFace, value)
        % Change the property value of a given face.
        %
        % Usage:
        %   setFaceProperty(MESH, PROPNAME, IFACE, NEWVALUE);
        % PROPNAME must be a char array. IFACE is the index of the face,
        % between 1 and the face count. NEWVALUE is the new value of the
        % property for the selected face.
        if isKey(obj.FaceProperties, propName)
            props = obj.FaceProperties(propName);
            if isnumeric(value)
                props(iFace, :) = value;
            elseif iscell(value)
                props(iFace) = value;
            else
                error('Property value must by either a numeric or a cell');
            end
            obj.FaceProperties(propName) = props;
        else
            % initialize default property
            nf = faceCount(obj);
            if isnumeric(value)
                props = zeros(nf, size(value, 2));
                props(iFace, :) = value;
            elseif iscell(value)
                props = cell(nf, 1);
                props(iFace) = value;
            else
                error('Property value must by either a numeric or a cell');
            end
            obj.FaceProperties(propName) = props;
        end
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


%% Display methods
% (Mostly used for debugging purpose)
methods
    function varargout = draw(varargin)
        % Display the mesh.
        %
        %   draw(MESH)
        %   Display the mesh with default settings.
        %
        %   draw(MESH, COLOR)
        %   Display the mesh using the specified color for faces.
        %
        %   draw(AX, ...)
        %   Display the mesh on the specified axis.
        

        % extract first argument
        var1 = varargin{1};
        varargin(1) = [];

        % Check if first input argument is an axes handle
        if isAxisHandle(var1)
            ax = var1;
            var1 = varargin{1};
            varargin(1) = [];
        else
            ax = gca;
        end

        obj = var1;

        % default color for drawing mesh
        faceColor = [0.7 0.7 0.7];
        % combine default face color with varargin
        if isempty(varargin)
            varargin = [{'FaceColor'}, faceColor];
        elseif isscalar(varargin)
            % if only one optional argument is provided, it is assumed to be color
            faceColor = varargin{1};
            varargin = [{'FaceColor'}, faceColor];
        elseif length(varargin) > 1
            % check if FaceColor option is specified,
            % and if not use default face color
            indFC = strcmpi(varargin(1:2:end), 'FaceColor');
            if ~any(indFC)
                varargin = [{'FaceColor'}, {faceColor}, varargin];
            end
        end

        % overwrite on current figure
        hold(ax, 'on');

        h = patch('Parent', ax, ...
            'vertices', obj.Vertices, 'faces', obj.Faces, ...
            varargin{:});

        % format output parameters
        if nargout > 0
            varargout = {h};
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