classdef SaveMeshAsStructure < mv.gui.Plugin
% Save selected mesh as a structure in a mat file.
%
%   Class SaveMeshAsStructure
%
%   Example
%   SaveMeshAsStructure
%
%   See also
%     OpenMeshAsStructure

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
    function obj = SaveMeshAsStructure(varargin)
    % Constructor for SaveMeshAsStructure class
    end
end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>

        % check number of selected meshes
        meshList =  selectedMeshHandleList(frame);
        if length(meshList) ~= 1
            warning('Requires selection to contains only one mesh');
            return;
        end
        
        % get current mesh handle
        mh = meshList{1};

        % Opens a dialog to choose a mesh file
        pattern = fullfile(frame.Gui.LastPathSave, '*.mesh');
        [fileName, filePath] = uiputfile(pattern, 'Save Mesh file');
        
        % check if cancel
        if fileName == 0
            return;
        end
        
        % setup last path used for opening
        frame.Gui.LastPathSave = filePath;
        
        % convert mesh handle into structure
        str = toStruct(mh);
        
        save(fullfile(filePath, fileName), '-struct', 'str');
    end
end % end methods

end % end classdef

