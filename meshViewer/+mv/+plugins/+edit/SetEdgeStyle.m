classdef SetEdgeStyle < mv.gui.Plugin
% Setup color and display of edges in current selection
%
%   Class SetEdgeStyle
%
%   Example
%   SetEdgeStyle
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
    function obj = SetEdgeStyle(varargin)
    % Constructor for SetEdgeStyle class
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

        % Some basic colors
        colorNames = {'Red', 'Green', 'Blue', 'Cyan', 'Yellow', 'Magenta', 'Black', 'White'};
        colorList = [1 0 0;0 1 0;0 0 1;0 1 1;1 1 0;1 0 1;0 0 0;1 1 1];
        
        % choose variable
        gd = GenericDialog('Set Edge Style');
        addCheckBox(gd, 'Show Edges', true);
        addChoice(gd, 'Line Color: ', colorNames, colorNames{7});
        addNumericField(gd, 'Line Width: ', 1, 0);
      
        % display the dialog, and wait for user
        setSize(gd, [350 150]);
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % parse user input
        showEdges = getNextBoolean(gd);
        index = getNextChoiceIndex(gd);
        edgeColor = colorList(index, :);
        lineWidth = getNextNumber(gd);

        % iterate over selected shapes
        if showEdges
            for i = 1:length(meshList)
                mh = meshList{i};
                mh.DisplayOptions.EdgeColor = edgeColor;
                mh.DisplayOptions.EdgeVisible = true;
                set(mh.Handles.Patch, 'EdgeColor', edgeColor, 'LineWidth', lineWidth);
            end
        else
            for i = 1:length(meshList)
                mh = meshList{i};
                mh.DisplayOptions.EdgeVisible = false;
                set(mh.Handles.Patch, 'EdgeColor', 'none');
            end
        end
    end
    
end % end methods

end % end classdef

