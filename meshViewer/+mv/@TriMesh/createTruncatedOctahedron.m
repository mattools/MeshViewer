function mesh = createTruncatedOctahedron(varargin)
%CREATETRUNCATEDOCTAHEDRON Create a 3D mesh representing a truncated octahedron.
%
%   mesh = mv.TriMesh.createTruncatedOctahedron;
%   Create a triangular mesh from a truncated octahedron. Truncated
%   octahedron is composed of 14 faces and 24 vertices. Conversion to
%   triangular mesh increases the number of faces.
%
%   Example
%   createTruncatedOctahedron
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2025-02-26,    using Matlab 24.1.0.2653294 (R2024a) Update 5
% Copyright 2025 INRAE.

vertices = [...
    1 0 2;0 1 2;-1 0 2;0 -1 2;...
    2 0 1;0 2 1;-2 0 1;0 -2 1;...
    2 1 0;1 2 0;-1 2 0;-2 1 0;-2 -1 0;-1 -2 0;1 -2 0;2 -1 0;...
    2 0 -1;0 2 -1;-2 0 -1;0 -2 -1;...
    1 0 -2;0 1 -2;-1 0 -2;0 -1 -2];
    
faces = {...
    [1 2 3 4], ...
    [1 4 8 15 16 5], [1 5 9 10 6 2], [2 6 11 12 7 3], [3 7 13 14 8 4],...
    [5 16 17 9], [6 10 18 11], [7 12 19 13], [8 14 20 15],...
    [9 17 21 22 18 10], [11 18 22 23 19 12], [13 19 23 24 20 14], [15 20 24 21 17 16], ...
    [21 24 23 22]};
faces = faces';
    
% format output
mesh = mv.TriMesh(vertices, faces);
