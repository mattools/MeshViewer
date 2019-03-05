classdef RotateMeshMainAxes < mv.gui.Plugin
% Rotates the selected mesh(es) around one of the main axes
%
%   Class RotateMeshMainAxes
%
%   Example
%   RotateMeshMainAxes
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-01-30,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = RotateMeshMainAxes(varargin)
    % Constructor for RotateMeshMainAxes class
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
        gd = GenericDialog('Rotate Mesh');
        addChoice(gd, 'Rotation Axis: ', {'X-Axis', 'Y-Axis', 'Z-Axis'});
        addChoice(gd, 'Center: ', {'Global', 'Mesh Centroid'});
        addNumericField(gd, 'Rotation Angle (degrees): ', 0, 2);
        gd.setSize([350 200]);
        showDialog(gd);
        if wasCanceled(gd)
            return;
        end
            
        % parse user choices
        axisIndex = getNextChoiceIndex(gd);
        originIndex = getNextChoiceIndex(gd);
        rotAngle = getNextNumber(gd);
        
        % create base rotationtransform
        switch axisIndex
            case 1
                rotMat = createRotationOx(rotAngle);
            case 2
                rotMat = createRotationOy(rotAngle);
            case 3
                rotMat = createRotationOz(rotAngle);
        end
        
        if originIndex == 1
            origin = [0 0 0];
        end
        
        % apply translation matrix to each selected mesh
        for iMesh = 1:length(meshList)
            % get data for current mesh
            mh = meshList{iMesh};
            v = mh.Mesh.Vertices;
            
            % create translation matrix
            if originIndex == 2
                origin = centroid(v);
            end
            transfo = recenterTransform3d(rotMat, origin);
            
            % transform meshes
            v = transformPoint3d(v, transfo);
            
            % update mesh
            mh.Mesh.Vertices = v;
        end

        updateDisplay(frame);
    end
    
end % end methods

end % end classdef

