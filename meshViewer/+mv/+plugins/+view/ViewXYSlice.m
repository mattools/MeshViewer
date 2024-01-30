classdef ViewXYSlice < mv.gui.Plugin
% One-line description here, please.
%
%   Class ViewXYSlice
%
%   Example
%   ViewXYSlice
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
    function obj = ViewXYSlice(varargin)
        % Constructor for ViewXYSlice class.

    end

end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        mv.gui.frames.XYSliceViewer(frame.Gui, frame.Scene);
    end
end % end methods

end % end classdef

