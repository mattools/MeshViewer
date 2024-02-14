classdef Scene < handle
%SCENE A scene that contains several meshes.
%
%   Class Scene
%
%   Example
%   Scene
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-05-23,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
    % set of mesh handles within this scene, as a cell array.
    MeshHandleList;
    
    % the set of display options for the scene, as an instance of
    % mv.app.SceneDisplayOptions.
    % Used to initialize the axis.
    DisplayOptions;
    
    % base directory for saving data
    BaseDir = pwd;
    
end % end properties


%% Constructor
methods
    function obj = Scene(varargin)
    % Constructor for Scene class.

        obj.DisplayOptions = mv.app.SceneDisplayOptions();
    end

end % end constructors


%% General use methods
methods
    function bbox = updateBoundingBox(obj)
        % recomputes the bounding box from the list of meshes.

        % compute the bounding box
        bbox = computeBoundingBox(obj);
        
        % update display
        setViewBox(obj.DisplayOptions, bbox);
    end

    function bbox = computeBoundingBox(obj)
        % Compute the bounding box of the list of meshes.
        %
        % Does not modify scene display options.
        %

        % default bounding box
        bbox = viewBox(obj.DisplayOptions);
        
        % if scene contains at least one mesh, recompute the bounding box
        % as the enclosing box of all meshes
        nMeshes = length(obj.MeshHandleList);
        if nMeshes > 0
            % use initial infinite bounds
            bbox = [inf -inf  inf -inf  inf -inf];
            
            % compute bounding box that encloses all meshes
            for iMesh = 1:nMeshes
                mh = obj.MeshHandleList{iMesh};
                bbox = mergeBoxes3d(bbox, boundingBox3d(mh.Mesh.Vertices));
            end
        end
    end
end

%% Management of mesh handles
methods
    function addMeshHandle(obj, mh)
        obj.MeshHandleList = [obj.MeshHandleList {mh}];
    end
    
    function removeMeshHandle(obj, mh)
        ind = -1;
        for i = 1:length(obj.MeshHandleList)
            if obj.MeshHandleList{i} == mh
                ind = i;
                break;
            end
        end
        
        if ind == -1
            error('could not find the mesh handle');
        end
        
        obj.MeshHandleList(ind) = [];
    end
    
    function meshHandleList = getMeshHandles(obj)
        meshHandleList = obj.MeshHandleList;
    end
    
    function b = hasMeshHandles(obj)
        b = ~isempty(obj.MeshHandleList);
    end
    
    function mh = createMeshHandle(obj, varargin)
        % Return a formatted mesh handle or empty.
        %
        % Usages
        %   MH = createMeshHandle(obj)
        %   MH = createMeshHandle(obj, mesh)
        %   MH = createMeshHandle(obj, mesh, initName)
        %
        % Input arguments:
        %   obj: the instance of Scene
        %   mesh: an instance of TriMesh or MeshHandle
        %   initName: initial proposal for name. If already exists within the
        %     scene, appends a suffix
        % Output:
        %   MH is an instance of mv.app.MeshHandle
        %
        % See also
        %   mv.app.MeshHandle, mv.TriMesh

        % special case of no mesh
        if isempty(varargin)
            mh = [];
            return;
        end
        
        % check mesh is already mesh handle
        mesh = varargin{1};
        if isa(mesh, 'mv.app.MeshHandle')
            mh = mesh;
            
            % check name validity
            if hasMeshWithName(obj, mh.Name)
                mh.name = getNextFreeName(obj, mh.Name);
            end
            return;
        end
        
        % default name for mesh
        name = '[NoName]';

        % in case of a struct, try convert to mesh
        if isstruct(mesh)
            if isfield(mesh, 'name')
                name = mesh.name;
            end
            mesh = mv.TriMesh(mesh);
        end

        if ~isa(mesh, 'mv.TriMesh')
            error('Requires either a MeshHandle or a TriMesh');
        end
        
        % Checks if mesh name was specified
        if length(varargin) > 1
            name = varargin{2};
        end

        % choose a unique name
        name = getNextFreeName(obj, name);

        % encapsulate the mesh into MeshHandle
        mh = mv.app.MeshHandle(mesh, name);
    end
    
    function newName = getNextFreeName(obj, baseName)
        % Find a new name ensuring it is unique within the scene.
        
        newName = baseName;
        if hasMeshWithName(obj, newName)
            % remove trailing digits if any
            baseName = removeTrailingDigits(baseName);
            pattern = '%s-%d';
            index = 1;
            
            % find the first index such that no mesh already exist with the
            % name: "[baseName]-[index]"
            while true
                newName = sprintf(pattern, baseName, index);
                if ~hasMeshWithName(obj, newName)
                    break;
                end
                index = index + 1;
            end
        end
        
        function name = removeTrailingDigits(name)
            while ismember(name(end), '1234567890')
                name(end) = [];
            end
            if name(end) == '-'
                name(end) = [];
            end
        end
    end
    
    function tf = hasMeshWithName(obj, name)
        tf = false;
        for i = 1:length(obj.MeshHandleList)
            mh = obj.MeshHandleList{i};
            if strcmp(mh.Name, name)
                tf = true;
                return;
            end
        end
    end
end

end % end classdef

