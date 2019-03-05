classdef UniformScalingMesh < mv.gui.Plugin
% Smooth the current mesh
%
%   Class UniformScalingMesh
%
%   Example
%   UniformScalingMesh
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
    function obj = UniformScalingMesh(varargin)
    % Constructor for UniformScalingMesh class
    end
end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        meshList =  selectedMeshHandleList(frame);
        if length(meshList) < 1
            return;
        end
        
        % create dialog for choosing translation paraemters
        gd = GenericDialog('Scaling');
        addNumericField(gd, 'Factor', 1, 2);
        showDialog(gd);
        if wasCanceled(gd)
            return;
        end
            
        % parse user choices
        ratio = getNextNumber(gd);
        
        % create translation matrix
        mat = createScaling3d(ratio);
        
        % apply translation matrix to each selected mesh
        for iMesh = 1:length(meshList)
            % get data for current mesh
            mh = meshList{iMesh};
            v = mh.Mesh.Vertices;
            
            % transform meshes
            v = transformPoint3d(v, mat);
            
            % update mesh
            mh.Mesh.Vertices = v;
        end
        
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef

