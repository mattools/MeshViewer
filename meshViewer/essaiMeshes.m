%ESSAIMESHES  One-line description here, please.
%
%   output = essaiMeshes(input)
%
%   Example
%   essaiMeshes
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-05-03,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - Cepia Software Platform.

% creates a default mesh
[v, f] = createOctahedron;
mesh = TriMesh(v, f);

% % data handle
% mh = mv.app.MeshHandle(mesh, 'octahedron');
% scene = mv.app.Scene();
% scene.addMeshHandle(mh);

% create the application, and a GUI
app = mv.app.MeshViewerApp;
gui = mv.gui.MeshViewerGUI(app);

% frame = mv.gui.MeshViewerMainFrame(gui, scene);
frame = addNewMeshFrame(gui, mesh);

