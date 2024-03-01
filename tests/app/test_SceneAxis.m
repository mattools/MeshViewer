function tests = test_SceneAxis
% Test suite for the file SceneAxis.
%
%   Test suite for the file SceneAxis
%
%   Example
%   test_SceneAxis
%
%   See also
%     SceneAxis

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2024-03-01,    using Matlab 23.2.0.2459199 (R2023b) Update 5
% Copyright 2024 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_constructor(testCase) %#ok<*DEFNU>
% Test call of function without argument.

axis = mv.app.SceneAxis();

assertTrue(testCase, isa(axis, 'mv.app.SceneAxis'));


function test_toFrom_struct(testCase) %#ok<*DEFNU>
% Test call of function without argument.

axis1 = mv.app.SceneAxis();
axis1.Label = 'MyAxis';
axis1.UnitName = 'pixel';

str = toStruct(axis1);
axis2 = mv.app.SceneAxis.fromStruct(str);

assertTrue(testCase, isa(axis2, 'mv.app.SceneAxis'));
assertEqual(testCase, axis2.Label, axis1.Label);
assertEqual(testCase, axis2.UnitName, axis1.UnitName);

