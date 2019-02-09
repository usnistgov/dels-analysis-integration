function [TC,dF] = sumcost(X,P,W,p,V,e,h)
%SUMCOST Determine total cost TC = W*DISTS(X,P,p) + V*DISTS(X,X,p).
% [TC,dF] = sumcost(X,P,W,p,V,e,h)
%       X = n x d matrix of n d-dimensional points
%       P = m x d matrix of m d-dimensional points
%       W = n x m matrix of X-P weights
%         = m-element vector of weights applied to each X(i,:), if V == []
%         = ones(1,m) (default), if V == []
%       p = distance parameter for DISTS
%       V = n x n matrix of X-X weights (all elements of V used in TC)
%         = [] (default)
%       e = epsilon parameter for DISTS
%       h = handle of axes to plot each X (see opt IterPlot in MINISUMLOC)
%      TC = scalar, if W is matrix
%         = n x 1 vector, if W is vector
%      dF = n x d gradient matrix
%
% Examples: 
% x = [1 1], P = [0 0;2 0;2 3], w = [1 2 1]
% TC = sumcost(x,P,w,1)     % TC = 9
% X = [1 1;2 1]
% TC = sumcost(X,P,w,2)     % TC = 9
%                                  7
% W = [0 2 1;3 2 0], V = [0 1;0 0]
% TC = sumcost(X,P,W,1,V)   % TC = 19

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
nd = size(X); n = nd(1); d = nd(2);   % In case X not 2-D matrix
m = size(P,1);

   if nargin < 3 || isempty(W), W = ones(1,m); end
   if nargin < 4 || isempty(p), p = 2; end
   if nargin < 5, V = []; end
   if nargin < 6 || isempty(e), e = 0; end
   if nargin < 7, h = []; end

if nargin < 6   % Only do error checking if e not input
   narginchk(2,7)
   
   % Use DISTS to error check X, P, and p
   try dists(X,P,p); catch error(lasterr), end
   
   if ~ismatrix(W), error('W must be 2-D matrix.'), 
   elseif ~ismatrix(V), error('V must be 2-D matrix.'), end
   
   if n == 1 || any(size(W) == [1 1])
      W = W(:)'; 
      if ~isreal(W) || length(W) ~= m
         error('W must be an m-element vector of real numbers');
      end
   else
      if ~isreal(W) || any(size(W) ~= [n m])
         error('W must be an n x m matrix of real numbers');
      elseif ~isempty(V) && (~isreal(V) || any(size(V) ~= [n n]))
         error('V must be an n x n matrix of real numbers');
      end
   end
   
   if ~isempty(h) && ~strcmp(get(h,'type'),'axes')
      error('Invalid handle "h" (not axes object).')
   end
end
% End (Input Error Checking) **********************************************

if isempty(V)
   if n == 1
      TC = sum(sum(W.*dists(X,P,p,e)));
   elseif size(W,1) == 1
      TC = sum(W(ones(1,n),:).*dists(X,P,p,e),2);
   else
      TC = sum(sum(W .* dists(X,P,p,e)));
   end
else
   TC = sum(sum(W.*dists(X,P,p,e))) + sum(sum(V.*dists(X,X,p,e)));
end
TC = full(TC);

% Determine gradient at X for lp distances (used in MINISUM)
if nargout > 1
   if isempty(V)				% Single new facility
      XP = X(ones(m,1),:) - P;
      dF = W.*dists(X,P,p,e).^(1 - p) * ((XP.^2 + e).^(p/2 - 1).*XP);
   else					% Mutiple new facilities
      [n,k] = size(X);
      dF = zeros(n,k);
      WD = W.*dists(X,P,p,e).^(1 - p);
      V = V + V.';				% Make V symmetric
      VD = V.*dists(X,X,p,e).^(1 - p);
      for i = 1:n
         XP = X(i*ones(m,1),:) - P;
         XX = X(i*ones(n,1),:) - X;
         dF(i,:) = WD(i,:) * ((XP.^2 + e).^(p/2 - 1).*XP) + ...
            VD(i,:) * ((XX.^2 + e).^(p/2 - 1).*XX);
      end
   end
end

% Plot X
if ~isempty(h)
   axes(h)
   pplot(X,'.','Color',[1 0 .5],'Tag','iterplot')
   pauseplot
   fprintf('%f\n',TC);
end
