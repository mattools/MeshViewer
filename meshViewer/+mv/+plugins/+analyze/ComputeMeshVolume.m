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
    function this = ComputeMeshVolume(varargin)
    % Constructor for ComputeMeshVolume class
    end
end % end constructors


%% Methods
methods
    function run(this, frame, src, evt) %#ok<INUSL>
        
        meshList = frame.scene.meshHandleList;
        if length(meshList) < 1
            return;
        end
       
        mh = meshList{1};
        vol = meshVolume(mh.mesh.vertices, mh.mesh.faces);
        
        disp(sprintf('Mesh volume: %7.5g', vol)); %#ok<DSPS>
        
    end
end % end methods

end % end classdef

