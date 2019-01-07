classdef MeshViewerAppData < handle
%MESHVIEWERAPP Contains data of a MeshViewer instance
%
%   Class MeshViewerApp
%
%   Example
%   MeshViewerApp
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2018-05-23,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
    % set of mesh handles managed by this application
    meshList;
end % end properties


%% Constructor
methods
    function this = MeshViewerAppData(varargin)
    % Constructor for MeshViewerApp class

    end

end % end constructors


%% Management of mesh handles
methods
    function addMeshHandle(this, mh)
        this.meshList = [this.meshList {mh}];
    end
    
    function removeMeshHandle(this, mh)
        ind = -1;
        for i = 1:length(this.meshList)
            if this.meshList{i} == mh
                ind = i;
                break;
            end
        end
        
        if ind == -1
            error('could not find the mesh handle');
        end
        
        this.meshList(ind) = [];
    end
    
    function meshList = getMeshHandles(this)
        meshList = this.meshList;
    end
    
    function b = hasMeshHandles(this)
        b = ~isempty(this.meshList);
    end
    
end

end % end classdef

