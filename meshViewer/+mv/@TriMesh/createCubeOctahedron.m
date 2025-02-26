function mesh = createCubeOctahedron()
%CREATECUBEOCTAHEDRON Create a 3D mesh representing a cube-octahedron.
%
%   MESH = mv.TriMesh.createCubeOctahedron;
%   Cubeoctahedron can be seen either as a truncated cube, or as a
%   truncated octahedron.
%
%   Example
%   mesh = mv.TriMesh.createCubeOctahedron;
%   figure; axis equal; hold on; draw(mesh); view(3);
%   
%   See also 
%   draw, createCube, createOctahedron
%

% ------
% Author: David Legland 
% E-mail: david.legland@inrae.fr
% Created: 2005-02-10
% Copyright 2005-2024 INRA - TPV URPOI - BIA IMASTE

vertices = [...
    0 -1 1;1 0 1;0 1 1;-1 0 1; ...
    1 -1 0;1 1 0;-1 1 0;-1 -1 0;...
    0 -1 -1;1 0 -1;0 1 -1;-1 0 -1];

faces = {...
    [1 2 3 4], [1 5 2], [2 6 3], [3 7 4], [4 8 1], ...
    [5 10 6 2], [3 6 11 7], [4 7 12 8], [1 8 9 5], ...
    [5 9 10], [6 10 11], [7 11 12], [8 12 9], [9 12 11 10]};

mesh = mv.TriMesh(vertices, faces);
