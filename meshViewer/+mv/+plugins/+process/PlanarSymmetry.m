classdef PlanarSymmetry < mv.gui.Plugin
% Apply a planar symmetry transform on the selected mesh(es)
%
%   Class PlanarSymmetry
%
%   Example
%   PlanarSymmetry
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
    function this = PlanarSymmetry(varargin)
    % Constructor for PlanarSymmetry class
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
        gd = GenericDialog('Planar Symmetry');
        addChoice(gd, 'Direction: ', {'YZ-Plane', 'XZ-Plane', 'XY-Plane'}, 'YZ-Plane');
        addChoice(gd, 'Plane Origin', {'Global Origin', 'Mesh centroid'}, 'Global Origin');
        showDialog(gd);
        if wasCanceled(gd)
            return;
        end
            
        % parse user choices
        dirIndex = getNextChoiceIndex(gd);
        originIndex = getNextChoiceIndex(gd);
        
        % create base symmery transform
        switch dirIndex
            case 1
                init = diag([-1 1 1 1]);
            case 2
                init = diag([1 -1 1 1]);
            case 3
                init = diag([1 1 -1 1]);
        end
        
        if originIndex == 1
            origin = [0 0 0];
        end
            
        
        % apply translation matrix to each selected mesh
        for iMesh = 1:length(meshList)
            % get data for current mesh
            mh = meshList{iMesh};
            v = mh.mesh.vertices;
            
            % create translation matrix
            if originIndex == 2
                origin = centroid(v);
            end
            transfo = recenterTransform3d(init, origin);
            
            % transform meshes
            v = transformPoint3d(v, transfo);
            
            % update mesh
            mh.mesh.vertices = v;
        end
        
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef

