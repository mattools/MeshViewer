function tests = test_createTruncatedOctahedron
% Test suite for the file createTruncatedOctahedron.
%
%   Test suite for the file createTruncatedOctahedron
%
%   Example
%   test_createTruncatedOctahedron
%
%   See also
%     createTruncatedOctahedron

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2025-02-26,    using Matlab 24.1.0.2653294 (R2024a) Update 5
% Copyright 2025 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument.

mesh = mv.TriMesh.createTruncatedOctahedron();

assertTrue(testCase, isa(mesh, 'mv.TriMesh'));
assertEqual(testCase, vertexCount(mesh), 24);
assertEqual(testCase, faceCount(mesh), 44);



