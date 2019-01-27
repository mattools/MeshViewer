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
    handles = struct();
    
    frame;
    
    closingButton;
    
end % end properties


%% Constructor
methods
    function this = ImportMeshFromStruct(varargin)
    % Constructor for SayHello class
    end
end % end constructors


%% Methods
methods
    function run(this, frame, src, evt) %#ok<INUSL>
    
        % store current frame
        % TODO: not a good practice
        this.frame = frame;
        
        % identifies the name of struct variables
        vars = evalin('base', 'whos');
        vars = vars(strcmp({vars.class}, 'struct'));
        structNames = {vars.name};
        
        % checkup
        if isempty(structNames)
            errordlg('Workspace does not contain any struct', 'Workspace Import Error');
            return;
        end
        
        createDialog(this, structNames);

        waitForUser(this);
        
        if wasCanceled(this)
            return;
        end

        % extract data
        inds = get(this.handles.list, 'Value');
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
        close(this.handles.figure);
    end
end % end methods

%% layout creation
methods
    function fig = createDialog(this, nameList)
        
        % cerate new figure
        fig = figure;
        this.handles.figure = fig;

        % vertical layout for widgets and control panels
        vb  = uix.VBox('Parent', fig, 'Spacing', 5, 'Padding', 5);

        % create an empty panel that will contain widgets
        this.handles.mainPanel = uix.VBox('Parent', vb);

        % populate vbox with a label and a list
        this.handles.listLabel = uicontrol('Style', 'Text', ...
            'Parent', this.handles.mainPanel, ...
            'String', 'Choose structures to import:', ...
            'FontWeight', 'Normal', ...
            'FontSize', 10, ...
            'FontWeight', 'Normal', ...
            'HorizontalAlignment', 'Left');

%         itemList = {'Disk', 'Square', 'Triangle', 'Point', 'Line', 'Plane', 'Other'};
        this.handles.list = uicontrol( 'Style', 'list', ...
           'BackgroundColor', 'w', ...
           'Parent', this.handles.mainPanel, ...
           'String', nameList, ...
           'Value', 1, ...
           'Max', inf, ...
           'Callback', 'disp(''listcallback'')');

        % setup relative heights
        set(this.handles.mainPanel, 'Heights', [30 -1] );

        % button for control panel
        buttonsPanel = uix.HButtonBox('Parent', vb, 'Padding', 5);
        this.handles.okButton = uicontrol( 'Parent', buttonsPanel, ...
            'String', 'OK', ...
            'Callback', @this.onButtonOK);
        this.handles.cancelButton = uicontrol( 'Parent', buttonsPanel, ...
            'String', 'Cancel', ...
            'Callback', @this.onButtonCancel);

        set(vb, 'Heights', [-1 40] );


        % setup figure size
        set(this.handles.figure, 'units', 'pixels');
        pos = get(this.handles.figure, 'Position');
        pos(3:4) = [250 250];
        set(this.handles.figure, 'Position', pos);
    end
end

%% Figure and control Callback
methods
    function onButtonOK(this, varargin)
        this.closingButton = 'ok';
        set(this.handles.figure, 'Visible', 'off');
    end
    
    function onButtonCancel(this, varargin)
        this.closingButton = 'cancel';
        set(this.handles.figure, 'Visible', 'off');
    end
    
    function showDialog(this)
        % makes the dialog visible, and waits for user validation
        setVisible(this, true);
        waitForUser(this);
    end
    
    function setVisible(this, value)
        if value
            set(this.handles.figure, 'Visible', 'on');
            set(this.handles.figure, 'WindowStyle', 'modal');
        else
            set(this.handles.figure, 'Visible', 'off');
        end
    end
    
    function b = wasOked(this)
        b = strcmp(this.closingButton, 'ok');
    end
    
    function b = wasCanceled(this)
        b = strcmp(this.closingButton, 'cancel');
    end
    
    function button = waitForUser(this)
        waitfor(this.handles.figure, 'Visible', 'off');
        button = this.closingButton;
    end
    
    function closeFigure(this)
        % close the current figure
        if ~isempty(this.handles.figure);
            close(this.handles.figure);
        end
    end
    
end

end % end classdef

