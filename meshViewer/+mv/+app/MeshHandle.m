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

    % The boundary of the mesh, as a collection of 3D polygons.
    % If not computed, value is empty.
    BoundaryPolygons = {};
    
    % a list of display options, instance of MeshDisplayOptions
    DisplayOptions;
    
    % flag set to true if the mesh was modified
    Modified = false;
    
    % handles to the graphical object(s) used  to display the mesh
    % sub structures: 
    % * Patch
    % * Vertices
    % * BoundaryPolygons
    Handles;
    
end % end properties


%% Constructor
methods
    function obj = MeshHandle(mesh, name)
        % Constructor for MeshHandle class.
        
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
        % Convert to a structure to facilitate serialization.
        str = struct('Type', 'mv.app.MeshHandle', ...
            'Name', obj.Name, ...
            'DisplayOptions', toStruct(obj.DisplayOptions), ...
            'Mesh', toStruct(obj.Mesh));
        % Note: do not store references to graphical handles nor to
        % modification flag.
    end
end

methods (Static)
    function mh = fromStruct(str)
        % Create a new instance from a structure.

        names = fieldnames(str);
        indName = find(strcmpi(names, 'Name'), 1);
        indMesh = find(strcmpi(names, 'Mesh'), 1);
        if isempty(indName) || isempty(indMesh)
            error('Requires fields name and mesh');
        end
        
        mesh = mv.TriMesh.fromStruct(str.(names{indMesh}));
        name = str.(names{indName});
        mh = mv.app.MeshHandle(mesh, name);
        
        indOptions = find(strcmpi(names, 'DisplayOptions'), 1);
        if isempty(indOptions)
            mh.DisplayOptions = mv.app.MeshDisplayOptions.fromStruct(str.(names{indOptions}));
        end
    end
end


end % end classdef

