classdef PrintMeshInfo < mv.gui.Plugin
% Display general info about the current mesh
%
%   Class PrintMeshInfo
%
%   Example
%   PrintMeshInfo
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
    function this = PrintMeshInfo(varargin)
    % Constructor for PrintMeshInfo class
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
        nv = size(mh.mesh.vertices, 1);
        nf = meshFaceNumber(mh.mesh.vertices, mh.mesh.faces);
        
        disp('mesh info:');
        disp(sprintf('  mesh name: %12s', mh.id)); %#ok<DSPS>
        disp(sprintf('  vertex number:   %6d', nv)); %#ok<DSPS>
        disp(sprintf('  face number:     %6d', nf)); %#ok<DSPS>
        
    end
end % end methods

end % end classdef

