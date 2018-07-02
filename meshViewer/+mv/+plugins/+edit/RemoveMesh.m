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
    function this = RemoveMesh(varargin)
    % Constructor for RemoveMesh class
    end
end % end constructors


%% Methods
methods
    function run(this, frame, src, evt) %#ok<INUSL>
        
        % get current mesh
        meshList = selectedMeshHandleList(frame);
        if length(meshList) < 1
            return;
        end

        % remove selected meshed from scene
        inds = frame.selectedMeshIndices;
        frame.scene.meshHandleList(inds) = [];
        % update selection
        frame.selectedMeshIndices = [];
        
        updateMeshList(frame);
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef

