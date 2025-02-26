function tests = test_createCubeOctahedron
% Test suite for the file createCubeOctahedron.
%
%   Test suite for the file createCubeOctahedron
%
%   Example
%   test_createCubeOctahedron
%
%   See also
%     createCubeOctahedron

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2025-02-26,    using Matlab 24.1.0.2653294 (R2024a) Update 5
% Copyright 2025 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

mesh = mv.TriMesh.createCubeOctahedron();

assertTrue(testCase, isa(mesh, 'mv.TriMesh'));
assertEqual(testCase, vertexCount(mesh), 12);
assertEqual(testCase, faceCount(mesh), 20);

