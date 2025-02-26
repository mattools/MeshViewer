function tests = test_DisplayOptions
% Test suite for the file DisplayOptions.
%
%   Test suite for the file DisplayOptions
%
%   Example
%   test_DisplayOptions
%
%   See also
%     DisplayOptions

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2025-02-26,    using Matlab 24.1.0.2653294 (R2024a) Update 5
% Copyright 2025 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_constructor(testCase) %#ok<*DEFNU>
% Test call of function without argument.

options = mv.app.DisplayOptions();

assertTrue(testCase, isa(options, 'mv.app.DisplayOptions'));


function test_toFrom_struct(testCase) %#ok<*DEFNU>
% Test call of function without argument.

options1 = mv.app.DisplayOptions();
options1.LineColor = [0.5 0.7 3.0];
options1.LineWidth = 2.0;

str = toStruct(options1);
options2 = mv.app.DisplayOptions.fromStruct(str);

assertTrue(testCase, isa(options2, 'mv.app.DisplayOptions'));
assertEqual(testCase, options2.LineColor, options1.LineColor);
assertEqual(testCase, options2.LineWidth, options1.LineWidth);
assertEqual(testCase, options2.FillColor, options1.FillColor);
assertEqual(testCase, options2.FillOpacity, options1.FillOpacity);

