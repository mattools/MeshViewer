classdef OpenSceneAsStructure < mv.gui.Plugin
% Opens scene file and display it into a new frame.
%
%   Class OpenSceneAsStructure
%
%   Example
%   OpenSceneAsStructure
%
%   See also
%     SaveMeshAsStructure

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
    function obj = OpenSceneAsStructure(varargin)
    % Constructor for the OpenSceneAsStructure class
    end
end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
       
        % Opens a dialog to choose a mesh file
        pattern = fullfile(frame.Gui.LastPathOpen, '*.mat');
        [fileName, filePath] = uigetfile(pattern, 'Read .mat Scene file');
        
        % check if cancel
        if fileName == 0
            return;
        end
        
        % setup last path used for opening
        frame.Gui.LastPathOpen = filePath;
        
        % read the mesh contained in the selected file
        fprintf('Reading .mat file...');
        tic;
        str = load(fullfile(filePath, fileName), '-mat');
        
        % check input file validity
        if ~isfield(str, 'Type')
            error('input file does not contain any "type" field');
        end
        if ~strcmp(str.Type, 'mv.app.Scene')
            error('Requires mat file containing structure with mv.app.Scene type');
        end
        
        % parse mesh handle from loaded structure
        scene = mv.app.Scene.fromStruct(str);
        
        % display timing
        t = toc;
        fprintf(' (done in %8.3f ms)\n', t*1000);

        mv.gui.MeshViewerMainFrame(frame.Gui, scene);
    end
end % end methods

end % end classdef

