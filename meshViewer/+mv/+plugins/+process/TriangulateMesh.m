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
    function this = TriangulateMesh(varargin)
    % Constructor for TriangulateMesh class
    end
end % end constructors


%% Methods
methods
    function run(this, frame, src, evt) %#ok<INUSL>
        
        meshList = frame.scene.meshHandleList;
        if length(meshList) < 1
            return;
        end
       
        % triangulate the faces
        mh = meshList{1};
        tri = triangulateFaces(mh.mesh.faces);
        
        % update mesh
        mh.mesh.faces = tri;
        
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef

