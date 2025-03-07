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
    % A name for the scene.
    Name;

    % set of mesh handles within this scene, as a cell array.
    MeshHandleList;
    
    % set of items to draw, as a cell array.
    DrawItems = {};
    
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
            if hasItemWithName(obj.MeshHandleList, mh.Name)
                mh.name = getNextFreeName(obj.MeshHandleList, mh.Name);
            end
            % if hasMeshWithName(obj, mh.Name)
            %     mh.name = getNextFreeName(obj, mh.Name);
            % end
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
        name = getNextFreeName(obj.MeshHandleList, name);
        % name = getNextFreeName(obj, name);

        % encapsulate the mesh into MeshHandle
        mh = mv.app.MeshHandle(mesh, name);
    end
    
    function addDrawItem(obj, item)
        % Add a draw item to the scene.
        % The name of the item could be updated to ensure uniqueness.

        % check mesh is already mesh handle
        if ~isa(item, 'mv.app.DrawItem')
            error('Input must be an instance of DrawItem');
        end
            
        % check name validity
        if hasItemWithName(obj.DrawItems, item.Name)
            item.Name = getNextFreeName(obj.DrawItems, item.Name);
        end

        % add item to the list
        obj.DrawItems = [obj.DrawItems {item}];
    end
end


%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization.
        
        % create structure with necessary fields
        str.Type = 'mv.app.Scene';
        str.Name = obj.Name;
        str.BaseDir = obj.BaseDir;
        str.DisplayOptions = toStruct(obj.DisplayOptions);
        str.MeshHandleList = cellfun(@toStruct, obj.MeshHandleList);
    end
    
    function write(obj, fileName, varargin)
        % Write into a JSON file.
        savejson('', toStruct(obj), 'FileName', fileName, varargin{:});
    end
end

methods (Static)
    function scene = fromStruct(str)
        % Create a new instance from a structure.
        
        % create an empty options object
        scene = mv.app.Scene();

        % parse optionnal fields
        names = fieldnames(str);
        for i = 1:length(names)
            name = names{i};
            if strcmpi(name, 'Type')
                % do nothing
            elseif strcmpi(name, 'Name')
                scene.Name = str.(name);
            elseif strcmpi(name, 'MeshHandleList')
                meshStructs = str.(name);
                nMeshes = length(meshStructs);
                scene.MeshHandleList = cell(1, nMeshes);
                for iMesh = 1:nMeshes
                    mh = mv.app.MeshHandle.fromStruct(meshStructs(iMesh));
                    scene.MeshHandleList{iMesh} = mh;
                end
            elseif strcmpi(name, 'DisplayOptions')
                scene.DisplayOptions = mv.app.SceneDisplayOptions.fromStruct(str.(name));
            elseif strcmpi(name, 'BaseDir')
                scene.BaseDir = str.(name);
            else
                warning(['Unknown Scene parameter: ' name]);
            end
        end
    end
    
    function axis = read(fileName)
        % Read a SceneDisplayOptions object from a file in JSON format.
        axis = mv.app.Scene.fromStruct(loadjson(fileName));
    end
end

end % end classdef

%% Utility classes

function newName = getNextFreeName(itemList, baseName)
    % Find a new name ensuring it is unique within the scene.
    
    newName = baseName;
    if hasItemWithName(itemList, newName)
        % remove trailing digits if any
        baseName = removeTrailingDigits(baseName);
        pattern = '%s-%d';
        index = 1;
        
        % find the first index such that no item already exist with the
        % name: "[baseName]-[index]"
        while true
            newName = sprintf(pattern, baseName, index);
            if ~hasItemWithName(itemList, newName)
                break;
            end
            index = index + 1;
        end
    end
end

function tf = hasItemWithName(itemList, name)
% Check whether the input list of item has one with the specified name.
    tf = false;
    for i = 1:length(itemList)
        item = itemList{i};
        if strcmp(item.Name, name)
            tf = true;
            return;
        end
    end
end

function name = removeTrailingDigits(name)
    % Remove trailing digits (and dash symbol if any) of a name.
    while ismember(name(end), '1234567890')
        name(end) = [];
    end
    if name(end) == '-'
        name(end) = [];
    end
end
