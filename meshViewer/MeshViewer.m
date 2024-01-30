function varargout = MeshViewer(varargin)
%MESHVIEWER Launcher for the MeshViewer application.
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

meshName = '';

if nargin == 0
    % no argument -> create a new empty viewer
    mesh = [];

elseif nargin == 1
    % single argument -> assume a mesh, either as struct or as Mesh class
    mesh = varargin{1};
    if isa(mesh, 'mv.TriMesh')
        % nothing to do!
    elseif isstruct(mesh)
        % parses vertices and faces from structure
        v = mesh.vertices;
        f = mesh.faces;
        mesh = mv.TriMesh(v, f);
        % retrieve name of input argument to initialize mesh name
        meshName = inputname(1);
    else
        error('Requires the input to be a mesh structure or a Mesh class instance');
    end
    
elseif nargin == 2
    % assumes two arguments correspond to vertices and faces,
    % and create a new TriMesh
    v = varargin{1};
    f = varargin{2};
    mesh = mv.TriMesh(v, f);
else
    error('Unable to process input arguments');
end

if isempty(meshName)
    meshName = 'Mesh';
end

%% Create data for applicatino

% create a new GUI
gui = mv.gui.MeshViewerGUI();

% create new frame
if ~isempty(mesh)
    viewer = addNewMeshFrame(gui, mesh, meshName);
else
    viewer = addNewMeshFrame(gui);
end

if nargout > 0
    varargout = {viewer};
end
