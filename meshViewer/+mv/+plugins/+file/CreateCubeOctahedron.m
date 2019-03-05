classdef CreateCubeOctahedron < mv.gui.Plugin
% Creates a new frame containing a cube-octahedron
%
%   Class CreateCubeOctahedron
%
%   Example
%   CreateCubeOctahedron
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
    function obj = CreateCubeOctahedron(varargin)
    % Constructor for CreateCubeOctahedron class

    end

end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        % creates the mesh
        [v, f] = createCubeOctahedron;
        mesh = TriMesh(v, f);
        
        % add new mesh to the current scene
        mh = createMeshHandle(frame.Scene, mesh, 'cubeOctahedron');
        frame.Scene.addMeshHandle(mh);
        
        % update widgets and display
        updateMeshList(frame);
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef

