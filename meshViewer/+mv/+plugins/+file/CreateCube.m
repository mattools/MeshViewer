classdef CreateCube < mv.gui.Plugin
% Creates a new frame containing an cube
%
%   Class CreateCube
%
%   Example
%   CreateCube
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-07-02,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = CreateCube(varargin)
    % Constructor for CreateCube class

    end

end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        % creates the mesh
        [v, f] = createCube;
        mesh = mv.TriMesh(v, f);
        
        % add new mesh to the current scene
        mh = createMeshHandle(frame.Scene, mesh, 'cube');
        frame.Scene.addMeshHandle(mh);
        
        % update widgets and display
        updateMeshList(frame);
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef

