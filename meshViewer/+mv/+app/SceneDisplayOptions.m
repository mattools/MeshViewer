classdef SceneDisplayOptions < handle
%SCENEDISPLAYOPTIONS The different options that control the display of a Scene
%
%   Class SceneDisplayOptions
%
%   Example
%   SceneDisplayOptions
%
%   See also
%     mv.app.Scene

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-01-17,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    % Description of x-axis, as a SceneAxis instance
    xAxis;
    
    % Description of y-axis, as a SceneAxis instance
    yAxis;
    
    % Description of z-axis, as a SceneAxis instance
    zAxis;

%     % an optional background image, as an instance of ImageNode
%     % (used in Shape project, but not in MeshViewer)
%     backgroundImage;
    
    % indicates whether main axes are visible or not (boolean)
    axisLinesVisible = true;
    
end % end properties


%% Constructor
methods
    function this = SceneDisplayOptions(varargin)
        % Constructor for DisplayOptions class
        
        % create new axes
        this.xAxis = mv.app.SceneAxis();
        this.yAxis = mv.app.SceneAxis();
        this.zAxis = mv.app.SceneAxis();
    end

end % end constructors


%% Methods
methods
    function box = viewBox(this)
        % Compute the view box from the limits on the different axes
        box = [this.xAxis.limits this.yAxis.limits this.zAxis.limits];
    end
    
    function setViewBox(this, box)
        % set axes limits from viewbox values
        this.xAxis.limits = box(1:2);
        this.yAxis.limits = box(3:4);
        if length(box) > 4
            this.zAxis.limits = box(5:6);
        end
    end
end % end methods

end % end classdef

