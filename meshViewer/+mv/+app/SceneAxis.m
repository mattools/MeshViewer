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
    limits = [0 1];
    
    % if reversed, values are in decreasing order
    reverse = false;
    
    % the label to be displayed
    label = '';
    
end % end properties


%% Constructor
methods
    function this = SceneAxis(varargin)
        % Constructor for SceneAxis class
        
        % copy constructor
        if ~isempty(varargin) && isa(varargin{1}, 'SceneAxis')
            that = varargin{1};
            this.limits = that.limits;
            this.reverse = that.reverse;
            this.label = that.label;
            return;
        end
        
        % Initialize from a set of parameter name-value pairs 
        while length(varargin) > 2
            name = varargin{1};
            if strcmpi(name, 'limits')
                this.limits = varargin{2};
            elseif strcmpi(name, 'reverse')
                this.reverse = varargin{2};
            elseif strcmpi(name, 'label')
                this.label = varargin{2};
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
    function str = toStruct(this)
        % Convert to a structure to facilitate serialization

        % create a structure containing all fields that differ from default
        if ~isempty(this.limits)
            str.limits = this.limits;
        end
        if this.reverse
            str.reverse = this.reverse;
        end
        if ~isempty(this.label)
            str.label = this.label;
        end
    end
    
    function write(this, fileName, varargin)
        % Write into a JSON file
        savejson('', toStruct(this), 'FileName', fileName, varargin{:});
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
                axis.limits = str.(name);
            elseif strcmpi(name, 'reverse')
                axis.reverse = str.(name);
            elseif strcmpi(name, 'label')
                axis.label = str.(name);
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

