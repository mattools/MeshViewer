classdef PrintAxisProperties < mv.gui.Plugin
% Removes selected mesh(es) from current scene 
%
%   Class PrintAxisProperties
%
%   Example
%   PrintAxisProperties
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-07-02,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = PrintAxisProperties(varargin)
    % Constructor for PrintAxisProperties class
    end
end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        ax = frame.Handles.MainAxis;
        get(ax);
    end
    
end % end methods

end % end classdef

