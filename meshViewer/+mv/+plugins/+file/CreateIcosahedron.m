classdef CreateIcosahedron < mv.gui.Plugin
% Creates a new frame containing an icosahedron
%
%   Class CreateIcosahedron
%
%   Example
%   CreateIcosahedron
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
    function obj = CreateIcosahedron(varargin)
    % Constructor for SayHello class

    end

end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        % creates the mesh
        [v, f] = createIcosahedron;
        mesh = mv.TriMesh(v, f);
        
        addNewMesh(frame, mesh, 'icosahedron');
    end
    
end % end methods

end % end classdef

