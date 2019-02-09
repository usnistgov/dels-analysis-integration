function [x,TC,nevals,XFlg] = milplog(mp,varargin)
%MILPLOG Matlog mixed-integer linear programming solver.
% [x,TC,nevals,XFlg] = milplog(mp,opt)
%      mp = model object returned by MILP
% Options:
%     opt = options structure, with fields:
%         .Display  =-1, no warning messages
%                   = 0, initial LP message (default)
%                   = 1, show steps of B&B evalutation
%                   = 2, also show TolFun changes
%         .Martin   = 0, don't use Martin cuts
%                   = 1, use Martin cuts if possible (default)
%         .SOS      = Special Ordered Sets of type one (SOS1)
%                   = 0, don't use (default)
%                   = 1, use if possible (and don't use Martin cuts)
%         .RCthresh = reduced cost threshold percent of obj for Martin cuts
%                   = 0.05 (default)
%         .TolInt   = integer tolerance for ISINT
%                   = [1e-8], default
%         .ExTolFun = opt.LPopt.TolFun expansion factor for LINPROG feas.
%                   = 10 (default)
%         .LPopt    = option structure for LINPROG, with MILP default:
%                   .Display = 'none'
%         = 'Field1',value1,'Field2',value2, ..., where multiple input
%           arguments or single cell array can be used instead of the full
%           options structure to change only selected fields
%     opt = MILPLOG('defaults'), get defaults values for option structure
%  nevals = number of LP evaluations
%    XFlg = 2, initial LP solution feasible
%         = 1, solution found
%         =-1, no feasible integer solution found
%         =-2, initial LINPROG exitflag <= 0
%
% Example (Example 8.8 in Francis, Fac Layout and Loc, 2nd ed.):
% k = [8     8    10     8     9     8];
% C = [0     3     7    10     6     4
%      3     0     4     7     6     7
%      7     4     0     3     6     8
%     10     7     3     0     7     8
%      6     6     6     7     0     2
%      4     7     8     8     2     0];
% mp = Milp('UFL');
% mp.addobj('min',k,C)
% [n m] = size(C);
% for j = 1:m
%    mp.addcstr(0,{':',j},'=',1)
% end
% for i = 1:n
%    mp.addcstr({m,{i}},'>=',{i,':'})  % Weak formulation
% end
% mp.addub(Inf,1)
% mp.addctype('B','C')
% [x,TC,nevals,XFlg] = milplog(mp); TC,nevals,XFlg
% x = mp.namesolution(x), xC = x.C
% TC = k*x.k' + sum(sum(C.*xC))

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if nargin == 2 && isstruct(varargin{:})     % Use opt only to check fields
   opt = struct('Display',[],'Martin',[],'SOS',[],...
      'RCthresh',[],'TolInt',[],'ExTolFun',[],'LPopt',[]);
else                                       % Set defaults for opt structure
   opt = struct('Display',0,...
      'Martin',1,...
      'SOS',0,...
      'RCthresh',0.05,...
      'TolInt',1e-8,...  %0.01*sqrt(eps),...
      'ExTolFun',10,...
      'LPopt',[]);
   if exist('linprog','file') == 2
      opt.LPopt = optimset(linprog('defaults'),'Display','none');
   end
   if nargin == 1 && strcmpi('defaults',mp), x = opt; return, end
   narginchk(1,Inf)
end
if nargin > 1
   opt = optstructchk(opt,varargin);
   if ischar(opt), error(opt), end
end

if ~isa(mp,'Milp')
   error('First input not a Milp object.')
end
if length(mp.Model.ctype) ~= ...
      length(regexp(mp.Model.ctype,'[BIC]'))
   error('Characters in Milp ctype must be belong to B, I, or C')
end

if exist('linprog','file') ~= 2
   error('Function LINPROG not found.')
elseif length(opt.Display(:)) ~= 1 || ~any(opt.Display == [-1 0 1 2])
   error('Invalid "opt.Display" specified.')
elseif length(opt.Martin(:)) ~= 1 || ~any(opt.Martin == [0 1])
   error('Invalid "opt.Martin" specified.')
elseif length(opt.SOS(:)) ~= 1 || ~any(opt.SOS == [0 1])
   error('Invalid "opt.SOS" specified.')
elseif length(opt.ExTolFun(:)) ~= 1
   error('Invalid "opt.ExTolFun" specified.')
end
% End (Input Error Checking) **********************************************

mp = mp.Model;

vlb = mp.lb; vlb(mp.ctype == 'B') = 0;
vub = mp.ub; vub(mp.ctype == 'B') = 1;
if strcmp(mp.sense,'minimize'), isMin = true; else isMin = false; end
isR = mp.ctype == 'C';
c = [mp.obj(~isR) mp.obj(isR)];
A = [mp.A(:,~isR) mp.A(:,isR)];
vlb = [vlb(~isR) vlb(isR)];
vub = [vub(~isR) vub(isR)];
R = sum(isR);
isGt = isinf(mp.rhs);
A(isGt,:) = -A(isGt,:);
b = mp.rhs;
b(isGt) = -mp.lhs(isGt);
isEq = mp.lhs == mp.rhs;
A = [A(isEq,:); A(~isEq,:)];
b = [b(isEq); b(~isEq)];
N = sum(isEq);

[x2,TC,nevals,XFlg] = milp(c,A,b,vlb,vub,N,R,isMin,opt);
x = x2;
x(~isR) = x2(1:sum(~isR));
x(isR) = x2(length(x2)-R+1:end);

function [x,TC,nevals,XFlg] = milp(c,A,b,vlb,vub,N,R,isMin,opt)

n = length(c);
m = length(b);

% If maximization
if ~isMin, c = -c; end

% Convert options to use Martin and SOS1
useMartin = 0; useSOS1 = 0;
if opt.Martin == 1, useMartin = 1; end
if opt.SOS == 1, useSOS1 = 1; end
if useSOS1 == 1 && useMartin == 1, useMartin = 0; end  % No Martin if SOS

% Initial LP solution
[x,~,how,~,lmb] = linprog(...
   c,A(N+1:end,:),b(N+1:end),A(1:N,:),b(1:N),vlb,vub,[],opt.LPopt);
nevals = 1;

% Case 1: No integer variables
if n == R
   TC = c*x;
   XFlg = 2;
   return;
end

% Case 2: Integer variables
if how > 0
   I = n - R;
   x(isint(x,opt.TolInt)) = round(x(isint(x,opt.TolInt)));
   %    x = x(1:I);
end

% Case 2a: LP solution not OK
if how <= 0
   TC = [];
   XFlg = -2;
   return;
   % Case 2b: Initial LP solution feasible
elseif all(isint(x,opt.TolInt))
   TC = c*x;
   if opt.Display > 0
      disp('Initial LP solution feasible.');
   end
   XFlg = 2;
   return;
end

% Case 2c: Initial LP solution not feasible
TC = iff(isMin,Inf,-Inf);
TC0 = c*x;
x0 = x;
chow = how;

vlbR = vlb(I+1:n);vlbI = vlb(1:I);
vubR = vub(I+1:n);vubI = vub(1:I);

% Check if SOS1 possible for binary variables
if useSOS1 && any(vlbI == 0 & vubI == 1) && any(b(1:N) == 1)
   varB = vlbI == 0 & vubI == 1;
   cstr = 1:N;cstr = cstr(b(cstr) == 1);
   cstr = cstr(all(A(cstr,1:I)' == 0 | A(cstr,1:I)' == 1));
   if R > 1
      cstr = cstr(all(A(cstr,I+1:n)' == 0));
   elseif R == 1
      cstr = cstr(A(cstr,I+1:n)' == 0);
   end
   idSOS1 = 0;
   SOS1 = zeros(1,I);
   for i = 1:length(cstr)
      nSOS1 = sum(A(cstr(i),1:I) & varB);
      if nSOS1 > 2			% SOS1 <= 2 same as reg. B&B
         idSOS1 = idSOS1 + 1;
         SOS1(A(cstr(i),1:I) & varB) = idSOS1*ones(1,nSOS1);
      end
   end
   if all(SOS1 == 0)
      useSOS1 = 0;
   end
else
   useSOS1 = 0;
end

if opt.Display > 0
   fprintf('\nNODE PRNT   OBJ       BND       VAR\n');
   fprintf('%4d      %10.4f\n',0,TC0);
end

% Fix variables via Martin cuts
fix = 0;				% fix = 1 => 1st Martin cut
release = 0;				% release = 1 => 2nd Martin cut
ixnofix = 1:n;
if useMartin
   % [x(1:I) lmb(m+1:m+I) lmb(m+I+1:m+2*I)]
   RCthresh = opt.RCthresh * abs(TC0);	 % Reduced cost > RCthresh % of obj
   ixfix = find(x(1:I) == 0 & lmb.lower(1:I) > RCthresh);
   nfix = length(ixfix);
   if nfix
      ixnofix(ixfix) = [];
      fix = 1;
      TC_init = TC0;
      c_init = c;c(ixfix) = [];
      A_init = A;A(:,ixfix) = [];
      vlbI_init = vlbI;vlbI(ixfix) = [];
      vubI_init = vubI;vubI(ixfix) = [];
      I = I - nfix;
      x(ixfix) = [];x0(ixfix) = [];
      if opt.Display > 0
         fprintf('Fixing');fprintf(' %d',ixfix);
         fprintf(' with RC > %.4f\n',RCthresh);
      end
      if useSOS1
         SOS1_init = SOS1;SOS1(ixfix) = [];
         if ~any(SOS1)
            useSOS1 = -1;
         end
      end
   end
end

% Initialize B&B tree "T"
T = [TC0 vlbI vubI 0 NaN 0];		% ... 0 NaN 0] => ... prnt ixx bndx]
if useSOS1 > 0
   T = [T SOS1];
end

% Main B&B tree loop
while ~isempty(T) || fix
   
   % Release fixed variables (2nd Martin cut) after solved for 1st Martin cut
   if isempty(T) && fix
      fix = 0;release = 1;
      T = [TC_init vlbI_init vubI_init 0 NaN 0];
      if useSOS1 ~= 0;
         T = [T SOS1_init];
         useSOS1 = 1;
      end
      Arelease = zeros(1,n);Arelease(ixfix) = -ones(1,nfix);
      A = [A_init;Arelease];b = [b;-1];
      c = c_init;I = I + nfix;
      xynofix = x;x = zeros(n,1);x(ixnofix) = xynofix;
      ixnofix = 1:n;
      if opt.Display > 0
         fprintf('Releasing fixed variables\n');
      end
   end
   
   % Node selection
   [~,ixT] = min(T(:,1));		% Selection a.k.a. "jumptracking"
   
   % Get selected node info and then remove from B&B tree
   cvlbI = T(ixT,2:I+1);
   cvubI = T(ixT,I+2:2*I+1);
   prnt = T(ixT,2*I+2);			% Parent of current node
   ixx = T(ixT,2*I+3);		        % Index of branching var, where
   %    ixx == NaN => initial root node
   %               or releasing fix var
   %    ixx < 0 => LB, ixx > 0 => UB
   %    ixx == 0 => using SOS1 var
   bndx = T(ixT,2*I+4);			% LB or UB of ixx
   if useSOS1 > 0
      SOS1 = T(ixT,2*I+5:3*I+4);
      if ixx == 0
         ixSOS1 = find(SOS1 == -1);	% For display, current SOS1 var = -1
         SOS1(ixSOS1) = zeros(1,length(ixSOS1));
      end
   end
   T(ixT,:) = [];
   
   % Solve LP relaxation
   if ~isnan(ixx) || release		% Not initial root node
      [x0,~,chow] = linprog(...
         c,A(N+1:end,:),b(N+1:end),A(1:N,:),b(1:N),...
         [cvlbI vlbR],[cvubI vubR],[],opt.LPopt);      % x = X0
      
      if chow <= 0 % Overly constrained: Loosen TolFun to find feas sol
         origTolFun = opt.LPopt.TolFun;
         opt.LPopt.TolFun = opt.ExTolFun * origTolFun;
         if opt.Display > 1
            fprintf('%36s Increasing TolFun for next node\n',' ');
         end
         [x0,~,chow] = linprog(...
            c,A(N+1:end,:),b(N+1:end),A(1:N,:),b(1:N),...
            [cvlbI vlbR],[cvubI vubR],[],opt.LPopt);   % x0 = X0
         opt.LPopt.TolFun = origTolFun;
      end
      
      nevals = nevals + 1;
   end
   
   % Current solution
   x0(isint(x0,opt.TolInt)) = round(x0(isint(x0,opt.TolInt)));
   %    x0 = x0(1:I);
   TC0 = c*x0;
   
   if chow > 0
      % Current solution cannot be fathomed
      if iff(isMin,TC0 < TC,TC0 > TC) && ~all(isint(x0(1:I),opt.TolInt))
         if opt.Display > 0 && (~isnan(ixx) || release)
            fprintf('%4d %4d %10.4f ',nevals-1,prnt,TC0);
            if ixx < 0
               fprintf('%4d LB of %3d\n',bndx,ixnofix(-ixx));
            elseif ixx > 0
               fprintf('%4d UB of %3d\n',bndx,ixnofix(ixx));
            elseif ixx == 0
               fprintf('%4d UB of',bndx);fprintf(' %3d',ixnofix(ixSOS1));
               fprintf('\n');
            end
         end
         
         % Select branching variable
         ixfrc = find(~isint(x0(1:I),opt.TolInt));
         [~,ixmxfrc] = max(min(ceil(x0(ixfrc)) - x0(ixfrc),...
            x0(ixfrc) - floor(x0(ixfrc))));
         ixx = ixfrc(ixmxfrc);		% Maximum integer infeasibility
         dvubI = cvubI;dvubI(ixx) = floor(x0(ixx));
         uvlbI = cvlbI;uvlbI(ixx) = ceil(x0(ixx));
         
         % Add to B&B tree
         if ~useSOS1			% No SOS1
            T = [T; TC0 cvlbI dvubI nevals-1 ixx dvubI(ixx);...
               TC0 uvlbI cvubI nevals-1 -ixx uvlbI(ixx)];
         else				% Use SOS1
            lSOS1 = SOS1;rSOS1 = SOS1;
            if SOS1(ixx)		% In SOS1
               ixSOS1 = find(SOS1 == SOS1(ixx)); % Find all SOS1 for ixx
               if length(ixSOS1) <= 2 % Use reg. bnds. when <= 2 in SOS1
                  lSOS1(ixSOS1) = zeros(1,length(ixSOS1));rSOS1 = lSOS1;
               else			% Use left & right SOS1 bnds. with a
                  % balanced no. of fractional vars
                  ixfrc = ixSOS1(~isint(x0(ixSOS1)));nfrc=length(ixfrc);
                  ixint = ixSOS1(isint(x0(ixSOS1))); nint=length(ixint);
                  ixl = [ixfrc(1:floor(nfrc/2)) ixint(1:ceil(nint/2))];
                  ixr = [ixfrc(floor(nfrc/2)+1:nfrc) ...
                     ixint(ceil(nint/2)+1:nint)];
                  % Set to -1 for display
                  lSOS1(ixl) = -ones(1,length(ixl));
                  rSOS1(ixr) = -ones(1,length(ixr));
                  lvubI = cvubI;lvubI(ixl) = zeros(1,length(ixl));
                  rvubI = cvubI;rvubI(ixr) = zeros(1,length(ixr));
                  ixx = 0;		% Set to 0 to indicate using SOS1
               end
            end
            if ixx ~= 0			% SOS1 not used, but pass l&r SOS1
               T = [T; TC0 cvlbI dvubI nevals-1 ixx dvubI(ixx) lSOS1;...
                  TC0 uvlbI cvubI nevals-1 -ixx uvlbI(ixx) rSOS1];
            else			% Use ixx = 0 and bndx = 0
               T = [T; TC0 cvlbI lvubI nevals-1 0 0 lSOS1;...
                  TC0 cvlbI rvubI nevals-1 0 0 rSOS1];
            end
         end
         % Current solution new incumbent
      elseif iff(isMin,TC0 < TC,TC0 > TC) && all(isint(x0(1:I),opt.TolInt));
         x = x0;
         TC = TC0;
         if opt.Display > 0
            fprintf('%4d %4d %10.4f ',nevals-1,prnt,TC);
            if ixx < 0
               fprintf('%4d LB of %3d',bndx,ixnofix(-ixx));
            elseif ixx > 0
               fprintf('%4d UB of %3d',bndx,ixnofix(ixx));
            elseif ixx == 0
               fprintf('%4d UB of',bndx);
               fprintf(' %3d',ixnofix(ixSOS1));
            end
            fprintf(' Incumbent\n');
         end
         if ~isempty(T)
            T = T(iff(isMin,T(:,1) < TC,T(:,1) > TC),:);
         end
         % Current solution fathomed due to value dominance
      else
         if opt.Display > 0
            fprintf('%4d %4d %10.4f ',nevals-1,prnt,TC0);
            if ixx < 0
               fprintf('%4d LB of %3d',bndx,ixnofix(-ixx));
            elseif ixx > 0
               fprintf('%4d UB of %3d',bndx,ixnofix(ixx));
            elseif ixx == 0
               fprintf('%4d UB of',bndx);
               fprintf(' %3d',ixnofix(ixSOS1));
            end
            fprintf(' Fathomed: value dominance\n');
         end
      end
      % Current solution fathomed due to not OK LP relaxation
   else
      if opt.Display > 0
         fprintf('%4d %4d %10.4f ',nevals-1,prnt,TC0);
         if ixx < 0
            fprintf('%4d LB of %3d',bndx,ixnofix(-ixx));
         elseif ixx > 0
            fprintf('%4d UB of %3d',bndx,ixnofix(ixx));
         elseif ixx == 0
            fprintf('%4d UB of',bndx);
            fprintf(' %3d',ixnofix(ixSOS1));
         end
         % (' Fathomed: %d\n',chow)
         fprintf(' Fathomed: infeasible\n');
      end
   end
end % End B&B tree evaluation

% No incumbent found during B&B tree evaluation
if iff(isMin,TC == Inf,TC == -Inf)
   if opt.Display > -1
      disp('Warning: There is no feasible integer solution.')
   end
   TC = c*x;
   XFlg = -1;
else
   XFlg = 1;
end

% If maximization
if ~isMin, TC = -TC; end



