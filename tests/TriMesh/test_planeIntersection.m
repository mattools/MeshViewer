function tests = test_planeIntersection
% Test suite for the file planeIntersection.
%
%   Test suite for the file planeIntersection
%
%   Example
%   test_planeIntersection
%
%   See also
%     planeIntersection

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2024-02-02,    using Matlab 23.2.0.2459199 (R2023b) Update 5
% Copyright 2024 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_ClosedMesh(testCase) %#ok<*DEFNU>
% Test call of function without argument.

[v, f] = createOctahedron;
mesh = mv.TriMesh(v, f);
plane = [0 0 0.5   1 0 0  0 1 0];

[polys, closedFlags] = planeIntersection(mesh, plane);

assertEqual(testCase, length(polys), 1);
assertEqual(testCase, size(polys{1}, 1), 4);
assertEqual(testCase, length(closedFlags), 1);
assertTrue(testCase, closedFlags(1));



function test_OpenMesh(testCase) %#ok<*DEFNU>
% Test call of function without argument.

[v, f] = createOctahedron;
mesh = mv.TriMesh(v, f(1:7,:));
plane = [0 0 -0.5   1 0 0  0 1 0];

[polys, closedFlags] = planeIntersection(mesh, plane);

assertEqual(testCase, length(polys), 1);
assertEqual(testCase, size(polys{1}, 1), 4);
assertEqual(testCase, length(closedFlags), 1);
assertFalse(testCase, closedFlags(1));


