function tests = test_SceneDisplayOptions
% Test suite for the file SceneDisplayOptions.
%
%   Test suite for the file SceneDisplayOptions
%
%   Example
%   test_SceneDisplayOptions
%
%   See also
%     SceneDisplayOptions

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2024-03-01,    using Matlab 23.2.0.2459199 (R2023b) Update 5
% Copyright 2024 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_constructor(testCase) %#ok<*DEFNU>
% Test call of function without argument.

options = mv.app.SceneDisplayOptions();

assertTrue(testCase, isa(options, 'mv.app.SceneDisplayOptions'));


function test_toFrom_struct(testCase) %#ok<*DEFNU>
% Test call of function without argument.

options1 = mv.app.SceneDisplayOptions();
options1.AxisLinesVisible = true;
options1.LightVisible = false;

str = toStruct(options1);
options2 = mv.app.SceneDisplayOptions.fromStruct(str);

assertTrue(testCase, isa(options2, 'mv.app.SceneDisplayOptions'));
assertEqual(testCase, options2.AxisLinesVisible, options1.AxisLinesVisible);
assertEqual(testCase, options2.LightVisible, options1.LightVisible);

