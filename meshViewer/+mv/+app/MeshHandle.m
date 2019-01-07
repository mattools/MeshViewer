classdef MeshHandle < handle
%MESHHANDLE  One-line description here, please.
%
%   Class MeshHandle
%
%   Example
%   MeshHandle
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-05-03,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
    % the ID of the mesh, as a string. Should be unique within the application
    id;

    % reference to the mesh, instance of TriMesh (or more generic class)
    mesh;
    
    % handles to the graphical object(s) used  to display the mesh
    % sub structures: 
    % * patch
    % * vertices
    handles;
    
    % a list of display options, instance of MeshDisplayOptions
    displayOptions;
    
    % flag set to true if the mesh was modified
    modified = false;
    
end % end properties


%% Constructor
methods
    function this = MeshHandle(mesh, id)
        % Constructor for MeshHandle class
        
        % store the data and ID
        this.mesh = mesh;
        this.id = id;
        
        % create new display options
        this.displayOptions = mv.app.MeshDisplayOptions;
        
    end

end % end constructors


%% Methods
methods
end % end methods

end % end classdef

