classdef EnsureManifoldMesh < mv.gui.Plugin
%ENSUREMANIFOLDMESH  One-line description here, please.
%
%   Class EnsureManifoldMesh
%
%   Example
%   EnsureManifoldMesh
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-01-28,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = EnsureManifoldMesh(varargin)
    % Constructor for EnsureManifoldMesh class

    end

end % end constructors


%% Methods
methods
    function run(this, frame, src, evt) %#ok<INUSL>
        
        meshList =  selectedMeshHandleList(frame);
        if length(meshList) < 1
            return;
        end
       
        for iMesh = 1:length(meshList)
            % get data for current mesh
            mh = meshList{iMesh};
            v = mh.mesh.vertices;
            f = mh.mesh.faces;
            
            if isstruct(f) || size(f, 2) > 3
                errordlg('Requires a triangular mesh', 'Subdivide Error');
                if iMesh > 1
                    updateDisplay(frame);
                end
                return;
            end
            
            % Apply cleanup operations to ensure manifold
            f2 = removeDuplicateFaces(f);
            [v2, f2] = removeMeshEars(v, f2);
           
            % update mesh
            mh.mesh.vertices = v2;
            mh.mesh.faces = f2;
        end
        
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef

