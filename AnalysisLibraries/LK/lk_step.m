function [flip_list delta] = ... 
 lk_step(flip_list, delta, base, costMat, T, nbs, level);
% [flip_list delta] = lk_step(flip_list, delta, base, costMat, T, nbs, level);
%
% lk_step attempts to find a single flip as a component of a
% Lin-Kernighan search, building away from base.  The level
% of the search keeps track of the recursion; at a level 1,
% we are looking for the first flip (a 2-exchange), level 2
% we are looking for the second flip (a 3-exchange), ...
%
% This implementation does not consider Mak-Morton flips.
%
% Input Values:
%     costMat    --  Matrix of node-to-node travel costs c_{i,j}
%     T          --  Current tour in list-of-nodes format, prior flips applied
%
% Return Values:    
%

% Tour length
n = size(costMat,1);

% next(base) is the next node on the current tour initially
tnextbase = find(T(1:n)==base)+1;
nextbase = T(tnextbase);

% Search breadth values
if level == 1 ,
	breadth = 5;
elseif level == 2 ,
	breadth = 5;
else
	breadth = 1;
end;

% Counter for how many alternatives have been tried
i = 1;

% Build promising candidate lists of nodes for next(base)
% The first leaving arc is X1
cX1 = costMat(base,nextbase);
nNeighbors = size(nbs,2);
for ia = 1:nNeighbors ,
	% The entering arc candidate is (nextbase,a)
	a = nbs(nextbase,ia);
	% This choice of a is promising if delta + cX1 > cY1
	if (delta + cX1 - costMat(nextbase,a) > 0) ,
		% The node prior to a in the current tour is probe
		% The 'trick' here is that the index returned from find
		% within the range 2:n+1 is actually one less than the
		% index of a in the tour, and thus is the index (tprobe) 
		% of probe!
		tprobe = find(T(2:n+1)==a);
		probe = T(tprobe);
		promise(ia) = costMat(probe,a) - costMat(nextbase,a);
	else
		promise(ia) = -1;
	end;
end;
[promise I] = sort(promise,'descend');
promising = nbs(nextbase,I);

while (i <= breadth) && (promise(i) > 0) ,

	% Grab the next promising vertex
	a = promising(i);
	
	% Determine the previous node, probe
	tprobe = find(T(2:n+1)==a);
	probe = T(tprobe);
		
	% Compute the gain of the proposed added flip
	gain = costMat(base,nextbase) - costMat(nextbase,a) + costMat(probe,a) - costMat(probe,base);
		
	% Add flip(nb,probe) to the flip sequence
	flip_list = [flip_list; [nextbase probe]];
		
	% Flip the current tour, and recursively step again
	old_T = T;
	old_delta = delta;

	T = flip(T, nextbase, probe);
        [flip_list delta] = lk_step(flip_list, delta+gain, base, costMat, T, nbs, level+1);

	% If the flip_list yields an improvement, execute
	if delta > 0 , 
		return;

	% Otherwise, undo this last flip
	else
		% Unflip the tour
		T = old_T;
		delta = old_delta;

		% Remove flip from the flip_list
		num_flips = size(flip_list,1);
		flip_list = flip_list(1:num_flips-1,:);
			
		% Try the next alternative
		i = i + 1;
	end;		 		

end;

return;


