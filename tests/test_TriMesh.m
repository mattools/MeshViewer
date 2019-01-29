function test_suite = test_TriMesh
%TEST_TRIMESH  Test case for the file TriMesh
%
%   Test case for the file TriMesh
%
%   Example
%   test_TriMesh
%
%   See also
%   TriMesh

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-01-29,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2019 INRA - Cepia Software Platform.

test_suite = buildFunctionHandleTestSuite(localfunctions);

function test_Creation(testCase) %#ok<*DEFNU>
% Test call of function without argument

[v, f] = createTetrahedron();
mesh = TriMesh(v, f);

assertTrue(isa(mesh, 'TriMesh'));

function test_StructureConversion(testCase) %#ok<*DEFNU>
% Test call of function without argument

[v, f] = createTetrahedron();
mesh = TriMesh(v, f);

str = toStruct(mesh);
mesh2 = TriMesh.fromStruct(str);

assertTrue(isa(mesh2, 'TriMesh'));
