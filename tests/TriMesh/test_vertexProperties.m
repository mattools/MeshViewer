function tests = test_vertexProperties
% Test suite for vertex property management methods.
%
%   Test suite for the file vertexProperties
%
%   Example
%   test_vertexProperties
%
%   See also
%     vertexProperties

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2025-02-25,    using Matlab 24.2.0.2712019 (R2024b)
% Copyright 2025 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_NumericArray(testCase) %#ok<*DEFNU>
% Test call of function without argument.

% generate test data
[v, f]= createOctahedron;
normals = meshVertexNormals(v, f);

% initialize mesh
mesh = mv.TriMesh(v, f);
setVertexProperties(mesh, 'normal', normals);

% retrieve a specific value
normal1 = getVertexProperty(mesh, 'normal', 1);
assertEqual(testCase, [1 3], size(normal1));

% update a specific value
newVal = [1 1 1];
setVertexProperty(mesh, 'normal', 1, newVal);
normal1b = getVertexProperty(mesh, 'normal', 1);
assertEqual(testCase, normal1b, newVal, 'AbsTol', 0.01);
