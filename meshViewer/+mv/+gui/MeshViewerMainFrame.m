classdef MeshViewerMainFrame < handle
%MESHVIEWERMAINFRAME Contains a figure that displays one or several meshes.
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
    Gui;
   
    % list of handles to the various gui items
    Handles;
    
    % The scene displayed by this frame, as an instance of mv.app.Scene.
    % Contains a collection of meshes.
    Scene;
    
    SceneRenderer;
%     
%     % the set of mouse listeners.
%     % Stored as an array of svui.app.Shape instances
%     mouseListeners = [];
%     
%     % the currently selected tool
%     currentTool = [];
%     
    % the set of selected meshes, stored as an index array
    SelectedMeshIndices = [];
    
end % end properties


%% Constructor
methods
    function obj = MeshViewerMainFrame(gui, scene)
        obj.Gui = gui;
        obj.Scene = scene;
        
        % create default figure
        fig = figure(...
            'MenuBar', 'none', ...
            'NumberTitle', 'off', ...
            'NextPlot', 'new', ...
            'Name', 'Mesh Viewer');
        
        % create main figure menu
        setupMenu(fig);
        setupLayout(fig);
        
        % create scene renderer
        obj.SceneRenderer = mv.gui.SceneRenderer(scene, obj.Handles.MainAxis);
        
        obj.Handles.Figure = fig;
        
%         updateDisplay(obj);
        refreshDisplay(obj.SceneRenderer);
        
        updateMeshList(obj);
        updateTitle(obj);
        
        % setup listeners associated to the figure
        set(fig, ...
            'CloseRequestFcn', @obj.close, ...
            'ResizeFcn', @obj.onFigureResized);
        
%         % setup mouse listeners associated to the figure
%         set(fig, 'WindowButtonDownFcn',     @obj.processMouseButtonPressed);
%         set(fig, 'WindowButtonUpFcn',       @obj.processMouseButtonReleased);
%         set(fig, 'WindowButtonMotionFcn',   @obj.processMouseMoved);
% 
%         % setup mouse listener for display of mouse coordinates
%         tool = svui.Gui.tools.ShowCursorPositionTool(obj, 'showMousePosition');
%         addMouseListener(obj, tool);
%         
%         tool = svui.Gui.tools.SelectionTool(obj, 'selection');
%         addMouseListener(obj, tool);
%         obj.currentTool = tool;
        
        
        set(fig, 'UserData', obj);
        
        function setupMenu(hf)
            
            % File Menu Definition 
            
            fileMenu = uimenu(hf, 'Label', '&Files');
            addPlugin(fileMenu, mv.plugins.file.CreateNewSceneFrame(), 'New Empty Scene');
            addPlugin(fileMenu, mv.plugins.file.OpenMeshFile(), 'Open Mesh File...', 'Separator', 'on');
            addPlugin(fileMenu, mv.plugins.file.OpenMeshAsStructure(), 'Open MeshViewer Mesh File...');
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
%             uimenu(fileMenu, 'Label', 'Save', 'Separator', 'on');
            addPlugin(fileMenu, mv.plugins.file.SaveMeshAsStructure(), 'Save as .mat File...', true);
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
            addPlugin(editMenu, mv.plugins.edit.SetFaceOpacity(), 'Set Face Opacity');
            addPlugin(editMenu, mv.plugins.edit.SetEdgeStyle(), 'Set Edge Style');
            addPlugin(editMenu, mv.plugins.edit.PrintMeshList(), 'Print Mesh List');
            addPlugin(editMenu, mv.plugins.edit.PrintMeshInfo(), 'Mesh Info', true);
            
            
            % Edit Menu Definition 
            
            viewMenu = uimenu(hf, 'Label', '&View');
            addPlugin(viewMenu, mv.plugins.view.SetSceneAxisBounds(), 'Setup Scene Bounds');
            addPlugin(viewMenu, mv.plugins.view.SetSceneAxisBoundsToBoundingBox(), 'Set Scene Bounds To Bounding Box');
            addPlugin(viewMenu, mv.plugins.view.ToggleLight(), 'Toggle Light', 'Separator', 'on');
            addPlugin(viewMenu, mv.plugins.view.ToggleAxisLinesDisplay(), 'Toggle Axis Lines Display');
            addPlugin(viewMenu, mv.plugins.view.PrintAxisProperties(), 'Print Axis Properties', true);
            addPlugin(viewMenu, mv.plugins.view.ViewXYSlice(), 'View XY Slice', true);

            
            % Process Menu Definition 
            
            processMenu = uimenu(hf, 'Label', '&Process');
            addPlugin(processMenu, mv.plugins.process.RecenterMesh(), 'Recenter');
            transformMenu = uimenu(processMenu, 'Label', 'Transform');
            addPlugin(transformMenu, mv.plugins.process.TranslateMesh(), 'Translate...');
            addPlugin(transformMenu, mv.plugins.process.RotateMeshMainAxes(), 'Rotate...');
            addPlugin(transformMenu, mv.plugins.process.UniformScalingMesh(), 'Scale...');
            addPlugin(transformMenu, mv.plugins.process.FlipMesh(), 'Flip...');
            addPlugin(processMenu, mv.plugins.process.TriangulateMesh(), 'Triangulate...', true);
            addPlugin(processMenu, mv.plugins.process.SmoothMesh(), 'Smooth');
            addPlugin(processMenu, mv.plugins.process.SubdivideMesh(), 'Subdivide');
            simplifyMenu = uimenu(processMenu, 'Label', 'Simplify');
            addPlugin(simplifyMenu, mv.plugins.process.SimplifyMeshByReducePatch(), 'Reduce Patch');
            addPlugin(simplifyMenu, mv.plugins.process.SimplifyMeshByVertexClustering(), 'Vertex Clustering');
            addPlugin(processMenu, mv.plugins.process.IntersectPlaneMesh(), 'Intersect With Plane');
            addPlugin(processMenu, mv.plugins.process.EnsureManifoldMesh(), 'Ensure Manifold Mesh');
            addPlugin(processMenu, mv.plugins.process.CheckMeshAdjacentFaces(), 'Check Adjacent Faces', true);

            
            % Analyze Menu Definition 
            
            analyzeMenu = uimenu(hf, 'Label', '&Analyze');
            addPlugin(analyzeMenu, mv.plugins.analyze.ComputeMeshVolume(), 'Volume');
            addPlugin(analyzeMenu, mv.plugins.analyze.ComputeMeshArea(), 'Surface Area');
            addPlugin(analyzeMenu, mv.plugins.analyze.ComputeMeshMeanBreadth(), 'Mean Breadth');
            addPlugin(analyzeMenu, mv.plugins.analyze.PlotMeshVertexDegreeHistogram(), 'Vertex Degree Histogram', true);
            
        end % end of setupMenu function

        function item = addPlugin(menu, plugin, label, varargin)
            
            % creates new item
            if verLessThan('matlab', '8.4')
                item = uimenu(menu, 'Label', label, ...
                    'Callback', @(src, evt) plugin.run(obj, src, evt));
            else
                item = uimenu(menu, 'Label', label, ...
                    'MenuSelectedFcn', @(src, evt) plugin.run(obj, src, evt));
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
            
            obj.Handles.ShapeList = uicontrol(...
                'Style', 'listbox', ...
                'Parent', treePanel, ...
                'Units', 'normalized', ...
                'Position', [0 0 1 1], ...
                'Max', 2, 'Min', 0, ... % to allow empty selection
                'Callback', @obj.onMeshListModified);

            displayOptionsPanel = uitable(...
                'parent', docInfoPanel, ...
                'Position', [0 0 1 1] );
            
                        
            docInfoPanel.Heights = [-2 -1];
            
            obj.Handles.DocInfoPanel = docInfoPanel;
            obj.Handles.DisplayOptionsPanel = displayOptionsPanel;
            


            % panel for scene display
            displayPanel = uix.VBox('Parent', horzPanel);
            % use a container to prevent layout changes during 3D rotate
            container = uicontainer('Parent', displayPanel);
            
            ax = axes('parent', container, ...
                'ActivePositionProperty', 'outerposition', ...
                'Units', 'normalized', ...
                'Position', [0 0 1 1], ...
            	'XLim', [-1 1], ...
            	'YLim', [-1 1], ...
            	'ZLim', [-1 1], ...
                'DataAspectRatio', [1 1 1], ...
            	'XTick', [], ...
            	'YTick', [], ...
            	'ZTick', [], ...
            	'Box', 'off');
            axis(ax, 'equal');
            axis(ax, [-1 1 -1 1 -1 1]);

            % keep widgets handles
            obj.Handles.MainAxis = ax;
            
            horzPanel.Widths = [180 -1];
            
            % info panel for cursor position and value
            obj.Handles.StatusBar = uicontrol(...
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
    function addNewMesh(obj, mesh, varargin)
        % Add a new mesh to the scene, and update displays.
        %
        % Usage:
        %   addNewMesh(frame, mesh, name);
        
        % add new mesh to the scene
        mh = createMeshHandle(obj.Scene, mesh, varargin{:});
        obj.Scene.addMeshHandle(mh);

        % update scene view box to enclose new mesh
        box = viewBox(obj.Scene.DisplayOptions);
        box = mergeBoxes3d(box, boundingBox3d(mh.Mesh.Vertices));
        setViewBox(obj.Scene.DisplayOptions, box);

        % update display
        updateDisplay(obj);
        updateMeshList(obj);
    end
end


%% Management of selection
methods
    function handleList = selectedMeshHandleList(obj)
        % Return the list of selected mesh handles.
        
        handleList = {};
        
        inds = obj.SelectedMeshIndices;
        if isempty(inds)
            return;
        end
        
        handleList = obj.Scene.MeshHandleList;
        if length(handleList) < max(inds)
            error('Wrong index for mesh handle selection');
        end
        
        handleList = handleList(inds);
    end
    
    function setSelectedMeshIndices(obj, indices)
        obj.SelectedMeshIndices = indices;
        set(obj.Handles.ShapeList, 'Max', 2, 'Min', 0, 'Value', indices);
    end
end


%% Widget callbacks
methods
    
    function updateDisplay(obj)
        % Refresh document display.
        % -> clear axis, draw each shape, udpate axis
        
        disp('update Display');
        
        refreshDisplay(obj.SceneRenderer);
    end
    
    function updateMeshSelectionDisplay(obj) %#ok<MANU>
        % update the selected state of each shape.
        
%         % extract the list of handles in current axis
%         ax = obj.Handles.MainAxis;
%         children = get(ax, 'Children');
%         
%         % iterate over children
%         for i = 1:length(children)
%             % Extract shape referenced by current handle, if any
%             shape = get(children(i), 'UserData');
%             
%             % update selection state of current shape
%             if any(shape == obj.selectedMeshIndices)
%                 set(children(i), 'Selected', 'on');
%             else
%                 set(children(i), 'Selected', 'off');
%             end
%         end
        
    end
    
    function updateTitle(obj)
        % set up title of the figure, containing name of doc
        title = 'MeshViewer';
%         title = sprintf('%s - MeshViewer', obj.doc.name);
        set(obj.Handles.Figure, 'Name', title);
    end
    
    
    function updateMeshList(obj)
        % Refresh the shape tree when a shape is added or removed.

        disp('update shape list');
        
        nMeshes = length(obj.Scene.MeshHandleList);
        shapeNames = cell(nMeshes, 1);
        inds = [];
        for i = 1:nMeshes
            mh = obj.Scene.MeshHandleList{i};

            % create name for current shape
            name = mh.Name;
            if isempty(mh.Name)
                name = ['(' 'Mesh struct' ')'];
            end
            shapeNames{i} = name;
        end
        
        set(obj.Handles.ShapeList, ...
            'String', shapeNames, ...
            'Min', 0, 'Max', nMeshes+2, ...
            'Value', inds);
    end
end


%% Widget callbacks

methods
    function onMeshListModified(obj, varargin)
        % when user click on panel containing list of mesh handles,
        % determines which names are selected and updates index of mesh
        % handles accordingly
        
        disp('mesh selection list updated');
        
        inds = get(obj.Handles.ShapeList, 'Value');
        obj.SelectedMeshIndices = inds;
    end
end

%% Figure management
methods
    function close(obj, varargin)
%         disp('Close shape viewer frame');
        delete(obj.Handles.Figure);
    end
    
    function onFigureResized(obj, varargin) %#ok<INUSD>
%         updateMeshSelectionDisplay(obj);
    end
end

end % end classdef

