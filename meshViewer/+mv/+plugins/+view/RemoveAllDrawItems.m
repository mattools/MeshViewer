classdef RemoveAllDrawItems < mv.gui.Plugin
% One-line description here, please.
%
%   Class RemoveAllDrawItems
%
%   Example
%   RemoveAllDrawItems
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2025-02-27,    using Matlab 24.2.0.2712019 (R2024b)
% Copyright 2025 INRAE - BIA-BIBS.

%% Constructor
methods
    function obj = RemoveAllDrawItems(varargin)
        % Constructor for RemoveAllDrawItems class.

    end

end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>

        frame.Scene.DrawItems = {};
        
        updateDrawItemList(frame);
        updateDisplay(frame);
    end
end % end methods

end % end classdef

