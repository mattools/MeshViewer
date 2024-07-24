classdef SetSceneAxisBoundsToBoundingBox < mv.gui.Plugin
% Set the bounds of the scene to the bounding box of scene items.
%
%   Class SetSceneAxisBoundsToBoundingBox
%
%   Example
%   SetSceneAxisBoundsToBoundingBox
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2024-01-11,    using Matlab 23.2.0.2409890 (R2023b) Update 3
% Copyright 2024 INRAE - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = SetSceneAxisBoundsToBoundingBox(varargin)
        % Constructor for SetSceneAxisBoundsToBoundingBox class.

    end

end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>

        % update bounding box of view box from scene content
        bbox = computeBoundingBox(frame.Scene);
        setViewBox(frame.Scene.DisplayOptions, bbox);

        refreshDisplay(frame.SceneRenderer);
    end 
end % end methods

end % end classdef

