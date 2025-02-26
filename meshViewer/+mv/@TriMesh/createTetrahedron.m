function mesh = createTetrahedron()
%CREATETETRAHEDRON Create a 3D mesh representing a tetrahedron.
%
%   MESH = mv.TriMesh.createTetrahedron
%   create a simple tetrahedron, using mesh representation. The tetrahedron
%   is inscribed in the unit cube.
%
%
%   Example
%   mesh = mv.TriMesh.createTetrahedron;
%   figure; axis equal; hold on; draw(mesh); view(3);
%   
%   See also 
%   draw, createCube, createOctahedron
%

% ------
% Author: David Legland 
% E-mail: david.legland@inrae.fr
% Created: 2005-03-21
% Copyright 2005-2024 INRA - TPV URPOI - BIA IMASTE

x0 = 0; dx= 1;
y0 = 0; dy= 1;
z0 = 0; dz= 1;

vertices = [...
    x0 y0 z0; ...
    x0+dx y0+dy z0; ...
    x0+dx y0 z0+dz; ...
    x0 y0+dy z0+dz];

faces = [1 2 3;1 3 4;1 4 2;4 3 2];

% format output
mesh = mv.TriMesh(vertices, faces);
