classdef RenameScene < mv.gui.Plugin
% Rename the current scene.
%
%   Class RenameScene
%
%   Example
%   RenameScene
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-06-05,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Constructor
methods
    function obj = RenameScene(varargin)
    % Constructor for RenameScene class.
    end
end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        % open a dialog to choose new name
        newName = frame.Scene.Name;
        answers = inputdlg('New Name', 'Rename Scene', 1, {newName});
        if isempty(answers)
            return;
        end
        
        % update name of the scene
        newName = answers{1};
        frame.Scene.Name = newName;
        
        % update display
        updateTitle(frame);
    end
    
end % end methods

end % end classdef

