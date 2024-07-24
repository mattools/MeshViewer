classdef ImportSampleMesh < mv.gui.Plugin
% Import a sample mesh identiifed by its name into current viewer.
%
%   Class ImportSampleMesh_Bunny1k
%
%   Example
%   ImportSampleMesh_Bunny1k
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2018-07-02,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
    MeshFileName;
    MeshName = '';
end % end properties


%% Constructor
methods
    function obj = ImportSampleMesh(fileName, varargin)
    % Constructor for CreateRhombododecahedron class

        % check input arguments
        if isempty(fileName) || ~ischar(fileName)
            error('Requires to specify file name as char array');
        end

        obj.MeshFileName = fileName;

        if isempty(varargin)
            [~, name] = fileparts(fileName);
            obj.MeshName = name;
        else
            if ~ischar(varargin{1})
                error('Mesh name must be a char array');
            end
            obj.MeshName = varargin{1};
        end            
    end

end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        % creates the mesh
        [v, f] = readMesh(obj.MeshFileName);
        mesh = mv.TriMesh(v, f);
        
        % add new mesh to the current scene
        mh = createMeshHandle(frame.Scene, mesh, obj.MeshName);
        frame.Scene.addMeshHandle(mh);
        
        % update bounding box of view box from scene content
        bbox = computeBoundingBox(frame.Scene);
        setViewBox(frame.Scene.DisplayOptions, bbox);
        
        % update widgets and display
        updateMeshList(frame);
        updateDisplay(frame);
    end
    
end % end methods

end % end classdef

