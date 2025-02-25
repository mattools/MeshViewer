function tests = test_edgeProperties
% Test suite for the file edgeProperties.
%
%   Test suite for the file edgeProperties
%
%   Example
%   test_edgeProperties
%
%   See also
%     edgeProperties

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2025-02-25,    using Matlab 24.2.0.2712019 (R2024b)
% Copyright 2025 INRAE - BIA-BIBS.

tests = functiontests(localfunctions);


function test_NumericArray(testCase) %#ok<*DEFNU>
% Test call of function without argument.

% generate test data
[v, e, f]= createOctahedron;
edgeLengths = meshEdgeLength(v, e, f);

% initialize mesh
mesh = mv.TriMesh(v, f);
ensureValidEdges(mesh);
setEdgeProperties(mesh, 'length', edgeLengths);

% retrieve a specific value
len1 = getEdgeProperty(mesh, 'length', 1);
assertEqual(testCase, [1 1], size(len1));

% update a specific value
newVal = 3.5;
setEdgeProperty(mesh, 'length', 1, newVal);
len1b = getEdgeProperty(mesh, 'length', 1);
assertEqual(testCase, len1b, newVal, 'AbsTol', 0.01);
