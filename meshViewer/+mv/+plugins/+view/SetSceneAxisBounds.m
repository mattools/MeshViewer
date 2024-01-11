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
        
        % create figure
        obj.Frame = frame;
        hFig = figure;
        obj.Handles.figure = hFig;

        % setup layout
        allLines = uix.VBox('Parent', hFig, 'Spacing', 0, 'Padding', 10);

        lineHeader = uix.HBox('Parent', allLines, 'Spacing', 5, 'Padding', 10);
        uix.Empty('Parent', lineHeader);
        uicontrol('Parent', lineHeader, 'Style', 'Text', 'String', 'Min.');
        uicontrol('Parent', lineHeader, 'Style', 'Text', 'String', 'Max.');
        set(lineHeader, 'Widths', [-3 -2 -2]);

        lineX = uix.HBox('Parent', allLines, 'Spacing', 10, 'Padding', 2);
        uicontrol('Parent', lineX, 'Style', 'Text', 'String', 'X-Axis');
        obj.Handles.editXMin = uicontrol('Parent', lineX, 'Style', 'edit', 'String', num2str(bbox(1)));
        obj.Handles.editXMax = uicontrol('Parent', lineX, 'Style', 'edit', 'String', num2str(bbox(2)));
        set(lineX, 'Widths', [-3 -2 -2]);

        lineY = uix.HBox('Parent', allLines, 'Spacing', 10, 'Padding', 2);
        uicontrol('Parent', lineY, 'Style', 'Text', 'String', 'Y-Axis');
        obj.Handles.editYMin = uicontrol('Parent', lineY, 'Style', 'edit', 'String', num2str(bbox(3)));
        obj.Handles.editYMax = uicontrol('Parent', lineY, 'Style', 'edit', 'String', num2str(bbox(4)));
        set(lineY, 'Widths', [-3 -2 -2]);

        lineZ = uix.HBox('Parent', allLines, 'Spacing', 10, 'Padding', 2);
        uicontrol('Parent', lineZ, 'Style', 'Text', 'String', 'Z-Axis');
        obj.Handles.editZMin = uicontrol('Parent', lineZ, 'Style', 'edit', 'String', num2str(bbox(5)));
        obj.Handles.editZMax = uicontrol('Parent', lineZ, 'Style', 'edit', 'String', num2str(bbox(6)));
        set(lineZ, 'Widths', [-3 -2 -2]);

        lineButtons = uix.HButtonBox('Parent', allLines, 'Spacing', 10, 'Padding', 2);
        obj.Handles.OKButton = uicontrol('Parent', lineButtons, ...
            'Style', 'pushbutton', ...
            'String', 'OK', ...
            'Callback', @obj.onButtonOK);
        obj.Handles.CancelButton = uicontrol('Parent', lineButtons, ...
            'Style', 'pushbutton', ...
            'String', 'Cancel', ...
            'Callback', @obj.onButtonCancel);
        set(lineButtons, 'ButtonSize', [130 35]);

        set(allLines, 'Heights', [40 40 40 40 50]);
        pos = get(hFig, 'Position');
        pos(3:4) = [450 250];
        set(hFig, 'Position', pos);
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

    function onButtonCancel(obj, varargin)
        close(obj.Handles.figure);
    end
end

end % end classdef

