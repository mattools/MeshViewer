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
    function obj = PrintMeshInfo(varargin)
    % Constructor for PrintMeshInfo class
    end
end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        meshList = frame.Scene.MeshHandleList;
        if length(meshList) < 1
            return;
        end
       
        inds = frame.SelectedMeshIndices;
        if length(inds) < 1
            return;
        end
        
        for i = 1:length(inds)
            % get current mesh
            mh = meshList{inds(i)};
            mesh = mh.Mesh;
            
            nv = size(mesh.Vertices, 1);
            nf = meshFaceNumber(mesh.Vertices, mesh.Faces);
            
            disp('mesh info:');
            fprintf('  mesh name: %12s\n', mh.Name);
            fprintf('  vertex number:   %6d\n', nv);
            fprintf('  face number:     %6d\n', nf);
            
            bbox = boundingBox3d(mesh.Vertices);
            fprintf('  bounding box:  (%g %g  %g %g  %g %g)\n', bbox);
        end
    end
end % end methods

end % end classdef

