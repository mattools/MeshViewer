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
        
       % encapsualte the mesh into MeshHandle
       mh = mv.app.MeshHandle(mesh, '[NoName]');
       
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
