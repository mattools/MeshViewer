classdef ComputeMeshMeanBreadth < mv.gui.Plugin
% Display general info about the current mesh
%
%   Class ComputeMeshMeanBreadth
%
%   Example
%   ComputeMeshMeanBreadth
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
    function obj = ComputeMeshMeanBreadth(varargin)
    % Constructor for ComputeMeshMeanBreadth class
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
        faces = mh.Mesh.Faces;
        if iscell(faces) || size(faces, 2) > 3
            faces = triangulateFaces(faces);
        end
        mb = trimeshMeanBreadth(mh.Mesh.Vertices, faces);
        
        disp(sprintf('Mesh mean breadth: %7.5g', mb)); %#ok<DSPS>
        
    end
end % end methods

end % end classdef

