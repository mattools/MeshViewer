classdef TriMesh < handle
%TRIMESH Class for representing a triangular 3D mesh
%
%   output = TriMesh(input)
%
%   Example
%   TriMesh
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-05-03,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - Cepia Software Platform.

properties
    vertices;
    faces;
    
    edges = [];
    
    vertexFaces = {};
    vertexEdges = {};
    edgeFaces = [];
    faceEdges = [];
    
    faceNormals = [];
    edgeNormals = [];
    vertexNormals = [];
end

%% Constructor
methods
    function this = TriMesh(varargin)
        
        if isnumeric(varargin{1})
            this.vertices = varargin{1};
            this.faces = varargin{2};
            
        elseif isstruct(varargin{1})
            var1 = varargin{1};
            this.vertices = var1.vertices;
            this.faces = var1.faces;
        end
        
    end
end

%% General use methods
methods
    function nv = vertexNumber(this)
        nv = size(this.vertices);
    end
    
    function nf = faceNumber(this)
        nf = size(this.faces, 1);
    end
    
    function ne = edgeNumber(this)
        ne = size(this.edges, 1);
    end
end
end