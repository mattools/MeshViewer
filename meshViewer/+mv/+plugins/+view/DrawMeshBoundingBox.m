classdef DrawMeshBoundingBox < mv.gui.Plugin
% One-line description here, please.
%
%   Class DrawMeshBoundingBox
%
%   Example
%   DrawMeshBoundingBox
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2025-02-27,    using Matlab 24.2.0.2712019 (R2024b)
% Copyright 2025 INRAE - BIA-BIBS.

%% Constructor
methods
    function obj = DrawMeshBoundingBox(varargin)
        % Constructor for DrawMeshBoundingBox class.

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
            v = mh.Mesh.Vertices;
            
            box = boundingBox3d(v);
            
            name = sprintf('%s-bbox', mh.Name);
            item = mv.app.DrawItem(name, 'BoundingBox3D', box);
            item.DisplayOptions.LineWidth = 1;
            item.DisplayOptions.LineColor = [0 0 0];

            addDrawItem(frame.Scene, item);
        end
        
        updateDrawItemList(frame);
        updateDisplay(frame);
    end        
end % end methods

end % end classdef

