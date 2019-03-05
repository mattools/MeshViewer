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
    function obj = ToggleAxisLinesDisplay(varargin)
    % Constructor for ToggleAxisLinesDisplay class
    end
end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        % toggle options state
        options = frame.Scene.DisplayOptions;
        options.AxisLinesVisible = ~options.AxisLinesVisible;

        % update associated graphical elements
        updateAxisLinesDisplay(frame.SceneRenderer);
    end
    
end % end methods

end % end classdef

