classdef ImportMeshFromStruct < mv.gui.Plugin
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
    function this = ImportMeshFromStruct(varargin)
    % Constructor for SayHello class
    end
end % end constructors


%% Methods
methods
    function run(this, frame, src, evt) %#ok<INUSL>
       
        % identifies the name of struct variables
        vars = evalin('base', 'whos');
        vars = vars(strcmp({vars.class}, 'struct'));
        structNames = {vars.name};
        
        % checkup
        if isempty(structNames)
            errordlg('Workspace does not contain any struct', 'Workspace Import Error');
            return;
        end
        
        % choose variable
        gd = GenericDialog('Import struct from Workspace');
        addChoice(gd, 'Variable: ', structNames, structNames{1});
      
        % display the dialog, and wait for user
        setSize(gd, [350 150]);
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % extract data
        name = getNextString(gd);
        data = evalin('base', name);
        
        % check data type
        if ~isstruct(data)
            errordlg('Input variable must be a struct', 'Workspace Import Error');
            return;
        end
        if ~isfield(data, 'vertices') || ~isfield(data, 'faces')
            errordlg('Structure must contain fields "vertices" and "faces"', 'Workspace Import Error');
            return;
        end

        if size(data.faces, 2) ~= 3 
            errordlg('Can only process triangular meshes', 'Workspace Import Error');
            return;
        end

        % convert to mesh
        mesh = TriMesh(data.vertices, data.faces);
        
        addNewMesh(frame, mesh, name);
    end
end % end methods

end % end classdef

