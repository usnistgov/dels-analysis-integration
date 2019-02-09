function [flip_list delta] = ...
	lk_search(base, costMat, T, nbs);
% [flip_list delta] = lk_search(base, costMat, T, nbs); 
% 
% lk_search attempts to find an improving Lin-Kernighan exchange,
% represented by sequences of flips, for a given starting tour
% T and base node base.  In this implemenation, no Mak-Morton flips are 
% considered and only the basic lk_step is used, not the alternate step.
%
% Input Values:
%     base 	 --  The base node from which the flip_list is built
%     costMat    --  Matrix of node-to-node travel costs c_{i,j}
%     T          --  Current tour in list-of-nodes format
%     nbs        --  A list of closest node neighbors to each node
%
% Return Values:    
%
%

% Number of nodes
n = size(costMat,1);

% The main Lin-Kernighan recursive call is lk_step

% Begin with an empty flip list, no net gain, and level=1 (2-exchange)
flip_list = [];
delta = 0;
level = 1;
[flip_list delta] = lk_step(flip_list, delta, base, costMat, T, nbs, level);

return;

