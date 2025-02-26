classdef (InferiorClasses = {?matlab.graphics.axis.Axes}) DrawItem < handle
% Container for an item that can be drawn on an axis.
%
%   Class DrawItem
%
%   Example
%   DrawItem
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2025-02-26,    using Matlab 24.1.0.2653294 (R2024a) Update 5
% Copyright 2025 INRAE - BIA-BIBS.


%% Properties
properties
    % the name of the item, as a string. Should be unique within the
    % application.
    Name;

    % The type of the item, as a string.
    Type;

    % The data necessary to display the item.
    % The nature of the data depends on the item Type.
    Data;

    % a list of display options.
    DisplayOptions;
    
    % handles to the graphical object(s) used  to display this item.
    Handles;

    % A visibility flag (logical).
    Visible = true;
    
end % end properties


%% Constructor
methods
    function obj = DrawItem(name, type, data, varargin)
        % Constructor for DrawItem class.
        %
        %   DrawItem(NAME, TYPE, DATA);
        %
        %   Example
        %     item = mv.app.DrawItem('poly01', 'Polygon3D', rand(5,3));

        % store ID and data
        obj.Name = name;
        obj.Type = type;
        obj.Data = data;

        % create new display options
        if strcmpi(type, 'Mesh')
            % use specific class for meshes
            obj.DisplayOptions = mv.app.MeshDisplayOptions();
        else
            obj.DisplayOptions = mv.app.DisplayOptions();
        end
    end

end % end constructors


%% Methods
methods
    function h = draw(varargin)
        % Draw this item.

        % extract first argument
        var1 = varargin{1};
        varargin(1) = [];

        % Check if first input argument is an axes handle
        if isAxisHandle(var1)
            ax = var1;
            var1 = varargin{1};
        else
            ax = gca;
        end

        obj = var1;

        if strcmpi(obj.Type, 'Polygon3D')
            h = drawPolygon3d(ax, obj.Data);
        elseif strcmpi(obj.Type, 'Polyline3D')
            h = drawPolyline3d(ax, obj.Data);
        else
            warning('currently no code for drawing items with type: %s', obj.Type)
        end
        apply(obj.DisplayOptions, h);
    end

end % end methods


%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization.
        str = struct(...
            'Name', obj.Name, ...
            'Type', obj.Type, ...
            'Visible', obj.Visible, ...
            'DisplayOptions', toStruct(obj.DisplayOptions), ...
            'Data', obj.Data);

        % Note: do not store references to graphical handles nor to
        % modification flag.
    end
end

methods (Static)
    function item = fromStruct(str)
        % Create a new instance from a structure.

        names = fieldnames(str);
        indName = findFieldIndex(names, 'Name');
        indType = findFieldIndex(names, 'Type');
        indData = findFieldIndex(names, 'Data');
        
        name = str.(names{indName});
        type = str.(names{indType});

        if strcmpi(type, 'mesh')
            mesh = mv.TriMesh.fromStruct(str.(names{indData}));
            item = mv.app.DrawItem(name, type, mesh);

            % process optional fields
            indOptions = find(strcmpi(names, 'DisplayOptions'), 1);
            if ~isempty(indOptions)
                item.DisplayOptions = mv.app.MeshDisplayOptions.fromStruct(str.(names{indOptions}));
            end

        else
            % Process generic case
            data = str.(names{indData});
            item = mv.app.DrawItem(name, type, data);

            % process optional fields
            index = find(strcmpi(allNames, 'DisplayOptions'), 1);
            if ~isempty(index)
                item.DisplayOptions = mv.app.DisplayOptions.fromStruct(str.(names{index}));
            end
        end

        % process optional fields
        index = find(strcmpi(names, 'Visible'), 1);
        if ~isempty(index)
            item.Visible = str.(names{index}) > 0;
        end

        % inner utility function
        function index = findFieldIndex(allNames, name)
            index = find(strcmpi(allNames, name), 1);
            if isempty(index)
                error('Field "%s" is mandatory', name);
            end
        end
    end
end


end % end classdef

