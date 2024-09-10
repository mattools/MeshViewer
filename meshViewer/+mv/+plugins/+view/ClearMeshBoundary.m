classdef ClearMeshBoundary < mv.gui.Plugin
% One-line description here, please.
%
%   Class ClearMeshBoundary
%
%   Example
%   ClearMeshBoundary
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2024-09-10,    using Matlab 24.1.0.2628055 (R2024a) Update 4
% Copyright 2024 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ClearMeshBoundary(varargin)
        % Constructor for ClearMeshBoundary class.

    end

end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        meshList = selectedMeshHandleList(frame);
        if length(meshList) < 1
            helpdlg("Requires to select at least one input mesh(es).", "Selection Required");
            return;
        end
       
        for iMesh = 1:length(meshList)
            % get data for current mesh
            mh = meshList{iMesh};
            mh.BoundaryPolygons = {};
            mh.Handles.BoundaryPolygons = [];
        end
        
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef
