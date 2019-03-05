classdef SceneAxis < handle
%SCENEAXIS Describes one of the axes of a scene
%
%   Class SceneAxis
%
%   Example
%   SceneAxis
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-09-18,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
    % vector of two values, containing the min and the max
    Limits = [0 1];
    
    % if reversed, values are in decreasing order
    Reverse = false;
    
    % the label to be displayed
    Label = '';
    
end % end properties


%% Constructor
methods
    function obj = SceneAxis(varargin)
        % Constructor for SceneAxis class
        
        % copy constructor
        if ~isempty(varargin) && isa(varargin{1}, 'SceneAxis')
            that = varargin{1};
            obj.Limits = that.Limits;
            obj.Reverse = that.Reverse;
            obj.Label = that.Label;
            return;
        end
        
        % Initialize from a set of parameter name-value pairs 
        while length(varargin) > 2
            name = varargin{1};
            if strcmpi(name, 'limits')
                obj.Limits = varargin{2};
            elseif strcmpi(name, 'reverse')
                obj.Reverse = varargin{2};
            elseif strcmpi(name, 'label')
                obj.Label = varargin{2};
            else
                warning(['Unknown parameter name for SceneAxis: ' name]);
            end
            varargin(1:2) = [];
        end
        
    end
end % end constructors


%% Methods
methods
end % end methods

%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization

        % create a structure containing all fields that differ from default
        if ~isempty(obj.Limits)
            str.limits = obj.Limits;
        end
        if obj.Reverse
            str.reverse = obj.Reverse;
        end
        if ~isempty(obj.Label)
            str.label = obj.Label;
        end
    end
    
    function write(obj, fileName, varargin)
        % Write into a JSON file
        savejson('', toStruct(obj), 'FileName', fileName, varargin{:});
    end
end

methods (Static)
    function axis = fromStruct(str)
        % Create a new instance from a structure
        
        % create an empty scene
        axis = SceneAxis();
        
        % parse optionnal fields
        names = fieldnames(str);
        for i = 1:length(names)
            name = names{i};
            if strcmpi(name, 'limits')
                axis.Limits = str.(name);
            elseif strcmpi(name, 'reverse')
                axis.Reverse = str.(name);
            elseif strcmpi(name, 'label')
                axis.Label = str.(name);
            else
                warning(['Unknown SceneAxis parameter: ' name]);
            end
         end

    end
    
    function axis = read(fileName)
        % Read a sceneAxis from a file in JSON format
        axis = SceneAxis.fromStruct(loadjson(fileName));
    end
end

end % end classdef

