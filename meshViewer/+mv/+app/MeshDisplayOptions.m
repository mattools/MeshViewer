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
    visible = true;
    
    
    faceColor = [1 0 0];
    
    faceAlpha = 1;
    
    
    edgeVisible = true;

    edgeColor = [0 0 0];

    
end % end properties


%% Constructor
methods
    function this = MeshDisplayOptions(varargin)
    % Constructor for MeshDisplayOptions class

    end

end % end constructors


%% Methods
methods
    function apply(this, patchHandle)
        % apply this set of options to the input patch handle(s)

        % setup edges
        if this.edgeVisible
            set(patchHandle, 'EdgeColor', this.edgeColor);
        else
            set(patchHandle, 'EdgeColor', 'none');
        end

        % setup faces
        set(patchHandle, 'faceColor', this.faceColor);
        set(patchHandle, 'faceAlpha', this.faceAlpha);
    end
end % end methods


%% Serialization methods
methods
    function str = toStruct(this)
        % Convert to a structure to facilitate serialization
        str = struct('type', 'MeshDisplayOptions');
        
        str.visible = this.visible;
        
        if any(this.faceColor ~= [1 0 0])
            str.faceColor = this.faceColor;
        end
        
        if this.faceAlpha ~= 1
            str.faceAlpha = this.faceAlpha;
        end
        
        if ~this.edgeVisible
            str.edgeVisible = false;
        end
        
        if any(this.edgeColor ~= [0 0 0])
            str.edgeColor = this.edgeColor;
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
            if isprop(options, name)
                options.(name) = str.(name);
            else
                warning(['MeshDisplayOption has no property named: ' name]);
            end
        end
    end
end


end % end classdef

