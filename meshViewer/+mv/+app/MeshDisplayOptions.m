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
    faceColor = [1 0 0];
    
    faceTransparency = 1;
    
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
        set(patchHandle, 'faceAlpha', this.faceTransparency);
    end
end % end methods

end % end classdef

