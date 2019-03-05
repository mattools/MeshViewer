classdef ImportMeshFromStruct < mv.gui.Plugin
% Import a mesh from a struct in workspace
%
%   Class SayHello
%
%   Example
%   SayHello
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-01-03,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
    % the list of widgets, identified by names
    Handles = struct();
    
    Frame;
    
    ClosingButton;
    
end % end properties


%% Constructor
methods
    function obj = ImportMeshFromStruct(varargin)
    % Constructor for SayHello class
    end
end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
    
        % store current frame
        % TODO: not a good practice
        obj.Frame = frame;
        
        % identifies the name of struct variables
        vars = evalin('base', 'whos');
        vars = vars(strcmp({vars.class}, 'struct'));
        structNames = {vars.name};
        
        % checkup
        if isempty(structNames)
            errordlg('Workspace does not contain any struct', 'Workspace Import Error');
            return;
        end
        
        createDialog(obj, structNames);

        waitForUser(obj);
        
        if wasCanceled(obj)
            return;
        end

        % extract data
        inds = get(obj.Handles.List, 'Value');
        if isempty(inds)
            return;
        end
        nameList = structNames(inds);
        
        for i = 1:length(nameList)
            name = nameList{i};
            
            % name = getNextString(gd);
            data = evalin('base', name);
            
            % check data type
            if ~isstruct(data)
                errordlg('Input variable must be a struct', 'Workspace Import Error');
                return;
            end
            if ~isfield(data, 'vertices') || ~isfield(data, 'faces')
                errordlg('Structure must contain fields "vertices" and "faces"', 'Workspace Import Error');
                return;
            end
            
            if size(data.faces, 2) ~= 3
                errordlg('Can only process triangular meshes', 'Workspace Import Error');
                return;
            end
            
            % convert to mesh
            mesh = TriMesh(data.vertices, data.faces);
            
            addNewMesh(frame, mesh, name);
        end
        
        
        % clear figure
        close(obj.Handles.Figure);
    end
end % end methods

%% layout creation
methods
    function fig = createDialog(obj, nameList)
        
        % cerate new figure
        fig = figure;
        obj.Handles.Figure = fig;

        % vertical layout for widgets and control panels
        vb  = uix.VBox('Parent', fig, 'Spacing', 5, 'Padding', 5);

        % create an empty panel that will contain widgets
        obj.Handles.MainPanel = uix.VBox('Parent', vb);

        % populate vbox with a label and a list
        obj.Handles.ListLabel = uicontrol('Style', 'Text', ...
            'Parent', obj.Handles.MainPanel, ...
            'String', 'Choose structures to import:', ...
            'FontWeight', 'Normal', ...
            'FontSize', 10, ...
            'FontWeight', 'Normal', ...
            'HorizontalAlignment', 'Left');

%         itemList = {'Disk', 'Square', 'Triangle', 'Point', 'Line', 'Plane', 'Other'};
        obj.Handles.List = uicontrol( 'Style', 'list', ...
           'BackgroundColor', 'w', ...
           'Parent', obj.Handles.MainPanel, ...
           'String', nameList, ...
           'Value', 1, ...
           'Max', inf, ...
           'Callback', 'disp(''listcallback'')');

        % setup relative heights
        set(obj.Handles.MainPanel, 'Heights', [30 -1] );

        % button for control panel
        buttonsPanel = uix.HButtonBox('Parent', vb, 'Padding', 5);
        obj.Handles.OkButton = uicontrol( 'Parent', buttonsPanel, ...
            'String', 'OK', ...
            'Callback', @obj.onButtonOK);
        obj.Handles.CancelButton = uicontrol( 'Parent', buttonsPanel, ...
            'String', 'Cancel', ...
            'Callback', @obj.onButtonCancel);

        set(vb, 'Heights', [-1 40] );


        % setup figure size
        set(obj.Handles.Figure, 'units', 'pixels');
        pos = get(obj.Handles.Figure, 'Position');
        pos(3:4) = [250 250];
        set(obj.Handles.Figure, 'Position', pos);
    end
end

%% Figure and control Callback
methods
    function onButtonOK(obj, varargin)
        obj.ClosingButton = 'ok';
        set(obj.Handles.Figure, 'Visible', 'off');
    end
    
    function onButtonCancel(obj, varargin)
        obj.ClosingButton = 'cancel';
        set(obj.Handles.Figure, 'Visible', 'off');
    end
    
    function showDialog(obj)
        % makes the dialog visible, and waits for user validation
        setVisible(obj, true);
        waitForUser(obj);
    end
    
    function setVisible(obj, value)
        if value
            set(obj.Handles.Figure, 'Visible', 'on');
            set(obj.Handles.Figure, 'WindowStyle', 'modal');
        else
            set(obj.Handles.Figure, 'Visible', 'off');
        end
    end
    
    function b = wasOked(obj)
        b = strcmp(obj.ClosingButton, 'ok');
    end
    
    function b = wasCanceled(obj)
        b = strcmp(obj.ClosingButton, 'cancel');
    end
    
    function button = waitForUser(obj)
        waitfor(obj.Handles.Figure, 'Visible', 'off');
        button = obj.ClosingButton;
    end
    
    function closeFigure(obj)
        % close the current figure
        if ~isempty(obj.Handles.Figure)
            close(obj.Handles.Figure);
        end
    end
    
end

end % end classdef

