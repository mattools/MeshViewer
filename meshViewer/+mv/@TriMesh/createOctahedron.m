function mesh = createOctahedron()
% Create a new mesh representing an octahedron.
%
%   MESH = mv.TriMesh.createOctahedron;
%   Create an octahedron, based on 6 vertices and 8 triangular faces.
%
%   Example
%   mesh = mv.TriMesh.createOctahedron;
%   figure; axis equal; hold on; draw(mesh); view(3);
%   
%   See also 
%   draw, createCube, createIcosahedron
%

vertices = [1 0 0;0 1 0;-1 0 0;0 -1 0;0 0 1;0 0 -1];
edges = [1 2;1 4;1 5; 1 6;2 3;2 5;2 6;3 4;3 5;3 6;4 5;4 6];
faces = [1 2 5;2 3 5;3 4 5;4 1 5;1 6 2;2 6 3;3 6 4;1 4 6];

mesh = mv.TriMesh(vertices, faces);
mesh.Edges = edges;
