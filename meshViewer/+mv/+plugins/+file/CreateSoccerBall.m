classdef CreateSoccerBall < mv.gui.Plugin
% Creates a new frame containing a Soccer Ball polyhedron
%
%   Class CreateSoccerBall
%
%   Example
%   CreateSoccerBall
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
    function obj = CreateSoccerBall(varargin)
    % Constructor for CreateSoccerBall class

    end

end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        % creates the mesh
        [v, f] = createSoccerBall;
        mesh = mv.TriMesh(v, f);
        
        % add new mesh to the current scene
        addNewMesh(frame, mesh, 'soccerBall');
    end
    
end % end methods

end % end classdef

