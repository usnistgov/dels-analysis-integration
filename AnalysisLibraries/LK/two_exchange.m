function [newT delta] = ...
        two_exchange(T, costMat); 
% [newT delta] = two_exchange(T, costMat)
% 
% two_exchange searches for a a 2-opt exchange, and performs an improving exchange 
%
% Input Values:
%     costMat    --  Matrix of node-to-node travel costs c_{i,j}
%     T          --  Current tour in list-of-nodes format
%
% Return Values:    
%     newT       --  New tour in list-of-nodes format  
%     delta	 --  Tour improvement

% Variable declarations
%

delta = 0;
n = length(T)-1;

% Loop to determine the possible two-exchanges
for i = 1:(n-2) ,
    % Test for arc y_1 = (i,i+1) leaving...
    i_1 = T(i);
    i_2 = T(i+1);
    for j = i+2:n ,
        % Test for arc y_2 = (j,j+1) leaving...
        j_1 = T(j);
        j_2 = T(j+1);
        % Exchange will be ...
        delta = costMat(i_1,i_2) + costMat(j_1,j_2) - costMat(i_1,j_1) - costMat(i_2,j_2);
        if delta > 0 ,
            newT = [T(1:i) T(j:-1:i+1) T(j+1:length(T))];
            return;
        end;
    end;
end;

disp('No improving exchange found.')
newT = T;
return;

