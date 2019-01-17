classdef ToggleLight < mv.gui.Plugin
% Toggle display of light source in scene
%
%   Class ToggleLight
%
%   Example
%   ToggleLight
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-07-02,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = ToggleLight(varargin)
    % Constructor for ToggleLight class
    end
end % end constructors


%% Methods
methods
    function run(this, frame, src, evt) %#ok<INUSL>
        
        % get widgets of main axis
        ax = frame.handles.mainAxis;

        % toggle light state
        options = frame.scene.displayOptions;
        options.lightVisible = ~options.lightVisible;

        % ensure light object exists
        if isempty(frame.scene.lightHandle)
            frame.scene.lightHandle = light('Parent', ax);
        end
        
        % update display depending on light state
        if options.lightVisible
            % make it visible
            set(frame.scene.lightHandle, 'Visible', 'on');
        else
            % make it invisible
            set(frame.scene.lightHandle, 'Visible', 'off');
        end
    end
    
end % end methods

end % end classdef

