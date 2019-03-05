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
    % the name of the mesh, as a string. Should be unique within the application
    Name;

    % reference to the mesh, instance of TriMesh (or more generic class)
    Mesh;
    
    % a list of display options, instance of MeshDisplayOptions
    DisplayOptions;
    
    % flag set to true if the mesh was modified
    Modified = false;
    
    % handles to the graphical object(s) used  to display the mesh
    % sub structures: 
    % * patch
    % * vertices
    Handles;
    
end % end properties


%% Constructor
methods
    function obj = MeshHandle(mesh, name)
        % Constructor for MeshHandle class
        
        % store the data and ID
        obj.Mesh = mesh;
        obj.Name = name;
        
        % create new display options
        obj.DisplayOptions = mv.app.MeshDisplayOptions;
        
    end

end % end constructors


%% Methods
methods
end % end methods


%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization
        str = struct('type', 'MeshHandle', ...
            'name', obj.Name, ...
            'displayOptions', toStruct(obj.DisplayOptions), ...
            'mesh', toStruct(obj.Mesh));
    end
end
methods (Static)
    function mh = fromStruct(str)
        % Create a new instance from a structure
        if ~(isfield(str, 'name') && isfield(str, 'mesh'))
            error('Requires fields name and mesh');
        end
        
        mesh = TriMesh.fromStruct(str.mesh);
        mh = mv.app.MeshHandle(mesh, str.name);
        
        if isfield(str, 'displayOptions')
            mh.displayOptions = mv.app.MeshDisplayOptions.fromStruct(str.displayOptions);
        end
    end
end


end % end classdef

