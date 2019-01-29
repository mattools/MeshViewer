classdef SceneRenderer < handle
%SCENERENDERER Manages the representation of a scene on an axis
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
    scene;
    
    % the handle to the render axis
    axisHandle;
    
    % various widget handles
    handles = struct(...
        'light', [], ...
        'axisLines', [], ...  % an array of three handles
        'axisLineX', [], ...
        'axisLineY', [], ...
        'axisLineZ', []);

end % end properties


%% Constructor
methods
    function this = SceneRenderer(scene, axis, varargin)
        % Constructor for SceneRenderer class
        this.scene = scene;
        this.axisHandle = axis;
    end

end % end constructors


%% Methods
methods
    function refreshDisplay(this)
        % refresh document display: clear axis, draw each shape, udpate axis
        
        disp('update Display from renderer');
        
        % remove all existing children
        ax = this.axisHandle;
        
        cla(ax);
        hold on;

        % remove handles from struct
        names = fieldnames(this.handles);
        for i = 1:length(names)
            this.handles.(names{i}) = [];
        end
        
        % compute bounding box that encloses all meshes
        updateBoundingBox(this.scene);
        bbox = viewBox(this.scene.displayOptions);
        
        % update axis bouding box
        set(ax, 'XLim', bbox(1:2));
        set(ax, 'YLim', bbox(3:4));
        set(ax, 'ZLim', bbox(5:6));

        % display the meshes
        for i = 1:length(this.scene.meshHandleList)
            mh = this.scene.meshHandleList{i};
            mesh = mh.mesh;
            h = drawMesh(ax, mesh.vertices, mesh.faces);
            apply(mh.displayOptions, h);
            mh.handles.patch = h;
        end

        updateAxisLinesDisplay(this);
        updateLightDisplay(this);
        
        % enables 3D rotation of axis
        rotate3d(gcf, 'on');        
    end
end % end methods


%% Update graphical items
methods
    function updateAxisLinesDisplay(this)
        % update visibility and position of axis lines 
        visible = this.scene.displayOptions.axisLinesVisible;
        updateWidget(this, this.handles.axisLines, visible, @this.createNewAxisLines);
    end
    
    function updateLightDisplay(this)
        % update visibility and position of light graphical elements
        visible = this.scene.displayOptions.lightVisible;
        updateWidget(this, this.handles.light, visible, @this.createNewLight);
    end
    
end

methods (Access = private)
    
    function updateWidget(this, widget, visible, createFcn) %#ok<INUSL>
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
    
    function res = createNewAxisLines(this)
        % create new graphical elements for axis lines
        ax = this.axisHandle;
        hlx = drawLine3d(ax, [0 0 0  1 0 0], 'k');
        hly = drawLine3d(ax, [0 0 0  0 1 0], 'k');
        hlz = drawLine3d(ax, [0 0 0  0 0 1], 'k');
        this.handles.axisLines = [hlx, hly, hlz];
        res = this.handles.axisLines;
    end
    
    function res = createNewLight(this)
        % create new graphical element for light
        ax = this.axisHandle;
        this.handles.light = light('Parent', ax);
        res = this.handles.light;
    end
end

end % end classdef

