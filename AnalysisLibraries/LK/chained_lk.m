function [newT] = ...
        chained_lk(T, costMat, nNeighbors); 
% [newT] = chained_lk(T, costMat, nNeighbors)
% 
% chained_lk performs a basic chained Lin-Kernighan style search on a given
% starting tour.  This implementation does not include what
% are now standard Mak-Morton flips, nor the alternate first
% step often used.
%
% Input Values:
%     costMat    --  Matrix of node-to-node travel costs c_{i,j}
%     T          --  Current tour in list-of-nodes format
%     nNeighbors --  Number of closest node neighbors
%
% Return Values:    
%     newT       --  New tour in list-of-nodes format  

% Variable declarations and error checking
%
n = length(T)-1;
assert(size(costMat,1)==n,'Mismatch between tour indices and cost matrix size.');
assert(size(costMat,2)==n,'Mismatch between tour indices and cost matrix size.');
assert(nNeighbors <= n-1,'Neighbor lists must not exceed n-1 candidates.');

% Build neighbor lists
for i = 1:n ,
	[vals, I] = sort(costMat(i,:));
	nbs(i,:) = I(2:nNeighbors+1);
end;

% Add a loop for chaining together lk_search on perturbed new tours T
% For now, conduct only a single loop
    best_tour = T;
    best_tourlength = tourLength(T, costMat);
    nearness = 5;
    
    for k = 1:100
        
        if mod(k, 10) ==0
            nearness = randsample([1,2,3,4,5,7],1);
        end
        
        newT = RandomKick(T, nearness, 0.1, costMat);
        newT = lk(newT,costMat,nbs);
        newT_length = tourLength(newT, costMat);
        
        if  newT_length < best_tourlength
            best_tour = newT;
            best_tourlength = newT_length;
        end
        T = newT;
    end

    newT = best_tour;
return;

