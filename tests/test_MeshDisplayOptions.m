function test_suite = test_MeshDisplayOptions
%TEST_MESHDISPLAYOPTIONS  Test case for the file MeshDisplayOptions
%
%   Test case for the file MeshDisplayOptions
%
%   Example
%   test_MeshDisplayOptions
%
%   See also
%   MeshDisplayOptions

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-01-29,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2019 INRA - Cepia Software Platform.

test_suite = buildFunctionHandleTestSuite(localfunctions);

function test_Creation(testCase) %#ok<*DEFNU>
% Test call of function without argument

options = mv.app.MeshDisplayOptions();
assertTrue(isa(options, 'mv.app.MeshDisplayOptions'));

function test_StructureConversion(testCase) %#ok<*DEFNU>
% Test call of function without argument

options = mv.app.MeshDisplayOptions();

str = toStruct(options);
options2 = mv.app.MeshDisplayOptions.fromStruct(str);

assertTrue(isa(options2, 'mv.app.MeshDisplayOptions'));
