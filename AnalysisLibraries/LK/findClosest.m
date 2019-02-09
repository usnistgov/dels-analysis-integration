function [node] = ...
            findClosest(T, costMat);
% [node] = findClosest(T, costMat)
% 
% Finds the node closest to the current tour
%
% Input Values:
%     costMat    --  Matrix of node-to-node travel costs c_{i,j}
%     T          --  Current tour in list-of-nodes format
%
% Return Values:    
%     node       --  Node closest to the current tour  

% Variable declarations
%

% Only use the columns for nodes already in the tour
tempCost = costMat(:,T(1:length(T)));

% Additionally, do not consider arcs between nodes in the tour
% Create a fill of NaN
fillNaN = ones(length(T),size(tempCost,2))*NaN;
% Replace rows of the cost matrix with the fill matrix
tempCost(T,:) = fillNaN; 

% Find the smallest connected arc
minArc = min(min(tempCost));

% Find the row index of the node that is closest
[r,c] = find(tempCost==minArc);

% Assign the node
node = r(1);


return;
