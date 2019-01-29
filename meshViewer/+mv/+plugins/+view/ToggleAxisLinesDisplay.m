classdef ToggleAxisLinesDisplay < mv.gui.Plugin
% Toggle display of light source in scene
%
%   Class ToggleAxisLinesDisplay
%
%   Example
%   ToggleAxisLinesDisplay
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-01-29,    using Matlab 9.4.0.813654 (R2018b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = ToggleAxisLinesDisplay(varargin)
    % Constructor for ToggleAxisLinesDisplay class
    end
end % end constructors


%% Methods
methods
    function run(this, frame, src, evt) %#ok<INUSL>
        
        % get widgets of main axis
        ax = frame.handles.mainAxis;

        % toggle options state
        options = frame.scene.displayOptions;
        options.axisLinesVisible = ~options.axisLinesVisible;

        % ensure line axis objects exist
        handles = frame.scene.handles;
        if isempty(handles.axisLineX)
            handles.axisLineX = drawLine3d(ax, [0 0 0  1 0 0], 'k');
            handles.axisLineY = drawLine3d(ax, [0 0 0  0 1 0], 'k');
            handles.axisLineZ = drawLine3d(ax, [0 0 0  0 0 1], 'k');
        end
        
        % set visibility depending on options
        hh = [handles.axisLineX, handles.axisLineY, handles.axisLineZ];
        if options.axisLinesVisible
            set(hh, 'Visible', 'on');
        else
            set(hh, 'Visible', 'off');
        end
    end
    
end % end methods

end % end classdef

