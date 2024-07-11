classdef SetAxisViewAngle < mv.gui.Plugin
% Open a dialog to choose view angle of current axis.
%
%   Class SetAxisViewAngle
%
%   Example
%   SetAxisViewAngle
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2024-07-11,    using Matlab 24.1.0.2628055 (R2024a) Update 4
% Copyright 2024 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = SetAxisViewAngle(varargin)
        % Constructor for SetAxisViewAngle class.

    end

end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>

        % default values
        ax = frame.Handles.MainAxis;
        [azim, elev] = view(ax);

        % create dialog for choosing azimut and angle
        gd = GenericDialog('Intersect with Plane');
        addNumericField(gd, 'Azimut: ', azim, 0);
        addNumericField(gd, 'Elevation: ', elev, 0);
        gd.setSize([300 150]);
        showDialog(gd);
        if wasCanceled(gd)
            return;
        end
            
        % parse user choices
        azim = getNextNumber(gd);
        elev = getNextNumber(gd);

        % apply change of view angle
        view(ax, azim, elev);
    end 
end % end methods

end % end classdef

