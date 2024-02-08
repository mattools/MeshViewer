function [polys, closedFlag] = planeIntersection(obj, plane, varargin)
% PLANEINTERSECTION Compute the 3D polylines resulting from plane intersection.
%
%   POLYS = planeIntersection(MESH, PLANE)
%   [POLYS, CLOSED] = planeIntersection(MESH, PLANE)
%   Computes the intersection between this mesh and a plane given by a
%   1-by-9 row array.
%   The output POLYS is a cell array of polylines, where each cell contains
%   a NV-by-3 numeric array of coordinates. The (optional) output CLOSED is
%   a logical array the same size as the POLYS, indicating whether the
%   corresponding polylines are closed (true), or open (false). Use the
%   functions 'drawPolygon3d' to display closed polylines, and
%   'drawPolyline3d' to display open polylines.
%
%   Example
%     ico = mv.TriMesh3D.createIcosahedron;
%     plane = mgt.geom3d.Plane3D([0 0 0.5], [1 0 0], [0 1 0]);
%     res = planeIntersection(ico, plane);
%
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% INRAE - BIA Research Unit - BIBS Platform (Nantes)
% Created: 2024-02-02,    using Matlab 23.2.0.2459199 (R2023b) Update 5
% Copyright 2024 INRAE.


%% Checkup

% ensure necessary data are computed
if isempty(obj.Edges) || isempty(obj.EdgeFaces) || isempty(obj.FaceEdges)
    computeEdgesAndFaces(obj);
end


%% Init

% identify which edges cross the mesh
inds = isBelowPlane(obj.Vertices, plane);
crossEdgeInds = find(sum(inds(obj.Edges), 2) == 1);
nCrossEdges = length(crossEdgeInds);

% compute one intersection point for each edge
segments = [obj.Vertices(obj.Edges(crossEdgeInds,1), :) obj.Vertices(obj.Edges(crossEdgeInds,2), :)];
intersectionPoints = intersectEdgePlane(segments, plane);

% create mapping from mesh edge indices to intersection indices
edgeIntersectionMap = containers.Map('keyType', 'int32', 'valueType', 'int32');
for iInter = 1:nCrossEdges
    edgeIntersectionMap(crossEdgeInds(iInter)) = iInter;
end

% initialize an array indicating which indices need to be processed
remainingCrossEdges = true(nCrossEdges, 1);


%% Iterate on edges and faces to form open poylines

% create empty cell array of open polylines
openPolys = {};

% identify crossing edges at extremity of open polylines
crossEdgeFaces = obj.EdgeFaces(crossEdgeInds,:);
extremityEdgeInds = find(sum(crossEdgeFaces == 0, 2) == 1);
remainingExtremities = true(length(extremityEdgeInds), 1);

% iterate while there are remaining extremity crossing edges
while any(remainingExtremities)
    % start from arbitrary remaining extremity
    extremityIndex = find(remainingExtremities, 1, 'first');
    remainingExtremities(extremityIndex) = false;

    % use extremity as current edge (index in nCrossEdge)
    startEdgeIndex = extremityEdgeInds(extremityIndex);
    currentEdgeIndex = startEdgeIndex;
    
    % mark current edge as processed
    remainingCrossEdges(currentEdgeIndex) = false;
    
    % initialize new set of edge indices (in cross edge array)
    polyEdgeInds = currentEdgeIndex;

    % find the unique face adjacent to current edge
    edgeFaces = crossEdgeFaces(currentEdgeIndex, :);
    currentFace = edgeFaces(1);

    % iterate along current face-edge couples until back to first edge
    while true
        % find indices of crossing edges within current face
        inds = obj.FaceEdges(currentFace, :);
        inds = inds(ismember(inds, crossEdgeInds));
        % find the index of next crossing edge
        currentEdgeIndex = edgeIntersectionMap(inds(inds ~= crossEdgeInds(currentEdgeIndex)));
        
        % add index of current edge
        polyEdgeInds = [polyEdgeInds currentEdgeIndex]; %#ok<AGROW>

        % mark current edge as processed
        remainingCrossEdges(currentEdgeIndex) = false;
    
        % find the index of the other face containing current edge
        inds = crossEdgeFaces(currentEdgeIndex, :);

        % check if we found an extremity edge
        if any(inds == 0)
            ind = extremityEdgeInds == currentEdgeIndex;
            remainingExtremities(ind) = false;
            break;
        end

        % switch to next face
        currentFace = inds(inds ~= currentFace);
    end
    
    % create polygon, and add it to list of polygons
    poly = intersectionPoints(polyEdgeInds, :);
    openPolys = [openPolys, {poly}]; %#ok<AGROW>
end


%% Iterate on edges and faces to form closed polylines

% create empty cell array of polygons
rings = {};

% iterate while there are some crossing edges to process
while any(remainingCrossEdges)
    % start at any edge, mark it as current
    startCrossEdgeIndex = find(remainingCrossEdges, 1, 'first');
    % mark current edge as processed
    remainingCrossEdges(startCrossEdgeIndex) = false;
    
    % initialize new set of edge indices
    polyCrossEdgeInds = startCrossEdgeIndex;
    
    % convert to mesh edge index
    startEdgeIndex = crossEdgeInds(startCrossEdgeIndex);
    currentEdgeIndex = startEdgeIndex;
    
    % choose one of the two faces around the edge
    currentFaceIndex = obj.EdgeFaces(currentEdgeIndex, 1);

    % iterate along current face-edge couples until back to first edge
    while true
        % find indices of crossing edges within current face
        inds = obj.FaceEdges(currentFaceIndex, :);
        inds = inds(ismember(inds, crossEdgeInds));

        % find the index of next crossing edge
        currentEdgeIndex = inds(inds ~= currentEdgeIndex);

        % mark current edge as processed
        currentCrossEdgeIndex = edgeIntersectionMap(currentEdgeIndex);
        remainingCrossEdges(currentCrossEdgeIndex) = false;
        
        % check end of current loop
        if currentEdgeIndex == startEdgeIndex
            break;
        end
        
        % find the index of the other face containing current edge
        inds = obj.EdgeFaces(currentEdgeIndex,:);
        currentFaceIndex = inds(inds ~= currentFaceIndex);
        
        % add index of current edge
        polyCrossEdgeInds = [polyCrossEdgeInds currentCrossEdgeIndex]; %#ok<AGROW>
    end
    
    % create polygon, and add it to list of polygons
    poly = intersectionPoints(polyCrossEdgeInds, :);
    rings = [rings, {poly}]; %#ok<AGROW>
end


%% Format output array
polys = [rings, openPolys];
closedFlag = [true(1, length(rings)), false(1, length(openPolys))];
