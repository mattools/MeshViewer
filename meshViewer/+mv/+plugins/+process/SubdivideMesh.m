classdef SubdivideMesh < mv.gui.Plugin
% Smooth the current mesh
%
%   Class SubdivideMesh
%
%   Example
%   SubdivideMesh
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
    function obj = SubdivideMesh(varargin)
    % Constructor for SubdivideMesh class
    end
end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        meshList = selectedMeshHandleList(frame);
        if length(meshList) < 1
            helpdlg("Requires to select at least one input mesh(es).", "Selection Required");
            return;
        end
       
        for iMesh = 1:length(meshList)
            % get data for current mesh
            mh = meshList{iMesh};
            v = mh.Mesh.Vertices;
            f = mh.Mesh.Faces;
            
            if isstruct(f) || size(f, 2) > 3
                errordlg('Requires a triangular mesh', 'Subdivide Error');
                if iMesh > 1
                    updateDisplay(frame);
                end
                return;
            end
            
            % subdivides the mesh and replaces the original one
            [v, f] = subdivideMesh(v, f, 2);
            
            % update mesh
            mh.Mesh.Vertices = v;
            mh.Mesh.Faces = f;
        end
        
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef

