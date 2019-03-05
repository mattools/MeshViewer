classdef SimplifyMeshByReducePatch < mv.gui.Plugin
% Simplifies a triangular mesh by using Matlab reducepatch command
%
%   Class SimplifyMeshByReducePatch
%
%   Example
%   SimplifyMeshByReducePatch
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-01-30,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = SimplifyMeshByReducePatch(varargin)
    % Constructor for SimplifyMeshByReducePatch class

    end

end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        meshList =  selectedMeshHandleList(frame);
        if length(meshList) < 1
            return;
        end
       
        % choose variable
        gd = GenericDialog('Simplify using reducepatch');
        addNumericField(gd, 'Face Number: ', 1000, 0);
      
        % display the dialog, and wait for user
        setSize(gd, [250 150]);
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % parse user input
        faceNumber = getNextNumber(gd);

        % iterate over selected meshes
        for iMesh = 1:length(meshList)
            % get data for current mesh
            mh = meshList{iMesh};
            mesh = mh.Mesh;
            
            if iscell(mesh.Faces) || size(mesh.Faces, 2) > 3
                errordlg('Requires a triangular mesh', 'Simplify Error');
                if iMesh > 1
                    updateDisplay(frame);
                end
                return;
            end
            
            % subdivides the mesh and replaces the original one
            str = struct('vertices', mesh.Vertices, 'faces', mesh.Faces);
            str = reducepatch(str, faceNumber);
            
            % update mesh
            mh.Mesh.Vertices = str.vertices;
            mh.Mesh.Faces = str.faces;
        end
        
        updateDisplay(frame);
    end
end % end methods

end % end classdef

