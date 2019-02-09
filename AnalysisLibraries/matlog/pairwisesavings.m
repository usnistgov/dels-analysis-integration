function [IJS,S,TCij,Rij] = pairwisesavings(rteTC_h,sh,TC1,doZero)
%PAIRWISESAVINGS Calculate pairwise savings.
% [IJS,S,TCij,Rij] = pairwisesavings(rteTC_h,sh,TC1,doNegSav)
% rteTC_h = handle to route total cost function, rteTC_h(rte)
%      sh = structure array with fields:
%          .b = beginning location of shipment
%          .e = ending location of shipment
%     TC1 = (optional) user-supplied independent shipment total cost
%         = rteTC_h([i i]) for shipment i, default
%  doZero = set negative savings values to zero
%         = true, default
%     IJS = savings list in nonincreasing order, where for row IJS(i,j,s)
%           s is savings associated with adding shipments i and j to route
%         = [], default, savings
%       S = savings matrix
%    TCij = pairwise total cost matrix
%     Rij = pairwise route cell array

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(2,4)
if nargin < 3, TC1 = []; end
if nargin < 4 || isempty(doZero), doZero = true; end

if ~isa(rteTC_h,'function_handle')
   error('First argument must be a handle to a route cost function.')
elseif ~isempty(TC1) && length(sh) ~= length(TC1(:))
   error('Independent shipment total cost must equal number of shipments.')
elseif ~isscalar(doZero) || ~islogical(doZero)
   error('"doZero" must be a logical scalar.')
end
% End (Input Error Checking) **********************************************

n = length(sh);
S = zeros(n);
TCij = zeros(n);
Rij = cell(n);
if isempty(TC1)
   for i = 1:n, TC1(i) = rteTC_h([i i]); end
end
for i = 1:n-1;
   for j = i+1:n
      [rij,tcij] = mincostinsert([i i],[j j],rteTC_h,sh);
      s = TC1(i) + TC1(j) - tcij;
      if ~doZero || s > 0
         S(i,j) = s;
         TCij(i,j) = tcij;
         Rij{i,j} = rij; Rij{j,i} = rij;
      end
   end
end

[i j s] = find(S); IJS = [i j s];
IJS = IJS(argsort(-s),:);
S = S + S';
TCij = TCij + TCij';
