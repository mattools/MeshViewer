classdef AddPlaneDrawItem < handle
% One-line description here, please.
%
%   Class AddPlaneDrawItem
%
%   Example
%   AddPlaneDrawItem
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2025-02-27,    using Matlab 24.2.0.2712019 (R2024b)
% Copyright 2025 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = AddPlaneDrawItem(varargin)
        % Constructor for AddPlaneDrawItem class.

    end

end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>

        % default values
        ax = frame.Handles.MainAxis;
        bounds = axis(ax);
        x0 = mean(bounds([1 2]));
        y0 = mean(bounds([3 4]));
        z0 = mean(bounds([5 6]));
        dx = 0; 
        dy = 0;
        dz = 1;

        % create dialog for choosing azimut and angle
        gd = GenericDialog('Add Plane Item');
        addNumericField(gd, 'Origin X: ', x0, 2);
        addNumericField(gd, 'Origin Y: ', y0, 2);
        addNumericField(gd, 'Origin Z: ', z0, 2);
        addNumericField(gd, 'Normal X: ', dx, 2);
        addNumericField(gd, 'Normal Y: ', dy, 2);
        addNumericField(gd, 'Normal Z: ', dz, 2);
        gd.setSize([300 300]);
        showDialog(gd);
        if wasCanceled(gd)
            return;
        end
            
        % parse user choices
        x0 = getNextNumber(gd);
        y0 = getNextNumber(gd);
        z0 = getNextNumber(gd);
        dx = getNextNumber(gd);
        dy = getNextNumber(gd);
        dz = getNextNumber(gd);

        % create plane
        plane = createPlane([x0 y0 z0], [dx dy dz]);
        
        % create draw item
        item = mv.app.DrawItem('plane', 'Plane3D', plane);
        item.DisplayOptions.FaceColor = [0 1 1];
        item.DisplayOptions.FaceOpacity = 0.5;
        addDrawItem(frame.Scene, item);
        
        updateDrawItemList(frame);
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef

