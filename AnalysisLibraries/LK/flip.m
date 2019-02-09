function [newT] = ...
        flip(T, a, b); 
% [newT] = flip(T, a, b)
% 
% flip is a flipper function for a tour, which simply inverts
% the sequence of visit indices from a to b as follows
%

n = length(T)-1;

% Find indices
ia = find(T(1:n)==a);
ib = find(T(1:n)==b);

% Error checking
assert(ia>=1, 'Input value a must be not less than index position 1.');
assert(ia<=n, 'Input value a must not exceed the number of nodes.' );
assert(ib>=1, 'Input value b must be not less than index position 1.');
assert(ib<=n, 'Input value b must not exceed the number of nodes.');
assert(ia~=ib, 'Input value a must not equal b.');

% Flipping
% Walk from b to a, backwards
% Then to b+1, and forward to a-1
% Then back to b
i=1;
j=ib;
direction = -1;

while i <= n ,
	
	% Assign 
	newT(i) = T(j);

	% If we are moving backwards b to a ...
	if (direction == -1) ,
		% If we have reached a, jump next to next(b) and move forward
		if (j == ia)
			if (ib == n)
				j = 1;
			else
				j = ib+1;
			end;
			direction = 1;
		% If we have reached the first node in the tour
		elseif (j == 1)
			j = n;
		else
			j = j + direction;
		end;
	
	% Otherwise we are moving forward from b+1
	else
		% If we have reached the last node in the tour
		if (j == n) ,
			j = 1;
		else
			j = j + direction;
		end;
	end;

	i = i + 1;
end;

% Finish the tour back at b
newT(n+1)=b;

return;

