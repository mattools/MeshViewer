function tests = test_faceProperties
% Test suite for face property management methods.
%
%   Test suite for the file getFaceProperties
%
%   Example
%   test_getFaceProperties
%
%   See also
%     getFaceProperties

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2025-02-24,    using Matlab 24.2.0.2712019 (R2024b)
% Copyright 2025 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_NumericArray(testCase) %#ok<*DEFNU>
% Test call of function without argument.

% generate test data
[v, f]= createOctahedron;
normals = meshFaceNormals(v, f);

% initialize mesh
mesh = mv.TriMesh(v, f);
setFaceProperties(mesh, 'normals', normals);

% retrieve a specific value
normal1 = getFaceProperty(mesh, 'normals', 1);
assertEqual(testCase, [1 3], size(normal1));

% update a specific value
newVal = [1 1 1];
setFaceProperty(mesh, 'normals', 1, newVal);
normal1b = getFaceProperty(mesh, 'normals', 1);
assertEqual(testCase, normal1b, newVal, 'AbsTol', 0.01);
