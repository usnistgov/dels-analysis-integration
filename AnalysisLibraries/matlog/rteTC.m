function [TC,Xflg,out] = rteTC(rte,shin,C,trin)
%RTETC Total cost of route.
% [TC,Xflg,out] = rteTC(rte,sh,C)
%               = rteTC(rte,sh,C,tr)
%    rte = route vector
%        = m-element cell array of m route vectors
%     sh = structure array with fields:
%         .b = beginning location of shipment
%         .e = ending location of shipment
%        = include to check capacity feasibility of route:
%         .q = shipment weight (tons)
%         .s = shipment density (lb/ft^3)
%        = include to add shipment-related loading/unloading timespan to
%          route time/cost (location-related time should be added to C):
%         .tL = loading timespan = 0, default
%         .tU = unloading timespan = 0, default
%        = include to check time window feasibility of route:
%         .tbmin = earliest begin time = -Inf, default
%         .tbmax = latest begin time = Inf, default
%         .temin = earliest end time = -Inf, default
%         .temax = latest end time = Inf, default
%      C = n x n matrix of costs between n locations
%     tr = (optional) structure with fields:
%         .b = beginning location of truck = loc(1), default
%         .e = ending location of truck = loc(end), default
%        = include to check capacity feasibility of route:
%         .Kwt = weight capacity of trailer (tons) = Inf, default
%         .Kcu = cube capacity of trailer (ft^3) = Inf, default
%        = include to check max TC feasibility of route:
%         .maxTC = maximum route TC
%        = include to check time window feasibility of truck:
%         .tbmin = earliest begin time = -Inf, default
%         .tbmax = latest begin time = Inf, default
%         .temin = earliest end time = -Inf, default
%         .temax = latest end time = Inf, default
%  TC(i) = total cost of route i = sum of C and, if specified, tL and tU
%        = Inf if route i is infeasible
%XFlg(i) = exitflag for route i
%        =  1, if route is feasible
%        = -1, if degenerate location vector for route (see RTE2LOC)
%        = -2, if infeasible due to excess weight
%        = -3, if infeasible due to excess cube
%        = -4, if infeasible due to exceeding max TC (TC(i) > tr.maxTC)
%        = -5, if infeasible due to time window violation
%    out = m-element struct array of outputs
% out(i) = output structure with fields:
%        .Rte     = route, with 0 at begin/end if truck locations provided
%        .Loc     = location sequence
%        .Cost    = cost (drive timespan) from location j-1 to j,
%                   Cost(j) = C(j-1,j) and Cost(1) = 0
%        .Arrive  = time of arrival
%        .Wait    = wait timespan if arrival prior to beginning of window
%        .TWmin   = beginning of time window (earliest time)
%        .Start   = time loading/unloading started (starting time for
%                   route is Start(1))
%        .LU      = loading/unloading timespan
%        .Depart  = time of departure (finishing time is Depart(end))
%        .TWmax   = end of time window (latest time)
%        .Total   = total timespan from departing loc j-1 to depart. loc j
%                   (= drive + wait + loading/unloading timespan)
%
% Note, costs C(i,i) ignored for same-location portions of route
%
% Example 1:
% rte = [1  2  2  1];
%  sh = struct('b',{1,2},'e',{3,4});
%   C = triu(magic(4),1);  C = C + C'
%                                     %  C =  0   2   3  13
%                                     %       2   0  10   8
%                                     %       3  10   0  12
%                                     %      13   8  12   0
%  TC = rteTC(rte,sh,C)
%                                     % TC = 22
% Example 2: Time Windows
%  sh = vec2struct('b',[2:4],'e',1,'tbmin',[8 12 15],'tbmax',[11 14 18]);
%  tr = struct('b',1,'e',1,'tbmin',6,'tbmax',18,'temin',18,'temax',24);
%   C = [0 1 0 0; 0 0 2 0; 0 0 0 1; 1 0 0 0];
% rte = [1:3 (1:3)];
% [TC,Xflg,out] = rteTC(rte,sh,C,tr)
%                             % TC = 8
%                             % Xflg = 1
%                             % out =  Rte:  [0  1  2  3  1  2  3  0]
%                             %        Loc:  [1  2  3  4  1  1  1  1]
%                             %       Cost:  [0  1  2  1  1  0  0  0]
%                             %     Arrive:  [0 11 13 14 16 18 18 18]
%                             %       Wait:  [0  0  0  1  2  0  0  0]
%                             %      TWmin:  [6  8 12 15 18 18 18 18]
%                             %      Start: [10 11 13 15 18 18 18 18]
%                             %         LU:  [0  0  0  0  0  0  0  0]
%                             %     Depart: [10 11 13 15 18 18 18 18]
%                             %      TWmax: [18 11 14 18 24 24 24 24]
%                             %      Total:  [0  1  2  2  3  0  0  0]

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(3,4)

persistent sh tr shin2 trin2

if nargin < 3, C = []; end
if nargin < 4, trin = []; end

isfirstcall = false;
if isempty(sh) || ~isequal(trin2,trin) || ~isequal(shin2,shin)
   sh = shin; tr = trin;
   shin2 = shin; trin2 = trin;
   isfirstcall = true;
end

doTW = false;
if isfield(sh,'q'), doCap = true; else doCap = false; end
if isfield(sh,'tL') || isfield(sh,'tU'), doLU = true;else doLU = false; end
if isfield(sh,'tbmin') || isfield(sh,'tbmax') || ...
      isfield(sh,'temin') || isfield(sh,'temax'), doTW = true; end
if isfield(tr,'Kwt'), doKwt = true; else doKwt = false; end
if isfield(tr,'Kcu'), doKcu = true; else doKcu = false; end
if isfield(tr,'maxTC'), domaxTC = true; else domaxTC = false; end
if isfield(tr,'b') || isfield(tr,'e'), istrloc = true; else ...
      istrloc = false; end
if ~doTW && (isfield(tr,'tbmin') || isfield(tr,'tbmax') || ...
      isfield(tr,'temin') || isfield(tr,'temax')), doTW = true; end

if doLU && isfirstcall
   if ~isfield(sh,'tL'), sh = vec2struct(sh,'tL',0); end
   if ~isfield(sh,'tU'), sh = vec2struct(sh,'tU',0); end
end
if doTW && isfirstcall
   if ~isfield(sh,'tbmin'), sh = vec2struct(sh,'tbmin',-Inf); end
   if ~isfield(sh,'tbmax'), sh = vec2struct(sh,'tbmax',Inf); end
   if ~isfield(sh,'temin'), sh = vec2struct(sh,'temin',-Inf); end
   if ~isfield(sh,'temax'), sh = vec2struct(sh,'temax',Inf); end
   if istrloc
      if ~isfield(tr,'tbmin'), tr.tbmin = -Inf; end
      if ~isfield(tr,'tbmax'), tr.tbmax = Inf; end
      if ~isfield(tr,'temin'), tr.temin = -Inf; end
      if ~isfield(tr,'temax'), tr.temax = Inf; end
   end
end

checkrte(rte,sh)
if doCap && doKcu && ~isfield(sh,'s')
   error('Shipments must have field "s" for cube capacity check.')
elseif doTW && any([sh.tbmin] > [sh.tbmax] | [sh.temin] > [sh.temax])
   error('Min shipment time window exceeds max.')
elseif doTW && istrloc && (tr.tbmin > tr.tbmax || tr.temin > tr.temax)
   error('Min truck time window exceeds max.')
end
% End (Input Error Checking) **********************************************

if ~iscell(rte), rte = {rte}; end
TC = zeros(length(rte),1);
Xflg = ones(length(rte),1);
if nargout > 2
   fn = {'Rte','Loc','Cost','Arrive','Wait','TWmin','Start','LU',...
      'Depart','TWmax','Total'};
   out = cell2struct(cell(1,length(fn)),fn,2);
   out(1:length(rte)) = out;
end

for i = 1:length(rte)

   loc = rte2loc(rte{i},sh,tr);
   if any(isnan(loc)), Xflg(i) = -1; end

   if Xflg(i) > 0 && doCap && (doKwt || doKcu)   % Capacity Feasiblity
      ld = rte2ldmx(rte{i});
      for j = 1:length(ld)
         if doKwt && sum([sh(ld{j}).q]) > tr.Kwt
            Xflg(i) = -2; break
         elseif doKcu
            dx = 2000*sum([sh(ld{j}).q]./[sh(ld{j}).s]) - tr.Kcu;
            if dx > 0 && ~is0(dx), Xflg(i) = -3; break, end
         end
      end
   end

   if Xflg(i) < 0, TC(i) = Inf; continue, end

   idx = find([1 diff(loc(:),1,1)'] ~= 0);
   c = loccost(loc(idx),C);
   TC(i) = sum(c);
   
   if doTW || nargout > 2
      t = zeros(size(loc)); t(idx(2:end)) = c;
   end

   if doLU   % Add Loading/Unloading Time to TC
      isL = isorigin(rte{i});
      tLU = zeros(size(isL));
      tLU(isL) = [sh(rte{i}(isL)).tL];
      tLU(~isL)= [sh(rte{i}(~isL)).tU];
      TC(i) = TC(i) + sum(tLU);
      if istrloc, tLU = [0 tLU(:)' 0]; end
   end

   if domaxTC && TC(i) > tr.maxTC   % Max TC Feasibility
      Xflg(i) = -4; TC(i) = Inf;
   end

   if Xflg(i) > 0 && doTW   % Time Window Feasibility
      if ~doLU, tLU = zeros(size(loc)); end
      isL = isorigin(rte{i});
      [tmin,tmax] = deal(zeros(size(isL(:))));
      tmin(isL) = [sh(rte{i}(isL)).tbmin];
      tmin(~isL) = [sh(rte{i}(~isL)).temin];
      tmax(isL) = [sh(rte{i}(isL)).tbmax];
      tmax(~isL) = [sh(rte{i}(~isL)).temax];
      if istrloc
         idxb = 2:idx(2) - 1; idxe = idx(end):length(loc) - 1;
         tmin = [tr.tbmin; tmin; tr.temin];
         if ~isinf(tr.tbmin), tmin(idxb(isinf(tmin(idxb)))) = tr.tbmin; end
         if ~isinf(tr.temin), tmin(idxe(isinf(tmin(idxe)))) = tr.temin; end
         tmax = [tr.tbmax; tmax; tr.temax];
         if ~isinf(tr.tbmax), tmax(idxb(isinf(tmax(idxb)))) = tr.tbmax; end
         if ~isinf(tr.temax), tmax(idxe(isinf(tmax(idxe)))) = tr.temax; end
      end
      if nargout < 3
         TC(i) = scanTW(t,tLU,tmin,tmax);
      else
         [TC(i),s,w] = scanTW(t,tLU,tmin,tmax);
      end
      if isinf(TC(i)), Xflg(i) = -5; end
   end

   if Xflg(i) > 0 && nargout > 2   % Output Structure
      out(i).Rte = rte{i}(:)';
      if istrloc, out(i).Rte = [0 out(i).Rte 0]; end
      out(i).Loc = loc;
      out(i).Cost = t;
      out(i).Total = t;
      if doLU || doTW
         out(i).Total = t + tLU;
         out(i).LU = tLU;
      end
      if doTW
         out(i).Arrive = [0 s(2:end)-w(2:end)];
         out(i).Wait = w;
         out(i).TWmin = tmin';
         out(i).Start = s;
         out(i).Depart = s + tLU;
         out(i).TWmax = tmax';
         out(i).Total = t + w + tLU;
      end
   end
end


% *************************************************************************
% *************************************************************************
% *************************************************************************
function [TC,s,w] = scanTW(t,tLU,b,e)
%SCANTW Single location sequence time window scan.

tol = 1e-8;
n = size(b,1);

s = b(1) + tLU(1);
for i = 2:n  % Forward scan to determine earliest finish time
   bi = b(i) + tLU(i);
   s = s + t(i) + tLU(i);
   if s < bi - tol
      s = bi;
   elseif s > e(i) + tol
      TC = Inf; s = NaN; w = NaN; return
   end
end
f = s;

s = f - tLU(n);
for i = n-1:-1:1  % Reverse scan to determine latest start time for the
   % earliest finish
   s = s - t(i+1) - tLU(i);
   ei = e(i) - tLU(i);
   if s > ei + tol
      s = ei;
   end
end
TC = f - s;
if isnan(TC), TC = sum(t) + sum(tLU); end  % If all b == -Inf and e = Inf

if nargout > 1
   s = [s zeros(1,n-1)];
   w = zeros(1,n);
   for i = 2:n  % Second forward scan to delay waits as much as possible
      % to the end of the loc seq in case unexpected events occur
      s(i) = s(i-1) + tLU(i-1) + t(i);
      bi = b(i);
      if ~(s(i) + tol >= bi && s(i) + tLU(i) - tol <= e(i))
         w(i) = s(i);
         s(i) = bi;
         w(i) = s(i) - w(i);
      end
   end
end


