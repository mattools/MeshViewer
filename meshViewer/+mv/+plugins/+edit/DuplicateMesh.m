classdef DuplicateMesh < mv.gui.Plugin
% Duplicates the current mesh into the current frame (deep copy)
%
%   Class DuplicateMesh
%
%   Example
%   DuplicateMesh
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
    function this = DuplicateMesh(varargin)
    % Constructor for DuplicateMesh class
    end
end % end constructors


%% Methods
methods
    function run(this, frame, src, evt) %#ok<INUSL>
        
        % get current mesh
        meshList =  selectedMeshHandleList(frame);
        if length(meshList) < 1
            return;
        end
       
        for iMesh = 1:length(meshList)
            mh = meshList{iMesh};
            v = mh.mesh.vertices;
            f = mh.mesh.faces;
            
            % creates a new mesh instance
            mesh = TriMesh(v, f);
            mh = createMeshHandle(frame.scene, mesh, mh.id);
            
            % add new mesh to the current scene
            frame.scene.addMeshHandle(mh);
        end
        
        updateMeshList(frame);
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef

