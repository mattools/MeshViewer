classdef CheckMeshAdjacentFaces < mv.gui.Plugin
% Smooth the current mesh
%
%   Class CheckMeshAdjacentFaces
%
%   Example
%   CheckMeshAdjacentFaces
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
    function obj = CheckMeshAdjacentFaces(varargin)
    % Constructor for CheckMeshAdjacentFaces class
    end
end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        meshList = frame.Scene.MeshHandleList;
        if length(meshList) < 1
            return;
        end
       
        mh = meshList{1};
        v = mh.Mesh.Vertices;
        f = mh.Mesh.Faces;
        
        % recenter by removing the mean
        checkMeshAdjacentFaces(v, f);
    end
end % end methods

end % end classdef

