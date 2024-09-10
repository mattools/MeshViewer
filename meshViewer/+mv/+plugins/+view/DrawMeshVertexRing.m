classdef DrawMeshVertexRing < mv.gui.Plugin
% One-line description here, please.
%
%   Class DrawMeshVertexRing
%
%   Example
%   DrawMeshVertexRing
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2024-09-10,    using Matlab 24.1.0.2628055 (R2024a) Update 4
% Copyright 2024 INRAE - BIA-BIBS.


%% Constructor
methods
    function obj = DrawMeshVertexRing(varargin)
        % Constructor for DrawMeshVertexRing class.

    end

end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        meshList = selectedMeshHandleList(frame);
        if length(meshList) ~= 1
            helpdlg("Need to select a single mesh", "Selection Required");
            return;
        end

        % creates a new dialog, and populates with query point coordinates
        gd = GenericDialog('Vertex Ring');
        addNumericField(gd, 'Vertex Index: ', 1, 0);

        % displays the dialog, and waits for user
        showDialog(gd);
        % check if ok or cancel button was clicked
        if wasCanceled(gd)
            return;
        end

        % retrieve the user inputs
        index = getNextNumber(gd);
        if index < 1
            helpdlg("Index must be greater than 0.");
            return;
        end

        mh = meshList{1};
        inds = meshVertexRing(mh.Mesh.Vertices, mh.Mesh.Faces, index);
        poly = mh.Mesh.Vertices(inds, :);

        mh.VertexRings = [mh.VertexRings {poly}];

        updateDisplay(frame);
    end
    
end % end methods

end % end classdef

