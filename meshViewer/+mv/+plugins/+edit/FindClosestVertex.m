classdef FindClosestVertex < mv.gui.Plugin
% One-line description here, please.
%
%   Class FindClosestVertex
%
%   Example
%   FindClosestVertex
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
    function obj = FindClosestVertex(varargin)
        % Constructor for FindClosestVertex class.

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

        % creates a new dialog, and populates with query point coordinates
        gd = GenericDialog('Point Coordinates');
        addNumericField(gd, 'X: ', 0, 2);
        addNumericField(gd, 'Y: ', 0, 2);
        addNumericField(gd, 'Z: ', 0, 2);

        % displays the dialog, and waits for user
        showDialog(gd);
        % check if ok or cancel button was clicked
        if wasCanceled(gd)
            return;
        end

        % retrieve the user inputs
        px = getNextNumber(gd);
        py = getNextNumber(gd);
        pz = getNextNumber(gd);
        point = [px py pz];
        
        for iMesh = 1:length(meshList)
            % get data for current mesh
            mh = meshList{iMesh};

            [dist, ind] = minDistancePoints(point, mh.Mesh.Vertices);
            coords = mh.Mesh.Vertices(ind, :);
            
            fprintf('[%d] closest vertex index=%d, coords=[%g,%g,%g], dist = %g\n', ...
                iMesh, ind, coords, dist);
        end
        
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef

