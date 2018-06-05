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
    % set of mesh handles managed by this application
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
    
end

end % end classdef

