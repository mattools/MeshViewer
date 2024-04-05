function varargout = MeshViewer(varargin)
%MESHVIEWER Launcher for the MeshViewer application.
%
%   Launch a new MeshViewer frame. The frame can be initialized with a mesh
%   to quickly display it.
%
%   Syntax
%     MeshViewer;
%     MeshViewer(MESH);
%     MeshViewer(V, F);
%     viewer = MeshViewer(...);
%
%   Input Arguments
%     MESH - A Matlab struct containing fields 'vertices' and 'faces'.
%     'vertices' field is a NV-by-3 numeric array containing  vertex
%     coordinates. 'faces' field is a NF-by-3 or NF-by-4 numeric array, or
%     a NF-by-1 cell array containing the vertex indices of each face. 
%     V,F - The vertices and faces of the mesh specified as two distinct
%     input arguments. 
%
%   Output Arguments
%     viewer - the handle to the newly created frame.
%
%   Examples
%     % creates a new empty frame.
%     MeshViewer
%
%     % creates a new frame initialized with a default mesh
%     [v, f] = createIcosahedron;
%     MeshViewer(v, f);
%
%   See also
%     mv.app.MeshViewerAppData, mv.gui.MeshViewerMainFrame
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-05-25,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - Cepia Software Platform.


%% Parse input argument(s)

% default values for initial mesh
mesh = [];
meshName = 'Mesh';

% check if a mesh is provided as input
if nargin == 1
    % single argument -> assume a mesh is provided, either as a Matlab
    % struct or as Mesh class 
    var1 = varargin{1};
    if isa(var1, 'mv.TriMesh')
        % keep reference to mesh
        mesh = var1;

    elseif isstruct(var1)
        % parses vertices and faces from structure
        v = var1.vertices;
        f = var1.faces;
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

% return handleto current viewer if requested
if nargout > 0
    varargout = {viewer};
end
