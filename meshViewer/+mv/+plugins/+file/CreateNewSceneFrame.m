classdef CreateNewSceneFrame < mv.gui.Plugin
% Creates a new frame containing an empty scene
%
%   Class SayHello
%
%   Example
%   SayHello
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
    function obj = CreateNewSceneFrame(varargin)
    % Constructor for CreateNewSceneFrame class

    end

end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        addNewMeshFrame(frame.Gui);
    end
    
end % end methods

end % end classdef

