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
    
    axisLinesVisible = true;
end % end properties


%% Constructor
methods
    function this = Scene(varargin)
    % Constructor for Scene class

    end

end % end constructors


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
        

%         % ensure the name associated to the mesh handle is unique for the
%         % scene
%         if hasMeshWithName(this, name)
%             % remove trailing digits if any
%             baseName = removeTrailingDigits(name);
%             pattern = '%s-%d';
%             index = 1;
%             
%             name = sprintf(pattern, baseName, index);
%             while hasMeshWithName(this, name)
%                 index = index + 1;
%                 name = sprintf(pattern, baseName, index);
%             end
%         end
%         
%         % encapsulate the mesh into MeshHandle
%         mh = mv.app.MeshHandle(mesh, name);
%         
%         function name = removeTrailingDigits(name)
%             while ismember(name(end), '1234567890')
%                 name(end) = [];
%             end
%             if name(end) == '-'
%                 name(end) = [];
%             end
%         end
    end
    
    function newName = getNextFreeName(this, baseName)
        % ensure the name associated to the mesh handle is unique for the
        % scene
        
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
            if strcmp(mh.id, name)
                tf = true;
                return;
            end
        end
    end
end

end % end classdef

