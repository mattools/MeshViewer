classdef OpenMeshFile < mv.gui.Plugin
% Opens mesh file from known format and creates a new frame.
%
%   Class OpenMeshFile
%
%   Example
%   OpenMeshFile
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2018-05-24,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = OpenMeshFile(varargin)
    % Constructor for the OpenMeshFile class
    end
end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
       
        % Opens a dialog to choose a mesh file
        filters = {
            '*.off;*.ply;*.obj;*.stl', 'Mesh Files (*.off,*.ply,*.obj,*.stl)';
            '*.ply', 'PLY files (*.ply)'; ...
            '*.off', 'OFF files(*.off)'; ...
            '*.obj', 'OBJ files(*.obj)'; ...
            '*.stl', 'STL files(*.stl)'; ...
            '*.*',  'All Files (*.*)'};
        [fileNames, filePath] = uigetfile(filters, 'Read Mesh file', ...
            frame.Gui.LastPathOpen, ...
            'MultiSelect', 'on');
        
        % check if cancel
        if iscell(fileNames) && isempty(fileNames)
            return;
        end
        if isnumeric(fileNames) && fileNames == 0
            return;
        end
        
        % setup last path used for opening
        frame.Gui.LastPathOpen = filePath;
        
        if ~iscell(fileNames)
            fileNames = {fileNames};
        end

        % iterate over the file list to read
        for iFile = 1:length(fileNames)
            % read the mesh contained in the selected file
            fileName = fileNames{iFile};
            fprintf('Reading mesh file: %s', fileName);
            tic;
            mesh = readMesh(fullfile(filePath, fileName));
            t = toc;
            fprintf(' (done in %8.3f ms)\n', t*1000);

            % Create mesh data structure
            mesh = mv.TriMesh(mesh);

            [path, name] = fileparts(fileName); %#ok<ASGLU>
            addNewMesh(frame, mesh, name);
        end
    end
    
end % end methods

end % end classdef

