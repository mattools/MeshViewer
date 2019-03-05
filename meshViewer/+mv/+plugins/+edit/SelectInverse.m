classdef SelectInverse < mv.gui.Plugin
% Select all the meshes
%
%   Class SelectInverse
%
%   Example
%   SelectInverse
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
    function obj = SelectInverse(varargin)
    % Constructor for SelectInverse class
    end
end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        nMeshes = length(frame.Scene.MeshHandleList);
        inds = 1:nMeshes;
        inds(frame.SelectedMeshIndices) = [];
        setSelectedMeshIndices(frame, inds);
    end
end % end methods

end % end classdef

