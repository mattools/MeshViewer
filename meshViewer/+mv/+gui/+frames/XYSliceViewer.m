classdef XYSliceViewer < handle
% One-line description here, please.
%
%   Class XYSliceViewer
%
%   Example
%   XYSliceViewer
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

    % The Z-position of the XY-plane
    SlicePosition = 0;

    % Results of plane-mesh intersection computation (one element per mesh).
    Polygons = {};
    ClosedFlags = {};

    % list of handles to the various gui items
    Handles;
    
    % The display of items on the 3D view
    DrawItems3D = [];

    Computing = false;

end % end properties


%% Constructor
methods
    function obj = XYSliceViewer(frame)
        % Constructor for XYSliceViewer class.

        if ~isa(frame, 'mv.gui.MeshViewerMainFrame')
            error('input argument must be an instance of MeshViewerMainFrame');
        end
        obj.ParentFrame = frame;
        obj.Scene = frame.Scene;

        % initialize plane position in the middle of the bounding box
        box = viewBox(obj.Scene.DisplayOptions);
        zPlane = mean([box(5) box(6)]);
        obj.SlicePosition = zPlane;
        
        % create default figure
        fig = figure(...
            'MenuBar', 'none', ...
            'NumberTitle', 'off', ...
            'NextPlot', 'new', ...
            'Name', 'XY Slice Viewer');
        
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
            zmin = box(5);
            zmax = box(6);
            zsteps = [0.005 0.05]; % 1/200 and 1/20
            obj.Handles.ZSlider = uicontrol('Style', 'slider', ...
                'Parent', mainPanel, ...
                'Min', zmin, 'Max', zmax', ...
                'SliderStep', zsteps, ...
                'Value', obj.SlicePosition, ...
                'Callback', @obj.onSliceSliderChanged, ...
                'BackgroundColor', [1 1 1]);

            % code for dragging the slider thumb
            % @see http://undocumentedmatlab.com/blog/continuous-slider-callback
            addlistener(obj.Handles.ZSlider, ...
                'ContinuousValueChange', @obj.onSliceSliderChanged);

            % panel for scene display
            % use a container to prevent layout changes during 3D rotate
            container = uicontainer('Parent', mainPanel);
            
            ax = axes('parent', container, ...
                'ActivePositionProperty', 'outerposition', ...
                'Units', 'normalized', ...
                'Position', [0 0 1 1], ...
            	'XLim', box([1 2]), ...
            	'YLim', box([3 4]), ...
                'DataAspectRatio', [1 1 1], ...
            	'XTick', [], ...
            	'YTick', [], ...
            	'Box', 'off');
            axis(ax, 'equal');
            axis(ax, box(1:4));

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
        computeIntersections(obj);
        
        ax = obj.Handles.MainAxis;
        cla(ax);
        hold on;

        % display the meshes
        for i = 1:length(obj.Scene.MeshHandleList)
            mh = obj.Scene.MeshHandleList{i};
            polys = obj.Polygons{i};
            closedFlags = obj.ClosedFlags{i};

            % display intersections using face color for drawing polylines
            drawPolygon3d(ax, polys(closedFlags), 'color', mh.DisplayOptions.FaceColor, 'LineWidth', 2);
            drawPolyline3d(ax, polys(~closedFlags), 'color', mh.DisplayOptions.FaceColor, 'LineWidth', 2);
        end
    end

    function computeIntersections(obj)
        % Compute the intersection polygons.

        % avoid multiple computations
        if obj.Computing 
            return;
        end
        obj.Computing = true;

        % allocate memory
        nMeshes = length(obj.Scene.MeshHandleList);
        obj.Polygons = cell(1, nMeshes);
        obj.ClosedFlags = cell(1, nMeshes);

        % create plane
        plane = [0 0 obj.SlicePosition   1 0 0   0 1 0];

        % compute intersection for each mesh
        for i = 1:nMeshes
            mh = obj.Scene.MeshHandleList{i};
            [obj.Polygons{i}, obj.ClosedFlags{i}] = planeIntersection(mh.Mesh, plane);
        end

        obj.Computing = false;
    end
end

%% GUI Widgets listeners
methods
    function onSliceSliderChanged(obj, hObject, eventdata) %#ok<*INUSD>
        
        zslice = get(hObject, 'Value');
        obj.SlicePosition = zslice;

        refreshDisplay(obj);
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

