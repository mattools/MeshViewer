classdef DisplayOptions < handle
% Display options for representing draw items.
%
%   Class DisplayOptions
%
%   Example
%   DisplayOptions
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
    % Boolean flag indicating whether lines / edges should be displayed.
    LineVisible = true;

    % The color used to draw lines or mesh edges.
    LineColor = [0 0 1];

    % The width of lines / edges.
    LineWidth = 0.5;

    % Boolean flag indicating whether 2D geometries should be filled.
    FillVisible = true;
    
    % The color used to fill 2D geometries.
    FillColor = [0 1 1];
    
    % The opacity of 2D fill.
    FillOpacity = 1;
    
    % Boolean flag indicating whether mesh faces should be visible.
    FaceVisible = true;

    % The color used to fill mesh faces.
    FaceColor = [0.7 0.7 0.7];
    
    % The opacity of mesh faces.
    FaceOpacity = 1;
    
end % end properties


%% Constructor
methods
    function obj = DisplayOptions(varargin)
        % Constructor for DisplayOptions class.

    end

end % end constructors


%% Methods
methods
    function apply(obj, handle)
        % Apply this set of options to the graphical handle.

        % switch processing depending on nature of handle
        if strcmpi(handle.Type, 'Patch')
            % Process a handle associated to a mesh.

            % setup edges
            if obj.LineVisible
                set(handle, 'EdgeColor', obj.LineColor);
                set(handle, 'LineWidth', obj.LineWidth);
            else
                set(handle, 'EdgeColor', 'none');
            end
    
            % setup faces
            set(handle, 'faceColor', obj.FaceColor);
            set(handle, 'faceAlpha', obj.FaceOpacity);

        else
            % General handle
        end

    end
end % end methods


%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization.
        str = struct('type', 'DisplayOptions');
        
        if any(obj.LineColor ~= [0 0 1])
            str.lineColor = obj.LineColor;
        end
        
        if obj.LineWidth ~= 0.5
            str.lineWidth = obj.LineWidth;
        end
        
        if any(obj.FillColor ~= [0 0 0])
            str.fillColor = obj.FillColor;
        end

        if obj.FillOpacity ~= 1
            str.fillOpacity = obj.FillOpacity;
        end
        
        if any(obj.FaceColor ~= [0 0 0])
            str.faceColor = obj.FaceColor;
        end

        if obj.FaceOpacity ~= 1
            str.faceOpacity = obj.FaceOpacity;
        end
    end
end
methods (Static)
    function options = fromStruct(str)
        % Create a new instance from a structure.
        
        % create default instance
        options = mv.app.DisplayOptions();
        
        % iterate over names of structure fields
        names = fieldnames(str);
        for i = 1:length(names)
            name = names{i};
            if strcmp(name, 'type')
                continue;
            end
            
            propertyName = capitalizeFirstDigit(name);
            if isprop(options, propertyName)
                options.(propertyName) = str.(name);
            else
                warning(['DisplayOption has no property with name: ' propertyName]);
            end
        end
        
        function name = capitalizeFirstDigit(name)
            name(1) = upper(name(1));
        end
    end
end

end % end classdef

