function mesh = createDodecahedron()
%CREATEDODECAHEDRON Create a 3D mesh representing a dodecahedron.
%
%   MESH = mv.TriMesh.createDodecahedron;
%   Create a 3D mesh representing a dodecahedron, composed of 20 vertices
%   and 36 faces (12 pentagons, each of them divided into three triangles).
%
%   Use values given by P. Bourke, see:
%   http://local.wasp.uwa.edu.au/~pbourke/geometry/platonic/
%   faces are re-oriented to have normals pointing outwards.
%
%
%   Example
%   mesh = mv.TriMesh.createDodecahedron;
%   figure; axis equal; hold on; draw(mesh); view(3);
%   
%   See also 
%   draw, createCube, createOctahedron
%
%

% ------
% Author: David Legland 
% E-mail: david.legland@inrae.fr
% Created: 2010-07-29
% Copyright 2010-2024 INRA - TPV URPOI - BIA IMASTE

% golden ratio
phi = (1+sqrt(5))/2;

% coordinates pre-computations
b = 1 / phi ; 
c = 2 - phi ;

% use values given by P. Bourke, see:
% http://local.wasp.uwa.edu.au/~pbourke/geometry/platonic/
tmp = [ ...
 c  0  1 ;   b  b  b ;   0  1  c  ; -b  b  b  ; -c  0  1 ;  ...
-c  0  1 ;  -b -b  b ;   0 -1  c  ;  b -b  b  ;  c  0  1 ;   ...
 c  0 -1 ;   b -b -b ;   0 -1 -c  ; -b -b -b  ; -c  0 -1 ;  ...
-c  0 -1 ;  -b  b -b ;   0  1 -c  ;  b  b -b  ;  c  0 -1 ; ...
 0  1 -c ;   0  1  c ;   b  b  b  ;  1  c  0  ;  b  b -b ; ...
 0  1  c ;   0  1 -c ;  -b  b -b  ; -1  c  0  ; -b  b  b ; ...
 0 -1 -c ;   0 -1  c ;  -b -b  b  ; -1 -c  0  ; -b -b -b ; ...
 0 -1  c ;   0 -1 -c ;   b -b -b  ;  1 -c  0  ;  b -b  b ; ...
 1  c  0 ;   b  b  b ;   c  0  1  ;  b -b  b  ;  1 -c  0 ;  ...
 1 -c  0 ;   b -b -b ;   c  0 -1  ;  b  b -b  ;  1  c  0 ; ...
-1  c  0 ;  -b  b -b ;  -c  0 -1  ; -b -b -b  ; -1 -c  0 ; ...
-1 -c  0 ;  -b -b  b ;  -c  0  1  ; -b  b  b  ; -1  c  0 ;  ...
];

% extract coordinates of unique vertices
[vertices, M, N] = unique(tmp, 'rows', 'first'); %#ok<ASGLU>

% compute indices of face vertices, put result in a 12-by-5 index array
ind0 = reshape((1:60), [5 12])';
faces = N(ind0);

mesh = mv.TriMesh(vertices, faces);
