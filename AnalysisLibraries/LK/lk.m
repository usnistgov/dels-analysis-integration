function [newT] = ...
        lk(T, costMat, nbs); 
% [newT] = lk(T, costMat, nbs)
% 
% lk attempts to find improving Lin-Kernighan exchanges,
% represented by sequences of flips, for a given starting tour
% T.  In this implemenation, no Mak-Morton flips are considered
% and only the basic lk_step is used, not the alternate step.
%
% Input Values:
%     costMat    --  Matrix of node-to-node travel costs c_{i,j}
%     T          --  Current tour in list-of-nodes format
%     nbs        --  Matrix of closest node neighbors for each i
%
% Return Values:    
%     newT       --  New tour in list-of-nodes format  

% Variable declarations and error checking
%
n = length(T)-1;
nNeighbors = size(nbs,2);
assert(size(costMat,1)==n,'Mismatch between tour indices and cost matrix size.');
assert(size(costMat,2)==n,'Mismatch between tour indices and cost matrix size.');
assert(nNeighbors<=n-1,'Neighbor lists must not exceed n-1 candidates.');

% Initialize the new tour
newT = T;

% Proceed through the choices for base
% First, mark all of the nodes
marked_base = ones(n,1);
mark_orientation = 1;

while sum(marked_base) > 0 ,
	% Grab a marked node as base
	base = find(marked_base==1,1);

	% Find an improving exchange for base
	[flip_list delta] = lk_search(base, costMat, newT, nbs);

	% If an improving flip_list found, then execute
	if delta > 0 ,
		for j = 1:size(flip_list,1) ,
			% Execute the flip
			newT = flip(newT, flip_list(j,1), flip_list(j,2) );
			% Mark the flip vertices
			marked_base(flip_list(j,1))=1;
			marked_base(flip_list(j,2))=1;
		end;
	% Otherwise, try another vertex or orientation
	else
		% We can try the opposite orientation
		if mark_orientation == 1 ,
			mark_orientation = 0;
			newT = newT(n+1:-1:1);
			
		else
			mark_orientation = 1;
			marked_base(base) = 0;
		end;
	end;

end;

%T
%newT

%tourLength(T, costMat) - tourLength(newT, costMat)

return;

