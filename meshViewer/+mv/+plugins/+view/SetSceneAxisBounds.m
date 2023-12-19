classdef SetSceneAxisBounds < mv.gui.Plugin
% Set up the visible bounds of the current scene.
%
%   Class SetSceneAxisBounds
%
%   Example
%   SetSceneAxisBounds
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2023-12-19,    using Matlab 23.2.0.2409890 (R2023b) Update 3
% Copyright 2023 INRAE - BIA-BIBS.


%% Properties
properties
    Frame;
    Handles;

end % end properties


%% Constructor
methods
    function obj = SetSceneAxisBounds(varargin)
        % Constructor for SetSceneAxisBounds class.

    end

end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>

        % retrieve current bounds
        bbox = viewBox(frame.Scene.DisplayOptions);
        % xlims = frame.Scene.DisplayOptions.XAxis.Limits;
        % ylims = frame.Scene.DisplayOptions.YAxis.Limits;    
        
        % create figure
        obj.Frame = frame;
        hFig = figure;
        obj.Handles.figure = hFig;

        % setup layout
        grid = uix.Grid('Parent', hFig, 'Spacing', 5, 'Padding', 10);
        uix.Empty('Parent', grid);
        uicontrol('Parent', grid, 'Style', 'Text', 'String', 'X-Axis');
        uicontrol('Parent', grid, 'Style', 'Text', 'String', 'Y-Axis');
        uicontrol('Parent', grid, 'Style', 'Text', 'String', 'Z-Axis');
        uix.Empty('Parent', grid);

        uicontrol('Parent', grid, 'Style', 'Text', 'String', 'Min.');
        obj.Handles.editXMin = uicontrol('Parent', grid, 'Style', 'edit', 'String', num2str(bbox(1)));
        obj.Handles.editYMin = uicontrol('Parent', grid, 'Style', 'edit', 'String', num2str(bbox(3)));
        obj.Handles.editZMin = uicontrol('Parent', grid, 'Style', 'edit', 'String', num2str(bbox(5)));
        obj.Handles.OKButton = uicontrol('Parent', grid, ...
            'Style', 'pushbutton', ...
            'String', 'OK', ...
            'Callback', @obj.onButtonOK);

        uicontrol('Parent', grid, 'Style', 'Text', 'String', 'Max.');
        obj.Handles.editXMax = uicontrol('Parent', grid, 'Style', 'edit', 'String', num2str(bbox(2)));
        obj.Handles.editYMax = uicontrol('Parent', grid, 'Style', 'edit', 'String', num2str(bbox(4)));
        obj.Handles.editZMax = uicontrol('Parent', grid, 'Style', 'edit', 'String', num2str(bbox(6)));
        uix.Empty('Parent', grid);

        set(grid, 'Widths', [-3 -2 -2], 'Heights', [-1 -1 -1 -1 -1]);
    end

end % end methods


%% Figure and control Callback
methods
    function onButtonOK(obj, varargin)
        
        xmin = str2double(get(obj.Handles.editXMin, 'String'));
        xmax = str2double(get(obj.Handles.editXMax, 'String'));
        ymin = str2double(get(obj.Handles.editYMin, 'String'));
        ymax = str2double(get(obj.Handles.editYMax, 'String'));
        zmin = str2double(get(obj.Handles.editZMin, 'String'));
        zmax = str2double(get(obj.Handles.editZMax, 'String'));
        close(obj.Handles.figure);

        obj.Frame.Scene.DisplayOptions.XAxis.Limits = [xmin xmax];
        obj.Frame.Scene.DisplayOptions.YAxis.Limits = [ymin ymax];
        obj.Frame.Scene.DisplayOptions.ZAxis.Limits = [zmin zmax];

        refreshDisplay(obj.Frame.SceneRenderer);
    end
end

end % end classdef

