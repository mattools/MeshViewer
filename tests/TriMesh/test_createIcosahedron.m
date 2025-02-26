function tests = test_createIcosahedron
% Test suite for the file createIcosahedron.
%
%   Test suite for the file createIcosahedron
%
%   Example
%   test_createIcosahedron
%
%   See also
%     createIcosahedron

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2025-02-26,    using Matlab 24.1.0.2653294 (R2024a) Update 5
% Copyright 2025 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

mesh = mv.TriMesh.createIcosahedron();

assertTrue(testCase, isa(mesh, 'mv.TriMesh'));
assertEqual(testCase, vertexCount(mesh), 12);
assertEqual(testCase, faceCount(mesh), 20);

