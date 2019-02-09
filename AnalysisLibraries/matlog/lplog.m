function [x,TC,XFlg,out] = lplog(c,Alt,blt,A,b,LB,UB,idxB0,varargin)
%LPLOG Matlog linear programming solver.
% [x,TC,XFlg,out] = lplog(c,Alt,blt,Aeq,beq,LB,UB,idxB0,opt) solves
%        
%  min TC = c'*x  s.t.  Alt*x <= blt, Aeq*beq == beq, LB <= x <= UB
%   x
%       c = n-element vector of variable costs
%     Alt = mlt x n inequality constraint matrix
%     blt = mlt-element RHS vector
%     Aeq = meq x n equality constraint matrix
%     beq = meq-element RHS vector
%      LB = n-element lower bound vector
%         = [0], default
%      UB = n-element upper bound vector
%         = [Inf], default
%   idxB0 = meq-element vector of initial basis indices
%           (problem must be in standard form: all Aeq, LB = 0, UB = Inf)
%         = [] (default) => Use Phase I to find initial basis
% Options:
%     opt = options structure, with fields:
%         .Display  =  2, show steps of evaluation
%                   =  1, warning messages (default)
%                   = -1, no warning messages
%         .Pivot    = method used to select pivot variable
%                   = 1, (default) Steepest edge
%                   = 2, Bland's Rule (prevents cycling)
%                   = 3, Dantzig's Rule
%         .Tol      = tolerance for variable at zero
%                   = 1e-8, default
%         .MaxCond  = maximum initial basis condition estimate
%                   = 1e8, default
%         .MaxIter  = maximum number of simplex iterations before switching
%                     to Bland's Rule ('Pivot' = 2)
%                   = n + 1, default
%         = 'Field1',value1,'Field2',value2, ..., where multiple input
%           arguments or single cell array can be used instead of the full
%           options structure to change only selected fields
%     opt = LPRSM('defaults'), to get defaults values for option structure
%    XFlg =  1, solution found
%         =  0, maximum number of iterations reached
%         = -1, initial basis is ill conditioned or infeasible
%         = -2, problem is infeasible
%         = -3, problem is unbounded
%         = -4, redundant row in constraints
%     out = output structure, with fields:
%         .idxB = final basis indices
%         .r    = reduced costs
%         .w    = dual variables
%         .iter = number of simplex iterations
%
% (Based on revised simplex method reported in Sec. 3.7 of S.C. Fang and 
%  S.Puthenpura, Linear Optimization and Extensions: Theory and Algorithms, 
%  Pretice-Hall: Englewood Cliffs, NJ, 1993.)
%
% (Jeffery A. Joines developed the initial version of the RSM subroutine
%  used in this procedure.)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if nargin == 9 && isstruct(varargin{:})     % Use opt only to check fields
   opt =struct('Display',[],'Pivot',[],'Tol',[],'MaxCond',[],'MaxIter',[]);
else                                       % Set defaults for opt structure
   opt = struct('Display',1,...
      'Pivot',1,...
      'Tol',1e-8,...
      'MaxCond',1e8,...
      'MaxIter',NaN);  % Can only determine 'n' inside RSM
   if nargin == 1 && strcmpi('defaults',c), x = opt; return, end
   narginchk(3,Inf)
end
if nargin > 8
   opt = optstructchk(opt,varargin);
   if ischar(opt), error(opt), end
end

% Using Alt, blt, A, and b in place of A, b, Aeq, and beq, respectively
c = c(:); c(isint(c,opt.Tol)) = round(c(isint(c,opt.Tol))); n = length(c);
blt = blt(:); mlt = length(blt);

if nargin < 4, A = []; end
if nargin < 5, b = []; else b = b(:); end
if nargin < 6 || isempty(LB), LB = zeros(n,1); else LB = LB(:); end
if nargin < 7 || isempty(UB), UB = Inf*ones(n,1); else UB = UB(:);end
if nargin < 8, idxB0 = []; else idxB0 = idxB0(:)'; end

meq = length(b);

if ~isempty(Alt) && any(size(Alt) ~= [mlt n])
   error('Dimensions of c and b not compatible with A.')
elseif ~isempty(A) && any(size(A) ~= [meq n])
   error('Dimensions of c and beq not compatible with Aeq.')
elseif length(LB) ~= n || any(LB == Inf)
   error('LB must be n-element vector < Inf.')
elseif length(UB) ~= n || any(UB == -Inf)
   error('UB must be n-element vector > -Inf.')
elseif any(LB > UB)
   error('All LB must be <= UB.')
elseif ~isempty(idxB0) && (~all(isint(idxB0)) || ...
      any(idxB0 < 1) || any(idxB0 > n) || length(unique(idxB0)) ~= meq)
   error('idxB0 must be meq-element vector of initial basis indices.')
% elseif 0%~isempty(idxB) & (mlt ~= 0 | any(LB ~= 0) | any(UB ~= Inf))
%    error('Problem must be in standard form to specify initial basis.')
elseif all(opt.Display ~= [2 1 -1])
   error('Invalid "opt.Display" specified.')
elseif all(opt.Pivot ~= [1 2 3])
   error('Invalid "opt.Pivot" specified.')
end
% End (Input Error Checking) **********************************************

% Initialize variables
[x,TC,XFlg,out] = deal([]);
[iter,mUB,mURS] = deal(0);
[XFlg,idxB,idxUB2LB,idxUB,idxLB,idxURSp,idxURSn] = deal([]);

% Make constraints sparse
Alt = sparse(Alt);
A = sparse(A);

% Convert UB to LB (LB == -Inf & UB < Inf to LB > -Inf & UB == Inf)
if ~isempty(UB) && ~isempty(LB) && any(LB == -Inf & UB < Inf)
   idxUB2LB = find(LB == -Inf & UB < Inf);
   LB(idxUB2LB) = -UB(idxUB2LB);
   UB(idxUB2LB) = Inf;
   c(idxUB2LB) = -c(idxUB2LB);
   if ~isempty(Alt), Alt(:,idxUB2LB) = -Alt(:,idxUB2LB); end
   if ~isempty(A), A(:,idxUB2LB) = -A(:,idxUB2LB); end
end

% Convert upper bounds (UB < Inf) to constraints
if ~isempty(UB) && any(UB < Inf)
   isUB = UB < Inf;  % Use isUB to save memory
   idxUB = find(isUB);
   mUB = length(idxUB);
   Alt = [Alt; speye(length(UB))];
   Alt(mlt+find(~isUB),:) = [];
%    Alt = [Alt; sparse(mUB,n)];
%    Alt(mlt+1:end,idxUB) = speye(mUB);  % Uses too much memory
   blt = [blt; UB(idxUB)];
end

% Add slack varibles to convert to standard form
if ~isempty(Alt)
   if ~isempty(A), A = [A sparse(meq,mlt+mUB)]; end
   A = [A; Alt speye(mlt+mUB)];
   b = [b; blt];
   c = [c; sparse(mlt+mUB,1)];
end
n_in = n;
n = n + mlt + mUB;
m = meq + mlt + mUB;

% Handle lower bounds: -Inf < LB ~= 0
if ~isempty(LB) && any(LB ~= 0 & LB > -Inf)
   idxLB = find(LB ~= 0);
   TC_LB = c(idxLB)'*LB(idxLB);
   b = b - A(:,idxLB)*LB(idxLB);
end

% Handle unrestricted in sign (URS) variables: LB == -Inf
if ~isempty(LB) && any(LB == -Inf)
   idxURSp = find(LB == -Inf);  % Positive URS
   mURS = length(idxURSp);
   A = [A -A(:,idxURSp)];
   c = [c; -c(idxURSp)];
   idxURSn = n+1:n+mURS;        % Negative URS
end
n_std = n;
n = n + mURS;

% Change sign of negative b elements
% A(find(b<0),:) = -A(find(b<0),:);
A(b<0,:) = -A(b<0,:);
b(b<0) = -b(b<0);

% Use slack variables in initial basis
idxB = [idxB0 n_in+1:n_std];

% Check feasibility of initial basis
if length(idxB) == m
   if condest(A(:,idxB)) > opt.MaxCond
      XFlg = -1;
      if opt.Display > 0, warning('Initial basis is ill conditioned.'), end
   else
      x0 = zeros(n,1);
      x0(idxB) = A(:,idxB)\b;
      if any(x0 < 0) || any(~is0(A*x0 - b,opt.Tol))
         XFlg = -1;
         if opt.Display > 0, warning('Initial basis is infeasible.'), end
      end
   end
end

% Initial basic feasible solution
if length(idxB) < m                 % Find a initial basis (Phase I)
   Aa = [A sparse(m,meq)];
   Aa(1:meq,n+1:n+meq) = speye(meq);  % Add artificial variables
   ca = [sparse(n,1); ones(meq,1)];
   x0 = [zeros(n_in,1); b(meq+1:m); b(1:meq)];
   idxBa = [idxB (n+1):(n+meq)];
   [x0,TC,XFlg,idxB,r,w,i] = rsm(ca,Aa,b,x0,idxBa,...
      opt.Display,opt.Pivot,opt.Tol,opt.MaxIter); 
   iter = iter + i;
   if	TC > opt.Tol
      XFlg = -2;
      if opt.Display > 0
         warning('Problem is infeasible.')
      end
   end
   idxBa = find(idxB > n);
   if ~isempty(idxBa)
      B = inv(Aa(:,idxB));
      idxNB = 1:n; idxB1 = idxB; idxB1(idxBa) = []; idxNB(idxB1) = [];
      for i = idxBa
         ek = zeros(1,m);
         ek(i) = 1;
         q = find(ek*B*A(:,idxNB)~=0);
         if isempty(q)
            XFlg = -4;
            if opt.Display > 0
               warning(['Row ',num2str(i),' is redundant'])
            end  
            break
         else
            idxB(i) = idxNB(q(1));
         end
      end
   end
end    % (End initial bfs)

% Exit on error
if XFlg < 0, return, end


% Revised simplex method (Phase II)
[x,TC,XFlg,idxB,r,w,i] = rsm(c,A,b,x0(1:n),idxB,...
   opt.Display,opt.Pivot,opt.Tol,opt.MaxIter);
iter = iter + i;


% Restore LB
if ~isempty(idxLB)
   TC = TC + TC_LB;
   x(idxLB) = LB(idxLB) + x(idxLB);
end

% Restore URS variable pairs
if ~isempty(idxURSp)
   x(idxURSp) = x(idxURSp) - x(idxURSn);
end

% Restore UB to LB
if ~isempty(idxUB2LB)
   x(idxUB2LB) = -x(idxUB2LB);
end

% Eliminate surplus variables
x = x(1:n_in);

% Creat output structure
if nargout > 3, out.idxB = idxB; out.r = r; out.w = w; out.iter = iter; end


% *************************************************************************
% *************************************************************************
% Revised simplex method **************************************************
function [x,TC,XFlg,idxB,r,w,i] = rsm(c,A,b,x,idxB,Disp,Pivot,Tol,MaxIter)

if isnan(MaxIter) || isempty(MaxIter), MaxIter = length(c) + 2; end
x0 = x; idxB0 = idxB;  % Save in case have to switch to Bland's Rule
XFlg = [];

B = A(:,idxB);
done = 0;
i = 0;
while ~done
   i = i + 1;
   
   if i >= MaxIter
      if Pivot ~= 2  % Switch to Bland's Rule due to cycling
         if Disp > 0
            warning(['Maximum number of iterations reached, ',...
               'switching to Bland''s Rule.']), end
         [x,TC,XFlg,idxB,r,w,i2] = ...
            rsm(c,A,b,x0,idxB0,Disp,2,Tol,MaxIter);
         i = i + i2;
         return
      else
         break
      end
   end
   
   idxNB = 1:length(c);
   idxNB(idxB) = [];
  
   % Step 1: B'w = c_b
   w = B'\c(idxB);
  
   % Step 2: r_j = c_j - w'A_j for all j not in B
   r = c(idxNB)' - w'*A(:,idxNB);
   
   % Step 3: Check for optimality: all r_j > 0
   q = find(r < -Tol);
   if isempty(q) 
      done = 1;
      break;
   end
   
   % Steps 4: Enter the basis (pivot) and Step 5: Edge direction
   if Pivot == 1        % Steepest Edge
      d = B\-A(:,idxNB(q));
      k = argmin(r(q)./sqrt(1 + sum(d.^2)));
      q = idxNB(q(k));
      d = d(:,k)';
   elseif Pivot == 2    % Bland's rule
      q = min(idxNB(q));
      d = (B\-A(:,q))';
   else                 % Dantzig's Rule
      q = idxNB(q(argmin(r(q))));
      d = (B\-A(:,q))';
   end
    
  	% Check for unbounded: all d >= 0
  	j = find(d < -Tol);
  	if isempty(j)
      if Disp > 0, warning('Problem is unbounded.'), end
      TC = Inf; 
   	XFlg = -2;
    	return;
  	end   
  
   alph = -x(idxB(j))./d(j)';
   
   % Bland's rule
 	[alpha] = min(alph);
  	p = find(alph==alpha, 1 );
  
   x(q) = alpha;
  	x(idxB) = x(idxB) + alpha*d';

  	p = j(p);
  	idxB(p) = q;
  
   B(:,p) = A(:,q);
end    % while

if done
   XFlg = 1;
else
   XFlg = 0;
end

TC = sum(c'*x);
r = r';

if Disp > 1, fprintf('%d %f\n',i,TC); end
