function [lp,TC,nf] = mcnf2lp(IJCUL,SCUL,x)
%MCNF2LP Convert minimum cost network flow to LP model.
% lp = mcnf2lp(IJCUL,SCUL)
% IJCUL = [i j c u l],  arc data
%  SCUL = [s nc nu nl], node data
%     i = n-element vector of arc tails nodes, where n = number of arcs
%     j = n-element vector of arc head nodes
%     c = n-element vector of arc costs
%     u = n-element vector of arc upper bounds
%       = [Inf], default
%     l = n-element vector of arc lower bounds
%       = [0], default
%     s = m-element vector of net node supply, where m = number of nodes
%            s(i) > 0 => node i is supply node        (outflow > inflow)
%            s(i) = 0 => node i is transshipment node (outflow = inflow)
%            s(i) < 0 => node i is demand node        (outflow < inflow)
%    nc = m-element vector of node costs
%    nu = m-element vector of upper bounds on total node flow
%       = [Inf], default
%    nl = m-element vector of lower bounds on total node flow
%       = [-Inf], default
%    lp = {c,Alt,blt,Aeq,beq,lb,ub}
%     c = vector of variable costs
%   Alt = inequality constraint matrix = [], for MCNF
%   blt = inequality RHS vector = [], for MCNF
%   Aeq = equality constraint matrix
%   beq = equality RHS vector
%    lb = lower bound vector
%    ub = upper bound vector
%
%Example:
% IJCUL = [
%   1   2   4  10   1
%   1   3   2   5   0
%   2   4   0 Inf   0
%   2   5   0 Inf   0
%   5   2   0 Inf   0
%   3   5   0 Inf   0
%   4   6   0 Inf   1
%   5   6   0 Inf   0];
% SCUL = [
%  10   4 Inf   0
%   0   2   5   2
%   0   3   4   2
%  -2   2 Inf   0
%   2   3 Inf   0
%  -4   1 Inf   0];
% lp = mcnf2lp(IJCUL,SCUL);
% [x,TClp] = lplog(lp{:}); TClp        % Use LPLOG to solve LP
% % TClp =                             % LP TC does not include demand 
% %     54                             % node costs
% [f,TC,nf] = lp2mcnf(x,IJCUL,SCUL)  % Convert to arc & node flows
% % f =
% %      2  2  3  0  1  2  1  3
% % TC =
% %     62
% % nf =
% %      4  3  2  3  4  4

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
cIJCUL = size(IJCUL,2);
if cIJCUL < 3 || cIJCUL > 5, error('IJCUL must be 3-5 column matrix.'), end
[I,c,u,l] = list2incid(IJCUL,1);
n = size(I,2);
if isempty(u), u = Inf*ones(n,1); end
if isempty(l), l = zeros(n,1); end
if nargin < 2 || isempty(SCUL)
   SCUL = zeros(max(max(abs(IJCUL(:,[1 2])),[],1)),1);
end
[m,cSCUL] = size(SCUL);
if m == 1, SCUL = SCUL'; m = cSCUL; cSCUL = 1; end
[s,nc,nu,nl] = mat2vec(SCUL);
if isempty(nc), nc = zeros(m,1); end
if isempty(nu), nu = Inf*ones(m,1); end
if isempty(nl), nl = zeros(m,1); end

if any(IJCUL(:,1)==IJCUL(:,2)) 
   error('All arcs must be directed without self-loops.')
elseif any(l > u) || any(l == Inf)
   error('Elements of "l" can not be greater than "u" or Inf.')
elseif size(I,1) ~= m
   error('Length of "s" must equal maximum node index in "i,j".')
elseif any(~isfinite(s))
   error('Elements of "s" must be finite.')
elseif sum(s(s >= 0)) < sum(s(s <= 0))
   error('Total supply cannot be less than total demand.')
elseif any(nl > nu)
   error('Elements of "nl" can not be greater than ''nu'' or Inf.')
end
% End (Input Error Checking) **********************************************

% Node costs
c = c + (nc'*(I==1))';  % Add node cost nc(i) to arc [i j] cost

% Node bounds
isnb = nu < Inf | nl ~= 0;

% Augment network by adding nodes for nonzero finite node bounds
if any(isnb)
   a = (I(isnb,:) == 1) + 0;
   I(isnb,:) = I(isnb,:) - a;
   I = [I zeros(m,sum(isnb))];
   I(isnb,n+1:end) = eye(sum(isnb));
   I = [I; a -eye(sum(isnb))];
   
   s2 = zeros(sum(isnb),1);
   s2(s(isnb) < 0) = s(isnb & s < 0);
   s(isnb & s < 0) = 0;
   s = [s; s2];
   
   c = [c; zeros(sum(isnb),1)];
   u = [u; nu(isnb)];
   l = [l; nl(isnb)];
end

% Add dummy demand node if excess supply
excess = sum(s(s >= 0)) + sum(s(s <= 0));
idxsup = find(s > 0);
idxdummy = [];
if excess > 0
   s = [s; -excess];
   idxdummy = length(s);
   [i,j] = incid2list(I);
   i = [i; idxsup];
   j = [j; idxdummy*ones(length(idxsup),1)];
   c = [c; zeros(length(idxsup),1)];
   u = [u; Inf*ones(length(idxsup),1)];
   l = [l; zeros(length(idxsup),1)];
   I = list2incid([i j],1);
end

% Run as MCNF2LP
if nargout < 2 && nargin < 3
   lp = {c,[],[],I(1:end-1,:),s(1:end-1),l,u};
   return
end

% Run as LP2MCNF
idx1 = find(IJCUL(:,2) < 0);
idx2 = (size(I,2)-length(idx1)+1:size(I,2))';

if nargin < 3 && nargout > 1
   error('Incorrect number of inputs and ouputs specified.')
elseif ~isvector(x) || length(x) ~= size(I,2)
   error('Length of input "x" incorrect.')
elseif length(idx1) ~= length(idx2)
   error('Incorrect arc list input.')
elseif ~isempty(idx1) && any(x(idx1)~=0 & x(idx2)~=0)
   error('Incorrect solution returned from solving lp.')
end

% Calc. node flows
nf = (I == 1)*x;
nf = nf(1:m);
if ~isempty(idxsup) && ~isempty(idxdummy)
   nf(idxsup) = nf(idxsup) - x(j == idxdummy);
end
s = s(1:m);
nf(s<0) = nf(s<0) - s(s<0);

x(idx1) = x(idx1) + x(idx2);  % Based on one value always being zero
lp = x(1:size(IJCUL,1));

TC = IJCUL(:,3)'*lp + nc'*nf;

   
