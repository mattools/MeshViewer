function varargout = MeshViewer(varargin)
%MESHVIEWER Launcher for the MeshViewer application
%
%   output = MeshViewer(input)
%
%   Example
%   MeshViewer
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-05-25,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - Cepia Software Platform.

if nargin == 0
    % generate a default mesh
    [v, f] = torusMesh([50 50 50 30 10 30 45]);
    mesh = TriMesh(v, f);
elseif nargin == 2
    % parses input
    v = varargin{1};
    f = varargin{2};
    mesh = TriMesh(v, f);
else
    error('Unable to process input arguments');
end

% create the application, and a GUI
app = mv.app.MeshViewerApp;
gui = mv.gui.MeshViewerGUI(app);

addNewMeshFrame(gui, mesh);
