classdef MeshDisplayOptions < handle
%MESHDISPLAYOPTIONS  Display options for representing meshes
%
%   Class MeshDisplayOptions
%
%   Example
%   MeshDisplayOptions
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-01-07,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    % global visibility of the mesh
    Visible = true;
    
    
    FaceColor = [1 0 0];
    
    FaceAlpha = 1;
    
    
    EdgeVisible = true;

    EdgeColor = [0 0 0];

    
end % end properties


%% Constructor
methods
    function obj = MeshDisplayOptions(varargin)
    % Constructor for MeshDisplayOptions class

    end

end % end constructors


%% Methods
methods
    function apply(obj, patchHandle)
        % apply obj set of options to the input patch handle(s)

        % setup edges
        if obj.EdgeVisible
            set(patchHandle, 'EdgeColor', obj.EdgeColor);
        else
            set(patchHandle, 'EdgeColor', 'none');
        end

        % setup faces
        set(patchHandle, 'faceColor', obj.FaceColor);
        set(patchHandle, 'faceAlpha', obj.FaceAlpha);
    end
end % end methods


%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization
        str = struct('type', 'MeshDisplayOptions');
        
        str.visible = obj.Visible;
        
        if any(obj.FaceColor ~= [1 0 0])
            str.faceColor = obj.FaceColor;
        end
        
        if obj.FaceAlpha ~= 1
            str.faceAlpha = obj.FaceAlpha;
        end
        
        if ~obj.EdgeVisible
            str.edgeVisible = false;
        end
        
        if any(obj.EdgeColor ~= [0 0 0])
            str.edgeColor = obj.EdgeColor;
        end
    end
end
methods (Static)
    function options = fromStruct(str)
        % Create a new instance from a structure
        
        % create default instance
        options = mv.app.MeshDisplayOptions();
        
        % iterate over 
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
                warning(['MeshDisplayOption has no property named: ' propertyName]);
            end
        end
        
        function name = capitalizeFirstDigit(name)
            name(1) = upper(name(1));
        end
    end
end


end % end classdef

