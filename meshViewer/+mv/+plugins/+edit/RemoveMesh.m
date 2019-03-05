classdef RemoveMesh < mv.gui.Plugin
% Removes selected mesh(es) from current scene 
%
%   Class RemoveMesh
%
%   Example
%   RemoveMesh
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-07-02,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = RemoveMesh(varargin)
    % Constructor for RemoveMesh class
    end
end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        % get current mesh
        meshList = selectedMeshHandleList(frame);
        if length(meshList) < 1
            return;
        end

        % remove selected meshed from scene
        inds = frame.SelectedMeshIndices;
        frame.Scene.MeshHandleList(inds) = [];
        
        % update selection
        frame.SelectedMeshIndices = [];
        
        % update display
        updateMeshList(frame);
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef

