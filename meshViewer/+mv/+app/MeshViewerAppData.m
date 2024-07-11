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
    % The set of mesh handles managed by obj application, as a cell array.
    MeshList;

    % a flag for debugging.
    Debug = false;

end % end properties


%% Constructor
methods
    function obj = MeshViewerAppData(varargin)
    % Constructor for MeshViewerApp class

    end

end % end constructors


%% Management of mesh handles
methods
    function addMeshHandle(obj, mh)
        obj.MeshList = [obj.MeshList {mh}];
    end
    
    function removeMeshHandle(obj, mh)
        ind = -1;
        for i = 1:length(obj.MeshList)
            if obj.MeshList{i} == mh
                ind = i;
                break;
            end
        end
        
        if ind == -1
            error('could not find the mesh handle');
        end
        
        obj.MeshList(ind) = [];
    end
    
    function meshList = getMeshHandles(obj)
        meshList = obj.MeshList;
    end
    
    function b = hasMeshHandles(obj)
        b = ~isempty(obj.MeshList);
    end
    
end

end % end classdef

