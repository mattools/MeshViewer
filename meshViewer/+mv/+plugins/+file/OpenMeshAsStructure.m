classdef OpenMeshAsStructure < mv.gui.Plugin
% Opens mesh file and import into current frame
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
% Created: 2018-05-24,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = OpenMeshAsStructure(varargin)
    % Constructor for the OpenMeshAsStructure class
    end
end % end constructors


%% Methods
methods
    function run(this, frame, src, evt) %#ok<INUSL>
       
        % Opens a dialog to choose a mesh file
        pattern = fullfile(frame.gui.lastPathOpen, '*.mesh');
        [fileName, filePath] = uigetfile(pattern, 'Read .mat Mesh file');
        
        % check if cancel
        if fileName == 0
            return;
        end
        
        % setup last path used for opening
        frame.gui.lastPathOpen = filePath;
        
        % read the mesh contained in the selected file
        fprintf('Reading .mat file...');
        tic;
        str = load(fullfile(filePath, fileName), '-mat');
        
        % check input file validity
        if ~isfield(str, 'type')
            error('input file does not contain any "type" field');
        end
        if ~strcmp(str.type, 'MeshHandle')
            error('Requires mat file containing structure with MeshHandle type');
        end
        
        % parse mesh handle from loaded structure
        meshHandle = mv.app.MeshHandle.fromStruct(str);
        
        % display timing
        t = toc;
        fprintf(' (done in %8.3f ms)\n', t*1000);

        [path, name] = fileparts(fileName); %#ok<ASGLU>
        addNewMesh(frame, meshHandle, name);
    end
    
end % end methods

end % end classdef

