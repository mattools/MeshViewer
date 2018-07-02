classdef CreateOctahedron < mv.gui.Plugin
% Creates a new frame containing an octahedron
%
%   Class CreateOctahedron
%
%   Example
%   CreateOctahedron
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
    function this = CreateOctahedron(varargin)
    % Constructor for CreateOctahedron class

    end

end % end constructors


%% Methods
methods
    function run(this, frame, src, evt) %#ok<INUSL>
        
        % creates the mesh
        [v, f] = createOctahedron;
        mesh = TriMesh(v, f);
        
        % add new mesh to the current scene
        mh = createMeshHandle(frame.scene, mesh, 'octahedron');
        frame.scene.addMeshHandle(mh);
        
        % update widgets and display
        updateMeshList(frame);
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef

