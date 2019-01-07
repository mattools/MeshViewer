classdef SetFaceTransparency < mv.gui.Plugin
% Setup color and display of edges in current selection
%
%   Class SetFaceTransparency
%
%   Example
%   SetFaceTransparency
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
    function this = SetFaceTransparency(varargin)
    % Constructor for SetFaceTransparency class
    end
end % end constructors


%% Methods
methods
    function run(this, frame, src, evt) %#ok<INUSL>
        
        % get current mesh
        meshList =  selectedMeshHandleList(frame);
        if length(meshList) < 1
            return;
        end

        % choose variable
        gd = GenericDialog('Set Face Transparency');
        addNumericField(gd, 'Transparency: ', 1, 0);
      
        % display the dialog, and wait for user
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
            set(mh.handles.patch, 'FaceAlpha', alpha);
        end
    end
    
end % end methods

end % end classdef

