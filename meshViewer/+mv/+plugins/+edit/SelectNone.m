classdef SelectNone < mv.gui.Plugin
% Select all the meshes
%
%   Class SelectNone
%
%   Example
%   SelectNone
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-06-05,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = SelectNone(varargin)
    % Constructor for SelectNone class
    end
end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        setSelectedMeshIndices(frame, []);        
    end
end % end methods

end % end classdef

