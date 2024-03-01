function tests = test_MeshHandle
% Test suite for the file MeshHandle.
%
%   Test suite for the file MeshHandle
%
%   Example
%   test_MeshHandle
%
%   See also
%     MeshHandle

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2024-03-01,    using Matlab 23.2.0.2459199 (R2023b) Update 5
% Copyright 2024 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);

function test_constructor(testCase) %#ok<*DEFNU>
% Test call of function without argument.

[v, f] = createOctahedron;
mesh = mv.TriMesh(v, f);
mh = mv.app.MeshHandle(mesh, 'oct');

assertTrue(testCase, isa(mh, 'mv.app.MeshHandle'));


function test_toFrom_struct(testCase) %#ok<*DEFNU>
% Test call of function without argument.

[v, f] = createOctahedron;
mesh = mv.TriMesh(v, f);
mh = mv.app.MeshHandle(mesh, 'oct');

str = toStruct(mh);
mh2 = mv.app.MeshHandle.fromStruct(str);

assertTrue(testCase, isa(mh2, 'mv.app.MeshHandle'));

