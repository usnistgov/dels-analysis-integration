function [d,p,pred] = dijkdemo(A,s,t)
%DIJKDEMO Dijkstra's algorithm to find shortest path from s to t in A.
%     *** Only for demo purposes; use DIJK for applications
%[d,p,pred] = dijkdemo(A,s,t)
%         A = N x N adjacency matrix
%         s = index of starting node
%         t = index of ending node
%
% (Based on Fig. 4.6 in Ahuja, Magnanti, and Orlin, Network Flows,
%  Prentice-Hall, 1993, p. 109.)
%
% Example (Fig. 4.7 in Ahuja):
% IJD = [
%      1     2     6
%      1     3     4
%      2     3     2
%      2     4     2
%      3     4     1
%      3     5     2
%      4     6     7
%      5     4     1
%      5     6     3];
% [d,p] = dijkdemo(list2adj(IJD),1,6)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
% End (Input Error Checking) **********************************************

A(A == 0) = Inf;
A(isnan(A)) = 0;
N = length(A);

S = []; nS = 1:N;
d = Inf*ones(1,N);
d(s) = 0; pred = zeros(1,N);

fprintf('\n'),fprintf('Node:'),fprintf(' %4d',1:N),fprintf('\n\n')

done = false;
while ~done
   [di,idx] = min(d(nS));
   i = nS(idx);
   
   S = [S i];
   nS(idx) = [];
   
   outputresults(idx2is(S,N),i,d,pred)
   
   pred(d > di + A(i,:)) = i;
   d = min(d,di + A(i,:));
   
   if i == t
       done = true;
   end
end

d = d(t);

p = t;
while t ~= s
   p = [pred(t) p];
   t = pred(t);
end


% ***************************************************************************
% ***************************************************************************
% ***************************************************************************
function outputresults(isS,i,d,pred)

fprintf('   S:'), fprintf(' %4d',isS(1:i)), fprintf('*')
if i < length(isS)
   fprintf('%4d',isS(i+1)),fprintf(' %4d',isS(i+2:end))
end
fprintf('\n')
fprintf('   d:'),fprintf(' %4d',round(d)),fprintf('\n')
fprintf('pred:'),fprintf(' %4d',pred),fprintf('\n\n')
