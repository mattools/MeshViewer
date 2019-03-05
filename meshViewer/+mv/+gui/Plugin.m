classdef Plugin < handle
%PLUGIN Base class for implementing plugins
%
%   Class Plugin
%
%   Example
%   Plugin
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-05-24,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = Plugin(varargin)
    % Constructor for Plugin class

    end

end % end constructors


%% Abstract methods
methods (Abstract)
   run(obj, frame, src, event);
end % end of abstract methods declaration

%% Utility method
methods
    function b = isEnabled(obj, frame)
        % Checks if obj plugin can be available for the specified frame
        % 
        % Default behaviour is to return true, but specific implementations
        % can return different result depending on the content of the
        % frame.
        b = true;
    end
    
end % end of abstract methods declaration

end % end classdef

