function [Xout,TC,W] = ala(X,w,P,p,loc_h)
%ALA Alternate location-allocation procedure.
%[X,TC,W] = ala(X0,w,P,p)           % Use default allocate and locate
%         = ala(X0,alloc_h,P,p)     % Use MINISUMLOC(P,W,p) to locate NFs
%         = ala(X0,w,P,p,loc_h)     % Use MIN(DISTS(X,P,p)) to allocate NFs
%         = ala(X0,alloc_h,loc_h)   % User-defined allocate and locate
%      X0 = n-row matrix of n new facility (NF) starting locations
%           (use X0 = randX(P,n) to generate n random locations)
%       P = m-row matrix of m existing facility (EF) locations
%       w = m-element vector of weights
%       p = parameter for DISTS (default 'mi')
% alloc_h = handle to anonymous function to allocate NFs
%         = @(X) myalloc(...,X,...), where MYALLOC must return W and TC
%           [W,TC] = myalloc(...,X,...)
%   loc_h = handle to anonymous function to locate NFs
%         = @(W) myloc(...,W,...), where MYLOC must return X
%           X = myloc(...,W,...)
%       X = n-row matrix of n NF locations
%      TC = total cost of allocation
%       W = n x m matrix of weights, where W(i,j) represents the weight
%           allocated to/from NF(i) from EF(j)
%
% Run PPLOT(P,'r.') or MAKEMAP(P) before running ALA, if you want to plot
%     intermediate results, and use "Set Pauseplot Time" on the "Matlog"
%     menu in the figure to to adjust the frequency.
% Run ALAPLOT(X,W,P) to plot only the final results.
%
% %Example 1: Locate three NFs to serve customers in North Carolina cities
% [P,w] = nccity('XY','Pop'); p = 'mi';
% makemap(P), pplot(P,'r.')
% ala(randX(P,3),w,P,p)
%
% %Example 2: Take the best of 'nruns' runs of ALA
% nruns = 5; TC = Inf;
% for i=1:nruns, [X1,TC1,W1] = ala(randX(P,3),w,P,p); ...
% fprintf('%d %e\n',i,TC1); if TC1 < TC, TC=TC1; X=X1; W=W1; end, end
%
% %Example 3: Constrained NFs (each NF can handle a third of total demand)
% alloc_h = @(XY) trans(dists(XY,P,p),ones(1,3)*sum(w)/3,w);
% [XYc,TCc,Wc] = ala(randX(P,3),alloc_h,P,p);  % Constrained NFs
% TCc, pctdemC = full(sum(Wc,2))/sum(w)  % Percentage of total demand
%
% %Example 4: Compare constrained to unconstrained NFs 
% [XYu,TCu,Wu] = ala(XYc,w,P,p);
% TCu, pctdemU = full(sum(Wu,2))/sum(w)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(3,5)

alloc_h = [];
if nargin < 5, loc_h = []; end
if nargin < 4 || isempty(p), p = 'mi'; end
if isa(P,'function_handle'), loc_h = P; P = []; end
if isa(w,'function_handle'), alloc_h = w; w = []; else w = w(:)'; end 

if ~isempty(P) && (size(P,2) ~= size(X,2))
   error('Rows in P must equal length of rows in X0.')
elseif ~isempty(P) && ~isempty(w) && (size(P,1) ~= length(w))
   error('Rows in P must equal length of "w".')
end

if isempty(alloc_h), alloc_h = @(X) default_alloc(X,w,P,p); end
if isempty(loc_h), loc_h = @(W) minisumloc(P,W,p); end
% End (Input Error Checking) **********************************************

if ~isempty(P), alaplot(X,[],P,'Locate'); end

TC = Inf;
i = 0;
done = 0;
while ~done
   
   [W1,TC1] = alloc_h(X);
   TC1 = full(TC1);
   if size(W1,1) ~= size(X,1)
      error('No. rows in W returned by alloc_h and X not equal.')
   elseif length(TC1(:)) ~= 1
      error('TC returned by alloc_h must be a scalar.')
   end
   if ~isempty(P), alaplot(X,W1,P,'Allocate'); end
   
   X1 = loc_h(W1);
   
   if TC > TC1
      TC = TC1; X = X1; W = W1;
      
      i = i + 1;
      if nargout < 1, fprintf('%d %f\n',i,TC); end
      if ~isempty(P), alaplot(X,W,P,'Locate'); end
   else
      done = 1;
   end
end

if nargout < 1
   fprintf('\n');
   X
else
   Xout = X;
end


% *************************************************************************
% *************************************************************************
% *************************************************************************
function [W,TC] = default_alloc(X,w,P,p)
%DEFAULT_ALLOC Default Allocation Function

D = dists(X,P,p);
W = sparse(argmin(D,1),1:length(w),w,size(X,1),length(w));
TC = sum(sum(W.*D));
