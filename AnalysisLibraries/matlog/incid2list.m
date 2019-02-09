function [i,j,c] = incid2list(I,c)
%INCID2LIST Node-arc incidence matrix to arc list representation.
%     IJC = incid2list(I,c)
% [i,j,c] = incid2list(I,c)
%     I = m x n node-arc incidence matrix
%     c = (optional) n-element vector of arc weights
%   IJC = n x 2-3 matrix arc list [i j c], where
%     i = n-element vector of arc tails nodes
%     j = n-element vector of arc head nodes
%
% Example:
% I = [1 -1  0
%     -1  0 -1
%      0  1  1]
% c = [1  3  2]
% IJC = incid2list(I,c)  % IJC = 1  2  1
%                        %       3  1  3
%                        %       3  2  2
%
% See also LIST2INCID

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,2)

if nargin < 2, c = []; else c = c(:); end

n = size(I,2);
arc = sum(I);  % arc(i) == 0 or 1 => directed or self-loop

if any(any(abs(I(I~=0)) ~= 1)) || any(arc~=0 & arc~=1) || ...
      any(sum(abs(I)) < 1 | sum(abs(I)) > 2)
   error('Invalid node-arc incidence matrix.')
elseif ~isempty(c) && length(c) ~= n
   error('"c" must be am n-element vector.')
end
% End (Input Error Checking) **********************************************

i = zeros(n,1); j = zeros(n,1);

[k,~] = find(I(:,arc==0) == 1);
i(arc==0) = k;
[k,~] = find(I(:,arc==0) == -1);
j(arc==0) = k;

[k,~] = find(I(:,arc==1) == 1);
i(arc==1) = k;
j(arc==1) = k;

if nargout == 1
   if isempty(c), i = [i j]; else i = [i j c]; end
end
