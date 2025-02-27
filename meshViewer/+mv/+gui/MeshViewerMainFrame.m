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
    
    % Utility class that manages the display of the scene on an axis.
    SceneRenderer;

    % the set of selected meshes, stored as an index array
    SelectedMeshIndices = [];
    
    % the set of selected draw items, stored as an index array
    SelectedDrawItemIndices = [];
    
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
        
        refreshDisplay(obj.SceneRenderer);
        
        updateMeshList(obj);
        updateTitle(obj);
        
        % setup listeners associated to the figure
        set(fig, ...
            'CloseRequestFcn', @obj.close, ...
            'ResizeFcn', @obj.onFigureResized);
        
        set(fig, 'UserData', obj);
        
        function setupMenu(hf)
            
            % File Menu Definition 
            
            fileMenu = uimenu(hf, 'Label', '&Files');
            addPlugin(fileMenu, mv.plugins.file.CreateNewSceneFrame(), 'New Empty Scene');
            addPlugin(fileMenu, mv.plugins.file.OpenSceneAsStructure(), 'Open MeshViewer Scene File (*.mvsb)...');
            addPlugin(fileMenu, mv.plugins.file.OpenMeshFile(), 'Open Mesh File (*.ply, *.obj...)...', true);
            addPlugin(fileMenu, mv.plugins.file.OpenMeshAsStructure(), 'Open MeshViewer Mesh File (*.mesh)...');
            importMeshesMenu = uimenu(fileMenu, 'Label', 'Import Mesh');
            addPlugin(importMeshesMenu, mv.plugins.file.ImportMeshFromStruct(), 'Mesh struct from Workspace');
            addPlugin(importMeshesMenu, mv.plugins.file.ImportMeshVFFromWorkspace(), 'Vertices+Faces from Workspace');
            demoMeshesMenu = uimenu(fileMenu, 'Label', 'Sample Meshes');
            addPlugin(demoMeshesMenu, mv.plugins.file.ImportSampleMesh('teapot.obj', 'teapot'), 'Tea pot');
            addPlugin(demoMeshesMenu, mv.plugins.file.ImportSampleMesh('bunny_F1k.ply', 'bunny_1k'), 'Stanford Bunny (1000 faces)');
            addPlugin(demoMeshesMenu, mv.plugins.file.ImportSampleMesh('bunny_F5k.ply', 'bunny_5k'), 'Stanford Bunny (5000 faces)');
            addPlugin(demoMeshesMenu, mv.plugins.file.CreateTetrahedron(), 'Tetrahedron', true);
            addPlugin(demoMeshesMenu, mv.plugins.file.CreateCube(), 'Cube');
            addPlugin(demoMeshesMenu, mv.plugins.file.CreateOctahedron(), 'Octahedron');
            addPlugin(demoMeshesMenu, mv.plugins.file.CreateIcosahedron(), 'Icosahedron');
            addPlugin(demoMeshesMenu, mv.plugins.file.CreateDodecahedron(), 'Dodecahedron');
            addPlugin(demoMeshesMenu, mv.plugins.file.CreateRhombododecahedron(), 'RhomboDodecahedron', true);
            addPlugin(demoMeshesMenu, mv.plugins.file.CreateTetrakaidecahedron(), 'Tetrakaidecahedron');
            addPlugin(demoMeshesMenu, mv.plugins.file.CreateSoccerBall(), 'Soccer Ball');
            addPlugin(fileMenu, mv.plugins.file.SaveSceneAsStructure(), 'Save MeshViewer Scene File...', true);
            addPlugin(fileMenu, mv.plugins.file.SaveMeshAsStructure(), 'Save current mesh as .mat File...');
            addPlugin(fileMenu, mv.plugins.file.CloseCurrentFrame(), 'Close', true);
            
            
            % Edit Menu Definition 
            
            editMenu = uimenu(hf, 'Label', '&Edit');
            addPlugin(editMenu, mv.plugins.edit.RenameScene(), 'Rename Scene');
            addPlugin(editMenu, mv.plugins.edit.RenameMesh(), 'Rename Mesh', true);
            addPlugin(editMenu, mv.plugins.edit.DuplicateMesh(), 'Duplicate');
            addPlugin(editMenu, mv.plugins.edit.RemoveMesh(), 'Delete');
            addPlugin(editMenu, mv.plugins.edit.SelectAll(), 'Select All', true);
            addPlugin(editMenu, mv.plugins.edit.SelectNone(), 'Select None');
            addPlugin(editMenu, mv.plugins.edit.SelectInverse(), 'Inverse Selection');
            addPlugin(editMenu, mv.plugins.edit.SetSelectionFaceColor(), 'Set Face Color', true);
            addPlugin(editMenu, mv.plugins.edit.SetFaceOpacity(), 'Set Face Opacity');
            addPlugin(editMenu, mv.plugins.edit.SetEdgeStyle(), 'Set Edge Style');
            addPlugin(editMenu, mv.plugins.edit.PrintMeshList(), 'Print Mesh List');
            addPlugin(editMenu, mv.plugins.edit.FindClosestVertex(), 'Find Closest Vertex...', true);
            addPlugin(editMenu, mv.plugins.edit.PrintMeshInfo(), 'Mesh Info', true);
            
            
            % View Menu Definition 
            
            viewMenu = uimenu(hf, 'Label', '&View');
            boundsMenu = uimenu(viewMenu, 'Label', 'Scene Bounds');
            addPlugin(boundsMenu, mv.plugins.view.SetSceneAxisBounds(), 'Setup Scene Bounds');
            addPlugin(boundsMenu, mv.plugins.view.SetSceneAxisBoundsToBoundingBox(), 'Set Scene Bounds To Bounding Box');
            addPlugin(viewMenu, mv.plugins.view.SetAxisViewAngle(), 'Set View Angles...');
            addPlugin(viewMenu, mv.plugins.view.ToggleLight(), 'Toggle Light');
            addPlugin(viewMenu, mv.plugins.view.ToggleAxisLinesDisplay(), 'Toggle Axis Lines Display');
            addPlugin(viewMenu, mv.plugins.view.PrintAxisProperties(), 'Print Axis Properties', true);
            addPlugin(viewMenu, mv.plugins.view.ComputeMeshBoundaryPolygons(), 'Compute Mesh Boundaries', true);
            % addPlugin(viewMenu, mv.plugins.view.ClearMeshBoundary(), 'Clear Mesh Boundaries');
            addPlugin(viewMenu, mv.plugins.view.DrawMeshBoundingBox(), 'Draw Mesh Bounding Box');
            addItemsMenu = uimenu(viewMenu, 'Label', 'Add Items');
            addPlugin(addItemsMenu, mv.plugins.view.AddPlaneDrawItem(), 'Add Plane Item');
            addPlugin(addItemsMenu, mv.plugins.view.DrawMeshVertexRing(), 'Draw Mesh Vertex Ring');
            % addPlugin(addItemsMenu, mv.plugins.view.ClearMeshVertexRings(), 'Clear Mesh Vertex Ring');
            addPlugin(viewMenu, mv.plugins.view.RemoveAllDrawItems(), 'Remove All Items');
            addPlugin(viewMenu, mv.plugins.view.ViewXYSlice(), 'View XY Slice', true);
            addPlugin(viewMenu, mv.plugins.view.ViewXZSlice(), 'View XZ Slice');
            addPlugin(viewMenu, mv.plugins.view.ViewYZSlice(), 'View YZ Slice');

            
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
            
            analyzeMenu = uimenu(hf, 'Label', '&Measures');
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
            
            % horizontal panel: main view in the middle, options panels in
            % left (and right?) sides
            horzPanel = uix.HBoxFlex('Parent', mainPanel);
            
            % panel for doc info
            docInfoPanel = uix.VBoxFlex('Parent', horzPanel);

            listsTabPanel = uix.TabPanel(...
                'Parent', docInfoPanel, ...
                'Position', [0 0 1 1]);

            % create a panel for the list of meshes
            meshListPanel = uipanel(...
                'Parent', listsTabPanel, ...
                'Position', [0 0 1 1], ...
                'BorderType', 'none', ...
                'BorderWidth', 0);
            obj.Handles.ShapeList = uicontrol(...
                'Style', 'listbox', ...
                'Parent', meshListPanel, ...
                'Units', 'normalized', ...
                'Position', [0 0 1 1], ...
                'Max', 2, 'Min', 0, ... % to allow empty selection
                'Callback', @obj.onMeshListModified);

            % create a panel for the list of items
            itemListPanel = uipanel(...
                'Parent', listsTabPanel, ...
                'Position', [0 0 1 1], ...
                'BorderType', 'none', ...
                'BorderWidth', 0);
            obj.Handles.DrawItemList = uicontrol(...
                'Style', 'listbox', ...
                'Parent', itemListPanel, ...
                'Units', 'normalized', ...
                'Position', [0 0 1 1], ...
                'Max', 2, 'Min', 0, ... % to allow empty selection
                'Callback', @obj.onDrawItemListModified);

            % finalize setup of tab panel
            listsTabPanel.TabTitles = {'Meshes', 'Items'};

            % add another panel for display of current selection
            selectionInfoPanel = uipanel(...
                'Parent', docInfoPanel, ...
                'Position', [0 0 1 1], ...
                'BorderType', 'none', ...
                'BorderWidth', 0);
            obj.Handles.SelectionInfo = uicontrol(...
                'Style', 'listbox', ...
                'Parent', selectionInfoPanel, ...
                'Units', 'normalized', ...
                'Position', [0 0 1 1] );
            
            docInfoPanel.Heights = [-2 -1];
            
            obj.Handles.DocInfoPanel = docInfoPanel;

            % panel for scene display
            displayPanel = uix.VBox('Parent', horzPanel);
            % use a container to prevent layout changes during 3D rotate
            container = uicontainer('Parent', displayPanel);
            
            ax = axes('parent', container, ...
                'ActivePositionProperty', 'outerposition', ...
                'Units', 'normalized', ...
                'Position', [0 0 1 1], ...
            	'XLim', [-1 1], ... % Default bounds
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
                'String', ' ', ...
                'HorizontalAlignment', 'left');
            
            % set up relative sizes of layouts
            % (set up zero height for status bar as it is currently not
            % used)
            mainPanel.Heights = [-1 0];
        end
    end
end % end constructors


%% General methods
methods
    function mh = addNewMesh(obj, mesh, varargin)
        % Add a new mesh to the scene, and update displays.
        %
        % Usage:
        %   addNewMesh(frame, mesh);
        %   addNewMesh(frame, mesh, name);
        %   MH = addNewMesh(...);
        %
        %   addNewMesh(frame, mesh);
        %   Adds a new mesh, using a default name.
        %
        %   addNewMesh(frame, mesh, name);
        %   Adds a new mesh, using the specified name.
        %
        %   MH = addNewMesh(...);
        %   Also returns a handle on the created mesh object. The MH object
        %   is an instance of mv.app.MeshHandle.
        %
        %   See Also
        %     mv.app.Scene.createMeshHandle

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

    function addDrawItem(obj, item, varargin)
        % Add a new mesh to the scene, and update displays.
        %

        addDrawItem(obj.Scene, item);

        % update display
        updateDrawItemList(obj);
        updateDisplay(obj);
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
        
        if obj.Gui.App.Debug
            disp('update Display');
        end
        
        refreshDisplay(obj.SceneRenderer);
    end
    
    function updateMeshSelectionDisplay(obj)
        % Update the info panel based on current selected mesh.
        
        inds = obj.SelectedMeshIndices;
        if isempty(inds)
            % clear the panel showing mesh info
            set(obj.Handles.SelectionInfo, 'String', '');

        elseif isscalar(inds)
            % Display info about selected mesh
            mh = obj.Scene.MeshHandleList{inds(1)};
            mesh = mh.Mesh;
            strings = {mh.Name};
            strings = [strings {sprintf('vertices: %d', vertexCount(mesh))}];
            if ~isempty(mesh.Edges)
                strings = [strings {sprintf('edges: %d', edgeCount(mesh))}];
            end
            strings = [strings {sprintf('faces: %d', faceCount(mesh))}];
            set(obj.Handles.SelectionInfo, 'String', strings);
        else
            % if several meshes are selected, do nothing.
        end
    end
    
    function updateDrawItemSelectionDisplay(obj)
        % Update the info panel based on current selected draw item.
        
        inds = obj.SelectedDrawItemIndices;
        if isempty(inds)
            % clear the panel showing mesh info
            set(obj.Handles.SelectionInfo, 'String', '');

        elseif isscalar(inds)
            % Display info about selected item
            item = obj.Scene.DrawItems{inds(1)};
            strings = {sprintf('Name: %s', item.Name)};
            strings = [strings {sprintf('Type: %s', item.Type)}];
            visibleString = 'true'; if ~item.Visible, visibleString = 'false'; end
            strings = [strings {sprintf('Visible: %s', visibleString)}];
            set(obj.Handles.SelectionInfo, 'String', strings);
        else
            % if several items are selected, do nothing.
        end
    end


    function updateTitle(obj)
        % set up title of the figure, containing name of the scene.
        title = sprintf('%s - MeshViewer', obj.Scene.Name);
        set(obj.Handles.Figure, 'Name', title);
    end
    
    function updateMeshList(obj)
        % Refresh the shape tree when a shape is added or removed.

        if obj.Gui.App.Debug
            disp('update shape list');
        end

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

    function updateDrawItemList(obj)
        % Refresh the widgets when a DrawItem is added or removed.

        if obj.Gui.App.Debug
            disp('update DrawItem list');
        end

        nItems = length(obj.Scene.DrawItems);
        itemNames = cell(nItems, 1);
        inds = [];
        for i = 1:nItems
            mh = obj.Scene.DrawItems{i};

            % create name for current shape
            name = mh.Name;
            if isempty(mh.Name)
                name = '(draw item)';
            end
            itemNames{i} = name;
        end
        
        set(obj.Handles.DrawItemList, ...
            'String', itemNames, ...
            'Min', 0, 'Max', nItems+2, ...
            'Value', inds);
    end
end


%% Widget callbacks

methods
    function onMeshListModified(obj, varargin)
        % when user click on panel containing list of mesh handles,
        % determines which names are selected and updates index of mesh
        % handles accordingly
        
        if obj.Gui.App.Debug
            disp('mesh selection list updated');
        end

        inds = get(obj.Handles.ShapeList, 'Value');
        obj.SelectedMeshIndices = inds;
        if length(inds) < 2
            updateMeshSelectionDisplay(obj)
        end
    end

    function onDrawItemListModified(obj, varargin)
        % when user click on panel containing list of item handles.
        
        if obj.Gui.App.Debug
            disp('item selection list updated');
        end

        inds = get(obj.Handles.DrawItemList, 'Value');
        obj.SelectedDrawItemIndices = inds;
        if length(inds) < 2
            updateDrawItemSelectionDisplay(obj)
        end
    end
end

%% Figure management
methods
    function close(obj, varargin)
        delete(obj.Handles.Figure);
    end
    
    function onFigureResized(obj, varargin) %#ok<INUSD>
        % Can be used to update display when containing figure is resized.
    end
end

end % end classdef

