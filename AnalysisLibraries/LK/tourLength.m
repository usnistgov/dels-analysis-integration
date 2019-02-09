function [cost] = ...
        tourLength(T, costMat); 
% [length] = tourLength(T, costMat)
% 
% Computes the length of a tour T using cost matrix costMat
%
% Input Values:
%     T       --  Tour in list-of-nodes format  
%     costMat --  Matrix of node-to-node travel costs c_{i,j}
%
% Return Values:    
%     cost    --  length of tour  

% Variable declarations
%

% Find the number of nodes
nNodes = length(costMat);

% Add up the length
cost = 0;
i=1;

while (i < length(T))
    % Add the cost from i to i+1
    cost = cost + costMat(T(i),T(i+1));
    i=i+1;
end;

return;

