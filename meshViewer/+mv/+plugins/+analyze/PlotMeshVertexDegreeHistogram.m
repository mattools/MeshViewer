classdef PlotMeshVertexDegreeHistogram < mv.gui.Plugin
% Apply a planar symmetry transform on the selected mesh(es)
%
%   Class PlotMeshVertexDegreeHistogram
%
%   Example
%   PlotMeshVertexDegreeHistogram
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-06-05,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = PlotMeshVertexDegreeHistogram(varargin)
    % Constructor for PlotMeshVertexDegreeHistogram class
    end
end % end constructors


%% Methods
methods
    function run(obj, frame, src, evt) %#ok<INUSL>
        
        meshList =  selectedMeshHandleList(frame);
        if length(meshList) ~= 1
            warning('Requires selection to contains only one mesh');
            return;
        end
        
        mh = meshList{1};
        mesh = mh.Mesh;
        
        % compute edges
        edges = meshEdges(mesh.Faces);
        
        % allocate memory for result
        nV = vertexNumber(mesh);
        deg = zeros(nV,1);

        % compute degree of each vertex
        for i = 1:nV
            deg(i) = sum(sum(edges == i, 2) > 0);
        end
        
        % compute discrete histogram by computing occurence of each unique
        % value 
        [B, I, J] = unique(deg); %#ok<ASGLU>
        N = hist(J, 1:max(J));

        % Display histogram
        figure; 
        bar(B, N);
        set(gca, 'xtick', B);
        xlabel('Vertex degree');
        ylabel('Frequency');
        title('Vertex Degree Histogram');
    end
    
end % end methods

end % end classdef

