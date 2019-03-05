classdef ComputeMeshVolume < mv.gui.Plugin
% Display general info about the current mesh
%
%   Class ComputeMeshVolume
%
%   Example
%   ComputeMeshVolume
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
    function obj = ComputeMeshVolume(varargin)
    % Constructor for ComputeMeshVolume class
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
        vol = meshVolume(mh.Mesh.Vertices, mh.Mesh.Faces);
        
        disp(sprintf('Mesh volume: %7.5g', abs(vol))); %#ok<DSPS>
        
    end
end % end methods

end % end classdef

