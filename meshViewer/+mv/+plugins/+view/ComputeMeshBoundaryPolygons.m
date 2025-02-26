classdef ComputeMeshBoundaryPolygons < mv.gui.Plugin
% One-line description here, please.
%
%   Class ComputeMeshBoundaryPolygons
%
%   Example
%   ComputeMeshBoundaryPolygons
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2024-09-10,    using Matlab 24.1.0.2628055 (R2024a) Update 4
% Copyright 2024 INRAE - BIA-BIBS.


%% Constructor
methods
    function obj = ComputeMeshBoundaryPolygons(varargin)
        % Constructor for ComputeMeshBoundaryPolygons class.

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
            f = mh.Mesh.Faces;
            
            bnd = meshBoundary(v, f);
            
            % mh.BoundaryPolygons = bnd;
            item = mv.app.DrawItem('boundary', 'Polygon3D', bnd);
            item.DisplayOptions.LineWidth = 2;
            item.DisplayOptions.LineColor = [1 0 1];

            addDrawItem(frame.Scene, item);
        end
        
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef

