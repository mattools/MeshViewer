classdef MeshViewerMainFrame < handle
%MESHVIEWERMAINFRAME Contains a figure that displays one or several meshes
%
%   Class MeshViewerMainFrame
%
%   Example
%   MeshViewerMainFrame
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-05-24,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
    % reference to the main GUI instance
    gui;
   
    % list of handles to the various gui items
    handles;
    
    % the scene displayed by this frame
    % Contains a collection of meshes.
    scene;
%     
%     % the set of mouse listeners.
%     % Stored as an array of svui.app.Shape instances
%     mouseListeners = [];
%     
%     % the currently selected tool
%     currentTool = [];
%     
    % the set of selected meshes, stored as an index array
    selectedMeshIndices = [];
    
end % end properties


%% Constructor
methods
    function this = MeshViewerMainFrame(gui, scene)
        this.gui = gui;
        this.scene = scene;
        
        % create default figure
        fig = figure(...
            'MenuBar', 'none', ...
            'NumberTitle', 'off', ...
            'NextPlot', 'new', ...
            'Name', 'Mesh Viewer');
        
        % create main figure menu
        setupMenu(fig);
        setupLayout(fig);
        
        this.handles.figure = fig;
        
        updateDisplay(this);
        updateMeshList(this);
        updateTitle(this);
        
        % setup listeners associated to the figure
        set(fig, ...
            'CloseRequestFcn', @this.close, ...
            'ResizeFcn', @this.onFigureResized);
        
%         % setup mouse listeners associated to the figure
%         set(fig, 'WindowButtonDownFcn',     @this.processMouseButtonPressed);
%         set(fig, 'WindowButtonUpFcn',       @this.processMouseButtonReleased);
%         set(fig, 'WindowButtonMotionFcn',   @this.processMouseMoved);
% 
%         % setup mouse listener for display of mouse coordinates
%         tool = svui.gui.tools.ShowCursorPositionTool(this, 'showMousePosition');
%         addMouseListener(this, tool);
%         
%         tool = svui.gui.tools.SelectionTool(this, 'selection');
%         addMouseListener(this, tool);
%         this.currentTool = tool;
        
        
        set(fig, 'UserData', this);
        
        function setupMenu(hf)
            
            % File Menu Definition 
            
            fileMenu = uimenu(hf, 'Label', '&Files');
            addPlugin(fileMenu, mv.plugins.file.CreateNewSceneFrame(), 'New Empty Scene');
            addPlugin(fileMenu, mv.plugins.file.OpenFileOFF(), 'Open OFF File...');
            addPlugin(fileMenu, mv.plugins.file.OpenFilePLY(), 'Open PLY File...');
            importMeshesMenu = uimenu(fileMenu, 'Label', 'Import');
            addPlugin(importMeshesMenu, mv.plugins.file.ImportMeshFromStruct(), 'Mesh struct from Workspace');
            addPlugin(importMeshesMenu, mv.plugins.file.ImportMeshVFFromWorkspace(), 'Vertices+Faces from Workspace');
            demoMeshesMenu = uimenu(fileMenu, 'Label', 'Sample Meshes');
            addPlugin(demoMeshesMenu, mv.plugins.file.CreateTetrahedron(), 'Tetrahedron');
            addPlugin(demoMeshesMenu, mv.plugins.file.CreateCube(), 'Cube');
            addPlugin(demoMeshesMenu, mv.plugins.file.CreateOctahedron(), 'Octahedron');
            addPlugin(demoMeshesMenu, mv.plugins.file.CreateIcosahedron(), 'Icosahedron');
            addPlugin(demoMeshesMenu, mv.plugins.file.CreateDodecahedron(), 'Dodecahedron');
            addPlugin(demoMeshesMenu, mv.plugins.file.CreateRhombododecahedron(), 'RhomboDodecahedron', true);
            addPlugin(demoMeshesMenu, mv.plugins.file.CreateTetrakaidecahedron(), 'Tetrakaidecahedron');
            addPlugin(demoMeshesMenu, mv.plugins.file.CreateSoccerBall(), 'Soccer Ball');
            uimenu(fileMenu, 'Label', 'Save', 'Separator', 'on');
            addPlugin(fileMenu, mv.plugins.file.CloseCurrentFrame(), 'Close', true);
%             addPlugin(fileMenu, mv.plugins.file.Quit(), 'Quit');
            
            
            % Edit Menu Definition 
            
            editMenu = uimenu(hf, 'Label', '&Edit');
            addPlugin(editMenu, mv.plugins.edit.RenameMesh(), 'Rename');
            addPlugin(editMenu, mv.plugins.edit.DuplicateMesh(), 'Duplicate', true);
            addPlugin(editMenu, mv.plugins.edit.RemoveMesh(), 'Delete');
            addPlugin(editMenu, mv.plugins.edit.SelectAll(), 'Select All', true);
            addPlugin(editMenu, mv.plugins.edit.SelectNone(), 'Select None');
            addPlugin(editMenu, mv.plugins.edit.SelectInverse(), 'Inverse Selection');
            addPlugin(editMenu, mv.plugins.edit.SetSelectionFaceColor(), 'Set Face Color', true);
            addPlugin(editMenu, mv.plugins.edit.SetFaceTransparency(), 'Set Face Transparency');
            addPlugin(editMenu, mv.plugins.edit.SetEdgeStyle(), 'Set Edge Style');
            addPlugin(editMenu, mv.plugins.edit.PrintMeshList(), 'Print Mesh List');
            addPlugin(editMenu, mv.plugins.edit.PrintMeshInfo(), 'Mesh Info', true);
            
            
            % Edit Menu Definition 
            
            viewMenu = uimenu(hf, 'Label', '&View');
            addPlugin(viewMenu, mv.plugins.view.ToggleLight(), 'Toggle Light');
            addPlugin(viewMenu, mv.plugins.view.PrintAxisProperties(), 'Print Axis Properties', true);

            
            % Process Menu Definition 
            
            processMenu = uimenu(hf, 'Label', '&Process');
            addPlugin(processMenu, mv.plugins.process.RecenterMesh(), 'Recenter');
            transformMenu = uimenu(processMenu, 'Label', 'Transform');
            addPlugin(transformMenu, mv.plugins.process.TranslateMesh(), 'Translation...');
            addPlugin(transformMenu, mv.plugins.process.UniformScalingMesh(), 'Scaling...');
            addPlugin(transformMenu, mv.plugins.process.PlanarSymmetry(), 'Planar Symmetry...');
            addPlugin(processMenu, mv.plugins.process.TriangulateMesh(), 'Triangulate', true);
            addPlugin(processMenu, mv.plugins.process.SmoothMesh(), 'Smooth');
            addPlugin(processMenu, mv.plugins.process.SubdivideMesh(), 'Subdivide');
            addPlugin(processMenu, mv.plugins.process.CheckMeshAdjacentFaces(), 'Check Adjacent Faces', true);

            
            % Analyze Menu Definition 
            
            analyzeMenu = uimenu(hf, 'Label', '&Analyze');
            addPlugin(analyzeMenu, mv.plugins.analyze.ComputeMeshVolume(), 'Volume');
            addPlugin(analyzeMenu, mv.plugins.analyze.ComputeMeshArea(), 'Surface Area');
            addPlugin(analyzeMenu, mv.plugins.analyze.ComputeMeshMeanBreadth(), 'Mean Breadth');
            
        end % end of setupMenu function

        function item = addPlugin(menu, plugin, label, varargin)
            
            % creates new item
            if verLessThan('matlab', 'R2018a')
                item = uimenu(menu, 'Label', label, ...
                    'Callback', @(src, evt)plugin.run(this, src, evt));
            else
                item = uimenu(menu, 'Label', label, ...
                    'MenuSelectedFcn', @(src, evt)plugin.run(this, src, evt));
            end
            
            % eventually add separator above item
            if ~isempty(varargin)
                var = varargin{1};
                if islogical(var)
                    set(item, 'Separator', 'On');
                end
            end
        end
        
        function setupLayout(hf)
            
            % compute background color of most widgets
            bgColor = get(0, 'defaultUicontrolBackgroundColor');
            if ispc
                bgColor = 'White';
            end
            set(hf, 'defaultUicontrolBackgroundColor', bgColor);
            
            % vertical layout for putting status bar on bottom
            mainPanel = uix.VBox('Parent', hf, ...
                'Units', 'normalized', ...
                'Position', [0 0 1 1]);
            
            % horizontal panel: main view middle, options left and right
            horzPanel = uix.HBoxFlex('Parent', mainPanel);
            
            % panel for doc info
            docInfoPanel = uix.VBoxFlex('Parent', horzPanel);

            % create a default uittree
            treePanel = uipanel(...
                'Parent', docInfoPanel, ...
                'Position', [0 0 1 1], ...
                'BorderType', 'none', ...
                'BorderWidth', 0);
            
            this.handles.shapeList = uicontrol(...
                'Style', 'listbox', ...
                'Parent', treePanel, ...
                'Units', 'normalized', ...
                'Position', [0 0 1 1], ...
                'Max', 2, 'Min', 0, ... % to allow empty selection
                'Callback', @this.onMeshListModified);

            displayOptionsPanel = uitable(...
                'parent', docInfoPanel, ...
                'Position', [0 0 1 1] );
            
                        
            docInfoPanel.Heights = [-2 -1];
            
            this.handles.docInfoPanel = docInfoPanel;
            this.handles.displayOptionsPanel = displayOptionsPanel;
            


            % panel for scene display
            displayPanel = uix.VBox('Parent', horzPanel);
            % use a container to prevent layout changes during 3D rotate
            container = uicontainer('Parent', displayPanel);
            
            ax = axes('parent', container, ...
                'ActivePositionProperty', 'outerposition', ...
                'units', 'normalized', ...
                'position', [0 0 1 1], ...
            	'XLim', [-1 1], ...
            	'YLim', [-1 1], ...
            	'ZLim', [-1 1], ...
                'dataAspectRatio', [1 1 1], ...
            	'XTick', [], ...
            	'YTick', [], ...
            	'ZTick', [], ...
            	'Box', 'off');
            axis(ax, 'equal');
            axis(ax, [-1 1 -1 1 -1 1]);

            % keep widgets handles
            this.handles.mainAxis = ax;
            
            horzPanel.Widths = [180 -1];
            
            % info panel for cursor position and value
            this.handles.statusBar = uicontrol(...
                'Parent', mainPanel, ...
                'Style', 'text', ...
                'String', ' x=    y=     I=', ...
                'HorizontalAlignment', 'left');
            
            % set up relative sizes of layouts
            mainPanel.Heights = [-1 20];
        end
      
    end
    
end % end constructors


%% General methods
methods
    function addNewMesh(this, mesh, meshName)
        % adds a new mesh to the scene, and update displays
        
        % add new mesh to the scene
        mh = createMeshHandle(this.scene, mesh, meshName);
        this.scene.addMeshHandle(mh);
        
        % update display
        updateDisplay(this);
        updateMeshList(this);
    end
end


%% Management of selection
methods
    function handleList = selectedMeshHandleList(this)
        % returns the list of selected mesh handles
        
        handleList = {};
        
        inds = this.selectedMeshIndices;
        if isempty(inds)
            return;
        end
        
        handleList = this.scene.meshHandleList;
        if length(handleList) < max(inds)
            error('Wrong index for mesh handle selection');
        end
        
        handleList = handleList(inds);
    end
    
    function setSelectedMeshIndices(this, indices)
        this.selectedMeshIndices = indices;
        set(this.handles.shapeList, 'Max', 2, 'Min', 0, 'Value', indices);
    end
end


%% Widget callbacks
methods
    
    function updateDisplay(this)
        % refresh document display: clear axis, draw each shape, udpate axis
        
        disp('update Display');
        
        % remove all existing children
        ax = this.handles.mainAxis;
        cla(ax);
        hold on;

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
        
        % initialize line handles for axis lines
        if this.scene.displayOptions.axisLinesVisible
            hLx = drawLine3d(ax, [0 0 0  1 0 0], 'k');
            hLy = drawLine3d(ax, [0 0 0  0 1 0], 'k');
            hLZ = drawLine3d(ax, [0 0 0  0 0 1], 'k');
        end

        if this.scene.displayOptions.lightVisible
            this.scene.lightHandle = light('Parent', ax);
        end

        % enables 3D rotation of axis
        rotate3d(gcf, 'on');
        
%         h = rotate3d(gca);
%         set(h, 'RotateStyle', 'orbit');
        
%         % draw each shape in the document
%         tool = this.currentTool;
%         shapes = this.doc.shapes;
%         for i = 1:length(shapes)
%             shape = shapes(i);
%             hs = draw(shape);
%             set(hs, 'buttonDownFcn', @tool.onMouseClicked);
%             set(hs, 'UserData', shape);
%             
%             if any(shape == this.selectedShapes)
%                 set(hs, 'Selected', 'on');
%             end
%         end
        
%         % set axis bounds from view box
%         if ~isempty(this.doc.viewBox)
%             set(ax, 'XLim', this.doc.viewBox(1:2));
%             set(ax, 'YLim', this.doc.viewBox(3:4));
%         end
            
%         % draw lines for X, Y and Z axes, based on current axis bounds
%         if this.scene.axisLinesVisible
%             viewBox = this.scene.viewBox;
%             if isempty(viewBox)
%                 viewBox = [get(ax, 'xlim') get(ax, 'ylim')];
%             end
%             set(hl1, 'XData', [viewBox(1) viewBox(2)], 'Ydata', [0 0]);
%             set(hl2, 'Xdata', [0 0], 'YData', [viewBox(3) viewBox(4)]);
%         end

%         updateMeshList(this);
        
%         disp('end of update Display');
    end
    
    function updateMeshSelectionDisplay(this) %#ok<MANU>
        % update the selected state of each shape
        
%         % extract the list of handles in current axis
%         ax = this.handles.mainAxis;
%         children = get(ax, 'Children');
%         
%         % iterate over children
%         for i = 1:length(children)
%             % Extract shape referenced by current handle, if any
%             shape = get(children(i), 'UserData');
%             
%             % update selection state of current shape
%             if any(shape == this.selectedMeshIndices)
%                 set(children(i), 'Selected', 'on');
%             else
%                 set(children(i), 'Selected', 'off');
%             end
%         end
        
    end
    
    function updateTitle(this)
        % set up title of the figure, containing name of doc
        title = 'MeshViewer';
%         title = sprintf('%s - MeshViewer', this.doc.name);
        set(this.handles.figure, 'Name', title);
    end
    
    
    function updateMeshList(this)
        % Refresh the shape tree when a shape is added or removed

        disp('update shape list');
        
        nMeshes = length(this.scene.meshHandleList);
        shapeNames = cell(nMeshes, 1);
        inds = [];
        for i = 1:nMeshes
            mh = this.scene.meshHandleList{i};

            % create name for current shape
            name = mh.id;
            if isempty(mh.id)
                name = ['(' class(shape.geometry) ')'];
            end
            shapeNames{i} = name;
        end
        
        set(this.handles.shapeList, ...
            'String', shapeNames, ...
            'Min', 0, 'Max', nMeshes+2, ...
            'Value', inds);
    end
end


%% Widget callbacks

methods
    function onMeshListModified(this, varargin)
        % when user click on panel containing list of mesh handles,
        % determines which names are selected and updates index of mesh
        % handles accordingly
        
        disp('mesh selection list updated');
        
        inds = get(this.handles.shapeList, 'Value');
        this.selectedMeshIndices = inds;
    end
end

%% Figure management
methods
    function close(this, varargin)
%         disp('Close shape viewer frame');
        delete(this.handles.figure);
    end
    
    function onFigureResized(this, varargin)
%         updateMeshSelectionDisplay(this);
    end
end
end % end classdef

