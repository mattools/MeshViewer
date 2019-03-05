classdef TriangulateMesh < mv.gui.Plugin
% Ensure the current mesh is a triangle mesh
%
%   Class TriangulateMesh
%
%   Example
%   TriangulateMesh
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
    function obj = TriangulateMesh(varargin)
    % Constructor for TriangulateMesh class
    end
end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        meshList =  selectedMeshHandleList(frame);
        if length(meshList) < 1
            return;
        end
       
        % triangulate the faces
        for iMesh = 1:length(meshList)
            % get data for current mesh
            mh = meshList{iMesh};
            
            % compute new face indices
            tri = triangulateFaces(mh.Mesh.Faces);
            
            % update mesh
            mh.Mesh.Faces = tri;
        end
        
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef

