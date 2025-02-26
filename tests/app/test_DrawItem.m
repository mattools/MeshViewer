function tests = test_DrawItem
% Test suite for the file DrawItem.
%
%   Test suite for the file DrawItem
%
%   Example
%   test_DrawItem
%
%   See also
%     DrawItem

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2025-02-26,    using Matlab 24.1.0.2653294 (R2024a) Update 5
% Copyright 2025 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);


function test_constructor_mesh(testCase) %#ok<*DEFNU>
% Test call of function without argument.

mesh = mv.TriMesh.createOctahedron;

item = mv.app.DrawItem('mesh01', 'Mesh', mesh);

assertTrue(testCase, isa(item, 'mv.app.DrawItem'));


function test_toFrom_struct(testCase) %#ok<*DEFNU>
% Test call of function without argument.

mesh = mv.TriMesh.createOctahedron;
item = mv.app.DrawItem('mesh01', 'Mesh', mesh);

str = toStruct(item);
item2 = mv.app.DrawItem.fromStruct(str);

assertTrue(testCase, isa(item2, 'mv.app.DrawItem'));

