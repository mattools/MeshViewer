classdef TranslateMesh < mv.gui.Plugin
% Smooth the current mesh
%
%   Class TranslateMesh
%
%   Example
%   TranslateMesh
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
    function this = TranslateMesh(varargin)
    % Constructor for TranslateMesh class
    end
end % end constructors


%% Methods
methods
    function run(this, frame, src, evt) %#ok<INUSL>
        
        meshList =  selectedMeshHandleList(frame);
        if length(meshList) < 1
            return;
        end
        
        % create dialog for choosing translation paraemters
        gd = GenericDialog('Translation');
        addNumericField(gd, 'X-Shift', 0, 2);
        addNumericField(gd, 'Y-Shift', 0, 2);
        addNumericField(gd, 'Z-Shift', 0, 2);
        showDialog(gd);
        
        % parse user choices
        shifts = zeros(1, 3);
        for i = 1:3
            shifts(i) = getNextNumber(gd);
        end
        
        % create translation matrix
        mat = createTranslation3d(shifts);
        
        % apply translation matrix to each selected mesh
        for iMesh = 1:length(meshList)
            % get data for current mesh
            mh = meshList{iMesh};
            v = mh.mesh.vertices;
            
            % transform meshes
            v = transformPoint3d(v, mat);
            
            % update mesh
            mh.mesh.vertices = v;
        end
        
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef

