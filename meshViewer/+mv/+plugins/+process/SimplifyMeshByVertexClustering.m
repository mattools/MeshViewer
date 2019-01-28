classdef SimplifyMeshByVertexClustering < mv.gui.Plugin
%SIMPLIFYMESHBYVERTEXCLUSTERING  One-line description here, please.
%
%   Class SimplifyMeshByVertexClustering
%
%   Example
%   SimplifyMeshByVertexClustering
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-01-28,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = SimplifyMeshByVertexClustering(varargin)
    % Constructor for SimplifyMeshByVertexClustering class

    end

end % end constructors


%% Methods
methods
    function run(this, frame, src, evt) %#ok<INUSL>
        
        meshList =  selectedMeshHandleList(frame);
        if length(meshList) < 1
            return;
        end
       
        % choose variable
        gd = GenericDialog('Simplify by Vertex Clustering');
        addNumericField(gd, 'Grid Spacing: ', 1, 0);
      
        % display the dialog, and wait for user
        setSize(gd, [250 150]);
        showDialog(gd);
        % check if ok or cancel was clicked
        if wasCanceled(gd)
            return;
        end
        
        % parse user input
        spacing = getNextNumber(gd);

        
        for iMesh = 1:length(meshList)
            % get data for current mesh
            mh = meshList{iMesh};
            v = mh.mesh.vertices;
            f = mh.mesh.faces;
            
            if isstruct(f) || size(f, 2) > 3
                errordlg('Requires a triangular mesh', 'Subdivide Error');
                if iMesh > 1
                    updateDisplay(frame);
                end
                return;
            end
            
            % subdivides the mesh and replaces the original one
            [v, f] = meshVertexClustering(v, f, spacing);
            
            % update mesh
            mh.mesh.vertices = v;
            mh.mesh.faces = f;
        end
        
        updateDisplay(frame);
    end
end % end methods

end % end classdef

