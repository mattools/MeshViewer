function mesh = createSoccerBall()
%CREATESOCCERBALL Create a 3D mesh representing a soccer ball.
%
%   mesh = mv.TriMesh.createSoccerBall
%   Returns a new mesh composed of 60 vertices.
%   It is basically a wrapper of the 'bucky' function in Matlab.
%
%
%   Example
%   mesh = mv.TriMesh.createSoccerBall;
%   figure; axis equal; hold on; draw(mesh); view(3);
%   
%   See also 
%   draw, createCube, createOctahedron
%

% ------
% Author: David Legland
% E-mail: david.legland@inrae.fr
% Created: 2006-08-09
% Copyright 2006-2024 INRA - CEPIA Nantes - MIAJ (Jouy-en-Josas)

% get vertices and adjacency matrix of the buckyball
[vertices, n] = bucky;

% compute polygons that correspond to each 3D face
faces = minConvexHull(n)';

% format output
mesh = mv.TriMesh(vertices, faces);
