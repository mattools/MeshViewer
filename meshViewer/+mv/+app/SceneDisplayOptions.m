classdef SceneDisplayOptions < handle
%SCENEDISPLAYOPTIONS The different options that control the display of a Scene
%
%   Class SceneDisplayOptions
%
%   Example
%   SceneDisplayOptions
%
%   See also
%     mv.app.Scene

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-01-17,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    % Description of x-axis, as a SceneAxis instance
    XAxis
    
    % Description of y-axis, as a SceneAxis instance
    YAxis;
    
    % Description of z-axis, as a SceneAxis instance
    ZAxis;

    % indicates whether main axes are visible or not (boolean)
    AxisLinesVisible = true;
    
    % indicates whether light is visible or not (boolean)
    LightVisible = true;
    
end % end properties


%% Constructor
methods
    function obj = SceneDisplayOptions(varargin)
        % Constructor for DisplayOptions class
        
        % create new axes
        obj.XAxis = mv.app.SceneAxis();
        obj.YAxis = mv.app.SceneAxis();
        obj.ZAxis = mv.app.SceneAxis();
    end

end % end constructors


%% Methods
methods
    function box = viewBox(obj)
        % Compute the view box from the limits on the different axes.
        box = [obj.XAxis.Limits obj.YAxis.Limits obj.ZAxis.Limits];
    end
    
    function setViewBox(obj, box)
        % set axes limits from viewbox values
        obj.XAxis.Limits = box(1:2);
        obj.YAxis.Limits = box(3:4);
        if length(box) > 4
            obj.ZAxis.Limits = box(5:6);
        end
    end
end % end methods


%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization.
        
        % create structure with necessary fields
        str.XAxis = toStruct(obj.XAxis);
        str.YAxis = toStruct(obj.YAxis);
        str.ZAxis = toStruct(obj.ZAxis);
        
        % add fields in structure when they differ from default
        if ~obj.AxisLinesVisible
            str.AxisLinesVisible = obj.AxisLinesVisible;
        end
        if ~obj.LightVisible
            str.LightVisible = obj.LightVisible;
        end
    end
    
    function write(obj, fileName, varargin)
        % Write into a JSON file.
        savejson('', toStruct(obj), 'FileName', fileName, varargin{:});
    end
end

methods (Static)
    function options = fromStruct(str)
        % Create a new instance from a structure.
        
        % create an empty options object
        options = mv.app.SceneDisplayOptions();

        % parse optionnal fields
        names = fieldnames(str);
        for i = 1:length(names)
            name = names{i};
            if strcmpi(name, 'XAxis')
                options.XAxis = mv.app.SceneAxis.fromStruct(str.(name));
            elseif strcmpi(name, 'YAxis')
                options.YAxis = mv.app.SceneAxis.fromStruct(str.(name));
            elseif strcmpi(name, 'ZAxis')
                options.ZAxis = mv.app.SceneAxis.fromStruct(str.(name));
            elseif strcmpi(name, 'AxisLinesVisible')
                options.AxisLinesVisible = str.(name);
            elseif strcmpi(name, 'LightVisible')
                options.LightVisible = str.(name);
            else
                warning(['Unknown SceneAxis parameter: ' name]);
            end
        end
    end
    
    function axis = read(fileName)
        % Read a SceneDisplayOptions object from a file in JSON format.
        axis = mv.app.SceneDisplayOptions.fromStruct(loadjson(fileName));
    end
end

end % end classdef

