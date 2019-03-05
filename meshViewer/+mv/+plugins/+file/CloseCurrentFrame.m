classdef CloseCurrentFrame < mv.gui.Plugin
%Close the current frame
%
%   Class CloseCurrentFrame
%
%   Example
%   CloseCurrentFrame
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
    function obj = CloseCurrentFrame(varargin)
    % Constructor for SayHello class

    end

end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        close(frame);
    end
    
end % end methods

end % end classdef

