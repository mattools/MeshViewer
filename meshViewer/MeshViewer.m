function MeshViewer(varargin)
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


%% Parse input argument(s)

if nargin == 0
    % no argument -> create a new empty viewer
    mesh = [];

elseif nargin == 1
    mesh = varargin{1};
    if isa(mesh, 'TriMesh')
        % nothing to do!
    elseif isstruct(mesh)
        v = mesh.vertices;
        f = mesh.faces;
        mesh = TriMesh(v, f);
        meshName = inputname(1);
    else
        error('Requires the input to be a mesh structure or a Mesh class instance');
    end
    
elseif nargin == 2
    % parses input
    v = varargin{1};
    f = varargin{2};
    mesh = TriMesh(v, f);
    meshName = 'Mesh';
else
    error('Unable to process input arguments');
end


%% Create data for applicatino

% create the application, and a GUI
%app = mv.app.MeshViewerAppData;
gui = mv.gui.MeshViewerGUI();

% create new frame
if ~isempty(mesh)
    addNewMeshFrame(gui, mesh, meshName);
else
    addNewMeshFrame(gui);
end


