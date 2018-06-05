classdef RecenterMesh < mv.gui.Plugin
% Opens mesh file and creates a new frame
%
%   Class SayHello
%
%   Example
%   SayHello
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-05-24,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = RecenterMesh(varargin)
    % Constructor for RecenterMesh class
    end
end % end constructors


%% Methods
methods
    function run(this, frame, src, evt) %#ok<INUSL>
        
        meshList = frame.scene.meshHandleList;
        if length(meshList) < 1
            return;
        end
       
        mh = meshList{1};
        v = mh.mesh.vertices;
        % recenter by removing the mean
        v = bsxfun(@minus, v, mean(v, 1));
        
        % update mesh
        mh.mesh.vertices = v;
        
        updateDisplay(frame);
        
    end
end % end methods

end % end classdef

