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
            helpdlg("Requires to select input mesh(es).", "Selection Required");
            return;
        end
        
        for i = 1:length(inds)
            % get current mesh
            mh = meshList{inds(i)};
            mesh = mh.Mesh;
            
            disp('mesh info:');
            fprintf('  mesh name:         %12s\n', mh.Name);
            fprintf('  vertex number:           %6d\n', vertexCount(mesh));
            ne = edgeCount(mesh);
            if ne > 0
                fprintf('  edge number:             %6d\n', ne);
            else
                fprintf('  edge number:       not computed\n');
            end
            fprintf('  face number:             %6d\n', faceCount(mesh));
            
            bbox = boundingBox3d(mesh.Vertices);
            fprintf('  bounding box:  [%g %g  %g %g  %g %g]\n', bbox);
        end
    end
end % end methods

end % end classdef

