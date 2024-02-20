classdef ViewYZSlice < mv.gui.Plugin
% One-line description here, please.
%
%   Class ViewYZSlice
%
%   Example
%   ViewYZSlice
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2024-01-30,    using Matlab 23.2.0.2459199 (R2023b) Update 5
% Copyright 2024 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = ViewYZSlice(varargin)
        % Constructor for ViewYZSlice class.

    end

end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        mv.gui.frames.YZSliceViewer(frame.Gui, frame.Scene);
    end
end % end methods

end % end classdef

