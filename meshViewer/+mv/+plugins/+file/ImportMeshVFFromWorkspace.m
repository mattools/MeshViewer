classdef ImportMeshVFFromWorkspace < mv.gui.Plugin
% Import a mesh from a struct in workspace
%
%   Class SayHello
%
%   Example
%   SayHello
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-01-03,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = ImportMeshVFFromWorkspace(varargin)
    % Constructor for SayHello class
    end
end % end constructors


%% Methods
methods
    function run(this, frame, src, evt) %#ok<INUSL>
       
        % identifies the name of input variables
        vars = evalin('base', 'whos');
        vars = vars(strcmp({vars.class}, 'double'));
        varNames = {vars.name};

        % choose variable
        gd = GenericDialog('Import from Workspace');
        addChoice(gd, 'Variable for Vertices: ', varNames, varNames{1});
        addChoice(gd, 'Variable for Faces: ', varNames, varNames{1});
        addTextField(gd, 'Name of new Mesh: ', 'NewMesh');
      
        % display the dialog, and wait for user
        setSize(gd, [350 200]);
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end

        % extract data
        vertices = evalin('base', getNextString(gd));
        faces = evalin('base', getNextString(gd));
        meshName = getNextString(gd);
        
        % check data type
        if ~isnumeric(vertices)
            errordlg('Input vertices must be a numeric array', 'Workspace Import Error');
            return;
        end
        if ~isnumeric(faces)
            errordlg('Input faces must be a numeric array', 'Workspace Import Error');
            return;
        end

        if size(faces, 2) ~= 3 
            errordlg('Can only process triangular meshes', 'Workspace Import Error');
            return;
        end

        % convert to mesh
        mesh = TriMesh(vertices, faces);

        addNewMesh(frame, mesh, meshName);
    end
end % end methods

end % end classdef

