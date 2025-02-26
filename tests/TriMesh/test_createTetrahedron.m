function tests = test_createTetrahedron
% Test suite for the file createTetrahedron.
%
%   Test suite for the file createTetrahedron
%
%   Example
%   test_createTetrahedron
%
%   See also
%     createTetrahedron

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2025-02-26,    using Matlab 24.1.0.2653294 (R2024a) Update 5
% Copyright 2025 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

mesh = mv.TriMesh.createTetrahedron();

assertTrue(testCase, isa(mesh, 'mv.TriMesh'));
assertEqual(testCase, vertexCount(mesh), 4);
assertEqual(testCase, faceCount(mesh), 4);


