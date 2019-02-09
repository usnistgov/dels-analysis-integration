function [varargout] = adj2lev(A,m)
%ADJ2LEV Weighted adjacency to weighted interlevel matrix representation.
%            C = adj2lev(A,m)
%[C12,C23,...] = adj2lev(A,m)
%     A = SUM(m) x SUM(m) node-node wt. adjacency matrix of arc lengths
%       = (SUM(m) x t) x (SUM(m) x t) matrix, t > 1, if multiple periods
%     m = [m1 m2 m3 ...], vector of number of nodes at each level, where
%     C = {C12,C23,...}, cell array of weighted interlevel matrices
%   Cij = mi x mj matrix from level i to level j
%       = mi x mj x t matrix, t > 1, if multiple periods
%    mi = number of nodes in level i
%     t = number of periods
%
% Examples:
% A = [0 3 4
%      0 0 0
%      0 0 0]
% C = adj2lev(A,[1 2])            % (1 period   C = 3 4
%                                 %  2 levels)
%
% A = blkdiag(A,2*A)
% C = adj2lev(A,[1 2])            % (2 periods  C(:,:,1) = 3 4
%                                 %  2 levels)  C(:,:,2) = 6 8
% A = [0 3 4 0
%      0 0 0 5
%      0 0 0 6
%      0 0 0 0]
%
% [C12,C23] = adj2lev(A,[1 2 1])  % (1 period   C12 = 3 4
%                                 %  3 levels)  C23 = 5
%                                                     6
% See also LEV2ADJ

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
m = m(:);
if length(A) ~= size(A,2) || ~ismatrix(A)
   error('"A" must be a square matrix.')
elseif mod(length(A),sum(m)) ~= 0
   error('Length of "A" must be a multiple of SUM(m).')
elseif nargout ~= length(m) - 1
   error('Number of outputs must equal number of interlevel matrices.')
end
% End (Input Error Checking) **********************************************

C = cell(1,length(m) - 1);

for t = 1:length(A)/sum(m)
   tt = (t - 1)*sum(m) + 1;
   for i = 1:length(m) - 1
      Cit = full(A(tt + sum(m(1:i-1)):tt + sum(m(1:i)) - 1,...
                           tt + sum(m(1:i)):tt + sum(m(1:i+1)) - 1));
      Cit(isnan(Cit)) = 0;
      C{i}(:,:,t) = Cit;
   end
end

for i = 1:nargout, varargout(i) = C(i); end
