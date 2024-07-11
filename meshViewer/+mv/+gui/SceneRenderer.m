classdef SceneRenderer < handle
%SCENERENDERER Manages the representation of a scene on an axis.
%
%   Class SceneRenderer
%
%   Example
%   SceneRenderer
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-01-29,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    % the scene to render
    Scene;
    
    % the handle to the render axis
    AxisHandle;
    
    % various widget handles
    Handles = struct(...
        'Light', [], ...
        'AxisLines', [], ...  % an array of three handles
        'AxisLineX', [], ...
        'AxisLineY', [], ...
        'AxisLineZ', []);

end % end properties


%% Constructor
methods
    function obj = SceneRenderer(scene, axis, varargin)
        % Constructor for SceneRenderer class
        obj.Scene = scene;
        obj.AxisHandle = axis;
    end

end % end constructors


%% Methods
methods
    function refreshDisplay(obj)
        % refresh document display: clear axis, draw each shape, udpate axis
        
        % remove all existing children
        ax = obj.AxisHandle;
        
        cla(ax);
        hold on;

        % remove handles from struct
        names = fieldnames(obj.Handles);
        for i = 1:length(names)
            obj.Handles.(names{i}) = [];
        end
        
        % compute bounding box that encloses all meshes
        % updateBoundingBox(obj.Scene);
        bbox = viewBox(obj.Scene.DisplayOptions);
        
        % update axis bouding box
        set(ax, 'XLim', bbox(1:2));
        set(ax, 'YLim', bbox(3:4));
        set(ax, 'ZLim', bbox(5:6));

        % display the meshes
        for i = 1:length(obj.Scene.MeshHandleList)
            mh = obj.Scene.MeshHandleList{i};
            mesh = mh.Mesh;
            h = drawMesh(ax, mesh.Vertices, mesh.Faces);
            apply(mh.DisplayOptions, h);
            mh.Handles.Patch = h;
        end

        updateAxisLinesDisplay(obj);
        updateLightDisplay(obj);
        
        % enables 3D rotation of axis
        rotate3d(gcf, 'on');
        
        annotateAxis(obj);
    end
end % end methods


%% Update graphical items
methods
    function updateAxisLinesDisplay(obj)
        % update visibility and position of axis lines 
        visible = obj.Scene.DisplayOptions.AxisLinesVisible;
        updateWidget(obj, obj.Handles.AxisLines, visible, @obj.createNewAxisLines);
    end
    
    function updateLightDisplay(obj)
        % update visibility and position of light graphical elements
        visible = obj.Scene.DisplayOptions.LightVisible;
        updateWidget(obj, obj.Handles.Light, visible, @obj.createNewLight);
    end

    function annotateAxis(obj)
        
        if ~isempty(obj.Scene.DisplayOptions.XAxis.Label)
            str = obj.Scene.DisplayOptions.XAxis.Label;
            if ~isempty(obj.Scene.DisplayOptions.XAxis.UnitName)
                str = [str ' [' obj.Scene.DisplayOptions.XAxis.UnitName ']'];
            end
            xlabel(str);
        end
        if ~isempty(obj.Scene.DisplayOptions.YAxis.Label)
            str = obj.Scene.DisplayOptions.YAxis.Label;
            if ~isempty(obj.Scene.DisplayOptions.YAxis.UnitName)
                str = [str ' [' obj.Scene.DisplayOptions.YAxis.UnitName ']'];
            end
            ylabel(str);
        end
        if ~isempty(obj.Scene.DisplayOptions.ZAxis.Label)
            str = obj.Scene.DisplayOptions.ZAxis.Label;
            if ~isempty(obj.Scene.DisplayOptions.ZAxis.UnitName)
                str = [str ' [' obj.Scene.DisplayOptions.ZAxis.UnitName ']'];
            end
            zlabel(str);
        end
    end

end

methods (Access = private)
    
    function updateWidget(obj, widget, visible, createFcn) %#ok<INUSL>
        % updates visibility of specified widget(s), creating new one if necessary
        if visible
            if isempty(widget)
                % create new widgets
                widget = createFcn();
            end

            % ensure widget is visible
            set(widget, 'Visible', 'on');
        else
            % make widget invisible
            if ~isempty(widget)
                set(widget, 'Visible', 'off');
            end
        end
    end
    
    function res = createNewAxisLines(obj)
        % create new graphical elements for axis lines
        ax = obj.AxisHandle;
        hlx = drawLine3d(ax, [0 0 0  1 0 0], 'k');
        hly = drawLine3d(ax, [0 0 0  0 1 0], 'k');
        hlz = drawLine3d(ax, [0 0 0  0 0 1], 'k');
        obj.Handles.AxisLines = [hlx, hly, hlz];
        res = obj.Handles.AxisLines;
    end
    
    function res = createNewLight(obj)
        % create new graphical element for light
        ax = obj.AxisHandle;
        obj.Handles.Light = light('Parent', ax);
        res = obj.Handles.Light;
    end
end

end % end classdef

