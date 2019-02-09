function [T] = ...
        nearestNeighbor(costMat)
% [T] = nearestInsertion(costMat)
% 
% Performs the nearest neighbor heuristic to find the traveling salesman tour.
% This variation chooses the arc with minimum cost to begin the algorithm.
%
% Input Values:
%     costMat    --  Matrix of node-to-node travel costs c_{i,j}
%
% Return Values:    
%     T       --  New tour in list-of-nodes format  

% Variable declarations
%

% Find the number of nodes
nNodes = length(costMat);

% First let all of the diagonal elements of the cost matrix be NaN
newCost = costMat + diag( ones(nNodes,1)*NaN , 0 );

% Find the minimum value
minArc = min(min(newCost));
[i,j] = find(newCost==minArc);

% Initialize the tour
T = [i(1) j(1)];

% Put large values in the rows corresponding to nodes already on the tour
newCost(i(1),:) = ones(1,nNodes)*NaN;
newCost(j(1),:) = ones(1,nNodes)*NaN;

% Iteration counter
iter = 0;

% While the tour is not yet complete ...
while (length(T) < nNodes) ,
    iter = iter + 1;
    %disp(['Iteration: ', num2str(iter)]);
    
    % Find the closest node to the current tour endpoint
    closeNode = findClosest(T(length(T)), newCost);
    newCost(closeNode,:) = ones(1,nNodes)*NaN;

    % Append the node to the tour
    T = [T closeNode];
end;

T = [T T(1)];
%cost = tourLength(T, costMat);



return;
