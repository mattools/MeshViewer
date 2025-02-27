classdef XZSliceViewer < handle
% One-line description here, please.
%
%   Class XZSliceViewer
%
%   Example
%   XZSliceViewer
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2024-01-30,    using Matlab 23.2.0.2459199 (R2023b) Update 5
% Copyright 2024 INRAE - BIA-BIBS.


%% Properties
properties
    % Keep reference to parent frame (must be MainFrame)
    ParentFrame;
   
    % The scene displayed by this frame, as an instance of mv.app.Scene.
    % Contains a collection of meshes.
    Scene;

    % The Y-position of the XZ-plane
    SlicePosition = 0;

    % list of handles to the various gui items
    Handles;
    
    Computing = false;

end % end properties


%% Constructor
methods
    function obj = XZSliceViewer(frame)
        % Constructor for XYSliceViewer class.

        if ~isa(frame, 'mv.gui.MeshViewerMainFrame')
            error('input argument must be an instance of MeshViewerMainFrame');
        end
        obj.ParentFrame = frame;
        obj.Scene = frame.Scene;

        % initialize plane position in the middle of the bounding box
        box = viewBox(obj.Scene.DisplayOptions);
        yPlane = mean([box(3) box(4)]);
        obj.SlicePosition = yPlane;
        
        % create default figure
        fig = figure(...
            'MenuBar', 'none', ...
            'NumberTitle', 'off', ...
            'NextPlot', 'new', ...
            'Name', 'XZ Slice Viewer');
        
        % create main figure menu
        setupMenu(fig);
        setupLayout(fig);
        
        % % create scene renderer
        % obj.SceneRenderer = mv.gui.SceneRenderer(scene, obj.Handles.MainAxis);
        
        obj.Handles.Figure = fig;
        
        refreshDisplay(obj);
        % updateMeshList(obj);
        % updateTitle(obj);
        
        % setup listeners associated to the figure
        set(fig, ...
            'CloseRequestFcn', @obj.close, ...
            'ResizeFcn', @obj.onFigureResized);
        
        set(fig, 'UserData', obj);


        function setupMenu(hf)
            
            % File Menu Definition 
            % fileMenu = uimenu(hf, 'Label', '&Files');
        end


        function setupLayout(hf)
            
            % compute background color of most widgets
            bgColor = get(0, 'defaultUicontrolBackgroundColor');
            if ispc
                bgColor = 'White';
            end
            set(hf, 'defaultUicontrolBackgroundColor', bgColor);
            
            % % retrieve bounding box fore initializing
            % box = viewBox(obj.Scene.DisplayOptions);

            % horizontal layout for putting scroll on left side
            mainPanel = uix.HBox('Parent', hf, ...
                'Units', 'normalized', ...
                'Position', [0 0 1 1]);
            
            % slider for slice
            ymin = box(3);
            ymax = box(4);
            ysteps = [0.005 0.05]; % 1/200 and 1/20
            obj.Handles.YSlider = uicontrol('Style', 'slider', ...
                'Parent', mainPanel, ...
                'Min', ymin, 'Max', ymax', ...
                'SliderStep', ysteps, ...
                'Value', obj.SlicePosition, ...
                'Callback', @obj.onSliceSliderChanged, ...
                'BackgroundColor', [1 1 1]);

            % code for dragging the slider thumb
            % @see http://undocumentedmatlab.com/blog/continuous-slider-callback
            addlistener(obj.Handles.YSlider, ...
                'ContinuousValueChange', @obj.onSliceSliderChanged);

            % panel for scene display
            % use a container to prevent layout changes during 3D rotate
            container = uicontainer('Parent', mainPanel);
            
            ax = axes('parent', container, ...
                'ActivePositionProperty', 'outerposition', ...
                'Units', 'normalized', ...
                'Position', [0 0 1 1], ...
            	'XLim', box([1 2]), ...
            	'YLim', box([5 6]), ...
                'DataAspectRatio', [1 1 1], ...
            	'XTick', [], ...
            	'YTick', [], ...
            	'Box', 'off');
            axis(ax, 'equal');
            axis(ax, box([1 2 5 6]));

            % keep widgets handles
            obj.Handles.MainAxis = ax;
            
            mainPanel.Widths = [20 -1];
        end
    end

end % end constructors


methods
    function refreshDisplay(obj)

        if obj.Computing 
            return;
        end
        obj.Computing = true;
        
        ax = obj.Handles.MainAxis;
        cla(ax);
        hold on;

        plane = [0 obj.SlicePosition 0   1 0 0   0 0 1];

        % display the meshes
        for i = 1:length(obj.Scene.MeshHandleList)
            mh = obj.Scene.MeshHandleList{i};
            mesh = mh.Mesh;
            [polys, closedFlags] = planeIntersection(mesh, plane);

            % display intersections using face color for drawing polylines
            slices = cellfun(@(x) {x(:,[1 3])}, polys(closedFlags));
            if ~isempty(slices)
                drawPolygon(ax, slices, 'color', mh.DisplayOptions.FaceColor, 'LineWidth', 2);
            end
            slices = cellfun(@(x) {x(:,[1 3])}, polys(~closedFlags));
            if ~isempty(slices)
                drawPolyline(ax, slices, 'color', mh.DisplayOptions.FaceColor, 'LineWidth', 2);
            end
        end

        % updateAxisLinesDisplay(obj);
        % annotateAxis(obj);

        obj.Computing = false;
    end
end

%% GUI Widgets listeners
methods
    function onSliceSliderChanged(obj, hObject, eventdata) %#ok<*INUSD>
        
        yslice = get(hObject, 'Value');
        obj.SlicePosition = yslice;

        refreshDisplay(obj);

        % % propagate change of current slice event to ImageDisplayListeners
        % evt = struct('Source', obj, 'EventName', 'CurrentSliceChanged');
        % processCurrentSliceChanged(obj, obj.Handles.Figure, evt);
    end
end


%% Figure management methods
methods
    function close(obj, varargin)
        delete(obj.Handles.Figure);
    end
    
    function onFigureResized(obj, varargin)
    end
end

end % end classdef

