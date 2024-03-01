classdef SaveSceneAsStructure < mv.gui.Plugin
% Save current scene as a structure in a mat file.
%
%   Class SaveSceneAsStructure
%
%   Example
%   SaveSceneAsStructure
%
%   See also
%     OpenMeshAsStructure

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2024-03-01,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2024 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = SaveSceneAsStructure(varargin)
    % Constructor for SaveSceneAsStructure class
    end
end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>

        % retrieve the current scene
        scene = frame.Scene;

        % Opens a dialog to choose a file
        pattern = fullfile(frame.Gui.LastPathSave, '*.mat');
        [fileName, filePath] = uiputfile(pattern, 'Save Scene as mat-file');
        
        % check if cancel
        if fileName == 0
            return;
        end
        
        % setup last path used for opening
        frame.Gui.LastPathSave = filePath;
        
        % convert scene instance into structure
        str = toStruct(scene);
        
        save(fullfile(filePath, fileName), '-struct', 'str');
    end
end % end methods

end % end classdef

