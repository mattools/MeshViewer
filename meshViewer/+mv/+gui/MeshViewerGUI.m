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
    % application
    app;
    
    % remember where files were loaded
    lastPathOpen = '.';

    % remember where files were saved
    lastPathSave = '.';
end 

%% Constructor
methods
    function this = MeshViewerGUI(appli, varargin)
        % MeshViewerGUI constructor
        %
        % GUI = MeshViewerGUI(APP)
        % where APP is an instance of MeshViewerApp
        %
        
        this.app = appli;
        
    end % constructor 

end % construction function


%% General methods
methods
    function frame = addNewMeshFrame(this, mesh, varargin)
        % Create a new frame from the specified mesh
        
        % ensure second input argument is of class 'MeshHandle'
        if ~isa(mesh, 'mv.app.MeshHandle')
            if ~isa(mesh, 'TriMesh')
                error('Requires either a MeshHandle or a TriMesh');
            end
            
            % Checks if mesh name was specified
            if isempty(varargin)
                name = '[NoName]';
            else
                name = varargin{1};
            end
            
            % encapsulate the mesh into MeshHandle
            mh = mv.app.MeshHandle(mesh, name);
        end
        
        % creates a new scene contnaining the mesh
        scene = mv.app.Scene();
        scene.addMeshHandle(mh);
        
        % creates the new frame
        frame = mv.gui.MeshViewerMainFrame(this, scene);
    end
    
    function exit(this) %#ok<MANU>
        % EXIT Close all viewers
           
%         docList = getDocuments(this.app);
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
