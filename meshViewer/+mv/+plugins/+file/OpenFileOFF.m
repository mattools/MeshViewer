classdef OpenFileOFF < mv.gui.Plugin
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
    function this = OpenFileOFF(varargin)
    % Constructor for SayHello class
    end
end % end constructors


%% Methods
methods
    function run(this, frame, src, evt) %#ok<INUSL>
       
        % Opens a dialog to choose a mesh file
        [fileName, filePath] = uigetfile('*.off', 'Read OFF Mesh file');
        
        % check if cancel
        if fileName == 0
            return;
        end
        
        % read the mesh contained in the selected file
        [v, f] = readMesh_off(fullfile(filePath, fileName));
        mesh = TriMesh(v, f);
        
        % creates new frame
        addNewMeshFrame(frame.gui, mesh);
    end
end % end methods

end % end classdef

