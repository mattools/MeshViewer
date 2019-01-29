classdef Scene < handle
%SCENE A scene that contains several meshes
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
    % set of mesh handles within this scene, as a cell array
    meshHandleList;
    
    % the set of display options for the scene, as a struct.
    % Used to initialize the axis.
    displayOptions;
    
    % base directory for saving data
    baseDir = pwd;
    
end % end properties


%% Constructor
methods
    function this = Scene(varargin)
    % Constructor for Scene class

        this.displayOptions = mv.app.SceneDisplayOptions();
    end

end % end constructors


%% General use methods
methods
    function bbox = updateBoundingBox(this)
        % recomputes the bounding box from the list of meshes

        % default bounding box
        bbox = [-1 1  -1 1  -1 1];
        
        % if scene containes meshes, recomputes bounding boxes as the
        % enclosing box of all meshes
        nMeshes = length(this.meshHandleList);
        if nMeshes > 0
            % use initial infinite bounds
            bbox = [inf -inf  inf -inf  inf -inf];
            
            % compute bounding box that encloses all meshes
            for iMesh = 1:nMeshes
                mh = this.meshHandleList{iMesh};
                bbox = mergeBoxes3d(bbox, boundingBox3d(mh.mesh.vertices));
            end
        end
        
        % set up new bounding box
        setViewBox(this.displayOptions, bbox);
    end
end

%% Management of mesh handles
methods
    function addMeshHandle(this, mh)
        this.meshHandleList = [this.meshHandleList {mh}];
    end
    
    function removeMeshHandle(this, mh)
        ind = -1;
        for i = 1:length(this.meshHandleList)
            if this.meshHandleList{i} == mh
                ind = i;
                break;
            end
        end
        
        if ind == -1
            error('could not find the mesh handle');
        end
        
        this.meshHandleList(ind) = [];
    end
    
    function meshHandleList = getMeshHandles(this)
        meshHandleList = this.meshHandleList;
    end
    
    function b = hasMeshHandles(this)
        b = ~isempty(this.meshHandleList);
    end
    
    function mh = createMeshHandle(this, varargin)
        % Return a formatted mesh handle or empty
        %
        % Usages
        %   createMeshHandle(gui)
        %   createMeshHandle(gui, mesh)
        %   createMeshHandle(gui, mesh, initName)
        %
        % mesh: an instance of TriMesh or MeshHandle
        % initName: initial proposal for name. If already exists within the
        %   scene, appends a suffix
        
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
            if hasMeshWithName(this, mh.name)
                mh.name = getNextFreeName(this, mh.name);
            end
            return;
        end
        
        if ~isa(mesh, 'TriMesh')
            error('Requires either a MeshHandle or a TriMesh');
        end
        
        % Checks if mesh name was specified
        if length(varargin) < 2
            name = '[NoName]';
        else
            name = varargin{2};
        end

        % choose a unique name
        name = getNextFreeName(this, name);

        % encapsulate the mesh into MeshHandle
        mh = mv.app.MeshHandle(mesh, name);
    end
    
    function newName = getNextFreeName(this, baseName)
        % ensure the name associated to the mesh handle is unique for the scene
        
        newName = baseName;
        if hasMeshWithName(this, newName)
            % remove trailing digits if any
            newName = removeTrailingDigits(newName);
            pattern = '%s-%d';
            index = 1;
            
            newName = sprintf(pattern, newName, index);
            while hasMeshWithName(this, newName)
                index = index + 1;
                newName = sprintf(pattern, newName, index);
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
    
    function tf = hasMeshWithName(this, name)
        tf = false;
        for i = 1:length(this.meshHandleList)
            mh = this.meshHandleList{i};
            if strcmp(mh.name, name)
                tf = true;
                return;
            end
        end
    end
end

end % end classdef

