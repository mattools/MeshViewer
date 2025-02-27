function tests = test_surfaceArea
% Test suite for the file surfaceArea.
%
%   Test suite for the file surfaceArea
%
%   Example
%   test_surfaceArea
%
%   See also
%     surfaceArea

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2025-02-25,    using Matlab 24.2.0.2712019 (R2024b)
% Copyright 2025 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_cube(testCase) %#ok<*DEFNU>
% Compute surface area of a unit cube


[v, f] = createCube;
mesh = mv.TriMesh(v, f);

surf = surfaceArea(mesh);

assertEqual(testCase, surf, 6 * 1.0);


