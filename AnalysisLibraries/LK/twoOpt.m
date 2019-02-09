function [newT] = ...
        twoOpt(T, costMat); 
% [newT] = twoOpt(T, costMat)
% 
% twoOpt performs a sequence of improving 2-exchanges 
%
% Input Values:
%     costMat    --  Matrix of node-to-node travel costs c_{i,j}
%     T          --  Current tour in list-of-nodes format
%
% Return Values:    
%     newT       --  New tour in list-of-nodes format  

% Variable declarations
%

% Dummy delta, to get started
delta = 1;
iterations = 0;

while delta > 0 ,
	% Continue two-exchanging
	[T delta] = two_exchange(T, costMat);
	iterations = iterations + 1;
end;

disp(['Number of improving iterations: ', num2str(iterations-1)]);
newT = T;

return;

