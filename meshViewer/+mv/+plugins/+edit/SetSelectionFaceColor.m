classdef SetSelectionFaceColor < mv.gui.Plugin
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
    function obj = SetSelectionFaceColor(varargin)
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

        % open color chooser dialog
%         defaultColor = [1 0 0];
        mh = meshList{1};
        defaultColor = get(mh.Handles.Patch, 'FaceColor');
        newColor = uisetcolor(defaultColor, 'Set Line Color');

        % iterate over selected shapes
        for i = 1:length(meshList)
            mh = meshList{i};
            mh.DisplayOptions.FaceColor = newColor;
            set(mh.Handles.Patch, 'FaceColor', newColor);
        end
    end
    
end % end methods

end % end classdef

