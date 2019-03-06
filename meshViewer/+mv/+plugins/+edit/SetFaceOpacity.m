classdef SetFaceOpacity < mv.gui.Plugin
% Setup opacity of faces
%
%   Class SetFaceOpacity
%
%   Example
%   SetFaceOpacity
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-01-07,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = SetFaceOpacity(varargin)
    % Constructor for SetFaceOpacity class
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

        % Create a dialog to setup variable
        gd = GenericDialog('Set Face Opacity');
        addNumericField(gd, 'Opacity: ', 1, 0);
      
        % display the dialog, and wait for user input
        setSize(gd, [350 150]);
        showDialog(gd);
        
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % parse user input
        alpha = getNextNumber(gd);

        % iterate over selected shapes
        for i = 1:length(meshList)
            mh = meshList{i};
            mh.DisplayOptions.FaceOpacity = alpha;
            set(mh.Handles.Patch, 'FaceAlpha', alpha);
        end
    end
    
end % end methods

end % end classdef

