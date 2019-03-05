classdef RenameMesh < mv.gui.Plugin
% Duplicates the current mesh into the current frame(deep copy)
%
%   Class RenameMesh
%
%   Example
%   RenameMesh
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-06-05,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = RenameMesh(varargin)
    % Constructor for RenameMesh class
    end
end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        % get current mesh
        meshList =  selectedMeshHandleList(frame);
        if length(meshList) < 1
            return;
        end
        if length(meshList) > 1
            error('Can not rename more than one mesh');
        end
       
        mh = meshList{1};
        name = mh.Name;
        
        newName = getNextFreeName(frame.Scene, name);
        answers = inputdlg('New Name', 'Rename Mesh', 1, {newName});
        if isempty(answers)
            return;
        end
        
        newName = answers{1};
        if hasMeshWithName(frame.Scene, newName)
            warning(['Name: ' newName ' already exists within scene']);
            return;
        end
        mh.Name = newName;
        
        updateMeshList(frame);
    end
    
end % end methods

end % end classdef

