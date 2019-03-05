classdef SmoothMesh < mv.gui.Plugin
% Smooth the current mesh
%
%   Class SmoothMesh
%
%   Example
%   SmoothMesh
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
    function obj = SmoothMesh(varargin)
    % Constructor for SmoothMesh class
    end
end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        meshList =  selectedMeshHandleList(frame);
        if length(meshList) < 1
            return;
        end
        
        for iMesh = 1:length(meshList)
            % get data for current mesh
            mh = meshList{iMesh};
            v = mh.Mesh.Vertices;
            f = mh.Mesh.Faces;
            
            % smooth current mesh
            [v, f] = smoothMesh(v, f);
            
            % update mesh
            mh.Mesh.Vertices = v;
            mh.Mesh.Faces = f;
        end
        
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef

