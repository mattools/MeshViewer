classdef MeshViewerGUI < handle
%MESHVIEWERGUI Manager of the different frames
%
%   Class MeshViewerGUI
%
%   Example
%   MeshViewerGUI
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
    % the data of the application, as an instance of MeshViewerAppData
    App;
    
    % remember where files were loaded
    LastPathOpen = '.';

    % remember where files were saved
    LastPathSave = '.';
end 

%% Constructor
methods
    function obj = MeshViewerGUI(appli, varargin)
        % MeshViewerGUI constructor
        %
        % GUI = MeshViewerGUI(APP)
        % where APP is an instance of MeshViewerAppData
        %
        
        if ~exist('appli', 'var')
            % create default empty app data container
            appli = mv.app.MeshViewerAppData();
        end
        obj.App = appli;
        
    end % constructor 

end % construction function


%% General methods
methods
    function frame = addNewMeshFrame(obj, varargin)
        % Create a new frame, eventually containing the specified mesh
        %
        % usage:
        %   frame = addNewMeshFrame(gui);
        %   frame = addNewMeshFrame(gui, mesh);
        
        % create mesh handle from input arguments
        mh = createMeshHandle(varargin{:});
        
        % creates a new scene containing the mesh
        scene = mv.app.Scene();
        if ~isempty(mh)
            scene.addMeshHandle(mh);
            updateBoundingBox(scene);
        end
        
        % creates the new frame
        frame = mv.gui.MeshViewerMainFrame(obj, scene);
        
        function mh = createMeshHandle(varargin)
            % Create a new mesh handle from a mesh.
            
            % special case of no mesh
            if isempty(varargin)
                mh = [];
                return;
            end
            
            % check mesh is already mesh handle
            mesh = varargin{1};
            if isa(mesh, 'mv.app.MeshHandle')
                mh = mesh;
                return;
            end
            
            if ~isa(mesh, 'mv.TriMesh')
                error('Requires either a MeshHandle or a TriMesh');
            end
            
            % Checks if mesh name was specified
            if length(varargin) < 2
                name = '[NoName]';
            else
                name = varargin{2};
            end
            
            % encapsulate the mesh into MeshHandle
            mh = mv.app.MeshHandle(mesh, name);
        end
    end
    
    function exit(obj) %#ok<MANU>
        % EXIT Close all viewers
           
%         docList = getDocuments(obj.app);
%         for d = 1:length(docList)
%             doc = docList{d};
%             
%             views = getViews(doc);
%             for v = 1:length(views)
%                 view = views{v};
%                 removeView(doc, view);
%                 close(view);
%             end
%         
%         end
    end
    
end % general methods

end % classdef
