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

test_suite = functiontests(localfunctions);


function test_Creation(testCase) %#ok<*DEFNU>
% Test call of function without argument

[v, f] = createTetrahedron();
mesh = mv.TriMesh(v, f);

assertTrue(testCase, isa(mesh, 'mv.TriMesh'));


function test_StructureConversion(testCase) %#ok<*DEFNU>
% Test call of function without argument

[v, f] = createTetrahedron();
mesh = mv.TriMesh(v, f);

str = toStruct(mesh);
mesh2 = mv.TriMesh.fromStruct(str);

assertTrue(testCase, isa(mesh2, 'mv.TriMesh'));
