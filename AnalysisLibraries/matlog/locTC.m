function [TC,XFlg,out] = locTC(loc,varargin)
%LOCTC Calculate total cost of loc seq with time windows.
%            TC = locTC(loc,C)
% [TC,XFlg,out] = locTC(loc,C,cap,twin,locfeas)
%               = locTC(loc),  use arguments C,twin,... from previous call
%                              and do not check input for errors
%    loc = vector of single-seq vertices
%        = m-element cell array of m loc seqs
%          (to get sum(TC) as output, use vector loc = [loc{:}] as input)
%      C = n x n matrix of costs between n vertices
%     TC = m-element vector of loc seq costs, where 
%          TC(i) = Inf if loc seq i is infeasible
%
% Optional input and output arguments used to determine loc seq feasibility:
%    cap = {q,Q} = cell array of capacity arguments, where
%              q = n-element vector of vertex demands, with depot q(1) = 0
%              Q = maximum loc seq load
%   twin = {ld,TW,st} = cell array of time window arguments, where
%             ld = n or (n+1)-element vector of loading/unloading
%                  timespans, where
%                     ld(loc(1))   = load at depot
%                     ld(n+1)      = unload at depot, if loc(1) == loc(end)
%                = scalar of constant values "ld" for loc(2) ... loc(end)  
%                  and 0 for loc(1); or loc(2) ... loc(end-1) and 0 for
%                   loc(end), if loc(1) == loc(end)
%                = 0, default
%             TW = n or (n+1) x 2 matrix of time windows, where
%                     TW(i,1)      = start of time window for vertex i
%                     TW(i,2)      = end of time window
%                     TW(loc(1),:) = start time window at depot
%                     TW(n+1,:)    = finish time window at depot, 
%                                    if loc(1) = loc(end)
%                = (n+1)-element cell array, if multiple windows, where
%                     TW{i}        = (2 x p)-element vector of p window 
%                                    (start,end) pairs
%             st = (optional) m-element vector of starting times at depot
%                = TW(1,1) or min(TW{1}), default (earliest starting time)
%locfeas = {'locfeasfun',P1,P2,...} = cell array specifying user-defined
%          function to test the feasibility of a single loc seq (in addition  
%          to time windows, capacity, and maximum cost), where LOCTC 
%          argument out(i) along with user-specified arguments P1,P2,... 
%          are passed to function and a logical value should be returned: 
%                 isfeas = LOCFEASFUN(out(i),P1,P2,...)
%        = {'maxTCfeas',maxTC} is a predefined loc seq feasibility function
%          to test if the total cost of a loc seq (including loading/
%          unloading times "ld") exceeds the maximum waiting time "maxTC"
%          (see below for code)
%XFlg(i) = exitflag
%        =  1, if loc seq is feasible
%        = -1, if infeasible due to capacity
%        = -2, if infeasible due to time windows
%        = -3, if infeasible due to user-defined feasibility function
%    out = m-element struct array of outputs
% out(i) = output structure with fields:
%        .Loc     = loc seq indices, loc{i}
%        .Cost    = cost from vertex j-1 to j, 
%                   Cost(j) = C(r{i}(j-1),r{i}(j)) and Cost(1) = 0
%                 = drive timespan from vertex j-1 to j
%        .Demand  = demands of vertices on loc seq, q(loc{i})
%        .Arrive  = time of arrival
%        .Wait    = wait timespan if arrival prior to beginning of window
%        .Start   = time loading/unloading started (starting time for
%                   loc seq is "Start(1)")
%        .LD      = loading/unloading timespan, ld(loc{i})
%        .Depart  = time of departure (finishing time is "Depart(end)")
%        .Total   = total timespan from departing vtx j-1 to depart. vtx j
%                   (= drive + wait + loading/unloading timespan)
%        .EarlySF = earliest starting and finishing times (default starting
%                   time is "st" and default finish. time is "EarlySF(2)")
%        .LateSF  = latest starting and finishing times
%
% For each seq loc{i}, feasibility is determined in the following order:
%    1. Capacity feasibility: SUM(q(loc{i})) <= Q if feasible
%    2. Time window feasiblity: [TCi,ignore,outi] = LOCTC(loc{i},C,twin);
%                               TCi < Inf if feasible
%    3. User defined feasibility: isfeas = LOCFEASFUN(outi,P1,P2,...);
%                                 isfeas == true if feasible
%
% Code for example loc seq feasibility function:
%
% function isfeas = maxTCfeas(outi,maxTC)
% %MAXTCFEAS Maximum total cost loc seq feasibility function.
% % isfeas = maxwaitfeas(outi,maxTC)
% %   outi = struct array of outputs from LOCTC for single seq i
% %          (automatically passed to function)
% %  maxTC = scalar max. total cost (including un/loading times) of loc seq
% %
% % Loc Seq is feasible if sum(outi.Total) <= maxTC
% %
% % This function can be used as a template for developing other
% % loc seq feasibility functions.
% 
% % Input error check
% if ~isnumeric(maxTC) || length(maxTC(:)) ~= 1 || maxTC < 0
%    error('"maxTC" must be a nonnegative scalar.')
% end
% 
% % Feasibility test
% if sum(outi.Total) <= maxTC
%    isfeas = true;
% else
%    isfeas = false;
% end
%
%
% Examples:
% % 4-vertex graph
% IJD = [1 -2 1; 2 -3 2; 3 -4 1; 4 -1 1];
% C = dijk(list2adj(IJD))                  %  C =  0   1   2   1
%                                          %       1   0   2   2
%                                          %       2   2   0   1
%                                          %       1   2   1   0
% loc = [1 2 3 4 1];
% TC = locTC(loc,C)                        % TC =  5
%
% % Different loc seq, same C from previous call
% TC = locTC([1 2 3 4])                    % TC =  4
%
% % Time-windows
% ld = 0
% TW = [ 6 18       % Start time window at depot
%        8 11
%       12 14
%       15 18
%       18 24]      % Finish time window at depot
% [TC,XFlg,out] = locTC([1 2 3 4 1],C,[],{ld,TW})
%                                          %   TC =  8
%                                          % XFlg =  1
%                                          %  out = 
%                                          %          Loc: [1 2 3 4 1]
%                                          %         Cost: [0 1 2 1 1]
%                                          %       Demand: []
%                                          %       Arrive: [0 11 13 14 16]
%                                          %         Wait: [0 0 0 1 2]
%                                          %        Start: [10 11 13 15 18]
%                                          %           LD: [0 0 0 0 0]
%                                          %       Depart: [10 11 13 15 18]
%                                          %        Total: [0 1 2 2 3]
%                                          %      EarlySF: [10 18]
%                                          %       LateSF: [10 18]
%
% % Not feasible if total cost exceeds 4
% [TC,XFlg] = locTC([1 2 3 4 1],C,[],[],{'maxTCfeas',4})
%                                          %   TC = Inf
%                                          % XFlg =  -3
% [TC,XFlg] = locTC([1 2 3 4 1],C,[],[],{'maxTCfeas',4})
%                                          %   TC = Inf
%                                          % XFlg =  -3

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************

persistent C q Q ld TW st locfeas     % Set to empty

if nargin < 2
   if isempty(C)
      error('Additional input arguments required for first call.')
   else
      isfirstcall = 0;
   end
else
   isfirstcall = 1;
   if length(varargin) < 4
      [varargin{length(varargin)+1:4}] = deal([]);
   end
   [C,cap,twin,locfeas] = deal(varargin{:});
   [q,Q,ld,TW,st] = deal([]);
end

m = 1;
if iscell(loc), m = length(loc); end
TC = Inf * ones(m,1);                % All loc seqs initialized to infeasible
XFlg = ones(m,1);                    % All flags inialized to feasible

[n,nC] = size(C);

% Loc Seq
if isfirstcall && ~isempty(loc) && (~(isreal(loc) || iscell(loc)) || ...
      (~iscell(loc) && (min(size(loc)) ~= 1 || ...
      any(loc(:) < 1 | loc(:) > n))) || ...
      (iscell(loc) && (any(cellfun('prodofsize',loc) ~= ...
      cellfun('length',loc)) || any([loc{:}] < 1 | [loc{:}] > n))))
   error('"loc" not a valid loc seq.')
end

% Cost
if isfirstcall
   if n ~= nC
      error('C must be a square matrix.')
   elseif any(any(C<0))
      error('C must be a non-negative matrix.')
   elseif any(diag(C) ~= 0)
      error('C must have zeros along its diagonal.')
   end
end

% Capacity
if isfirstcall && ~isempty(cap)
   if ~iscell(cap) || length(cap(:)) ~= 2
      error('"cap" must be a two element cell array.')
   end
   q = cap{1}; Q = cap{2};
   if length(q(:)) ~= n
      error(['"q" must be an ',num2str(n),'-element vector.'])
   elseif q(1) ~= 0
      error('Depot''s demand, q(1), should equal 0.');
   elseif length(Q(:)) ~= 1 || Q < 0
      error('Q must be a nonnegative scalar.')
   elseif any(q > Q)
      error('Elements of "q" can not be greater than Q.')
   end
end

% Time window
if isfirstcall && ~isempty(twin)
   if ~iscell(twin) || length(twin(:)) < 1 || length(twin(:)) > 3
      error('"twin" must be a one or three element cell array.')
   end
   ld = twin{1};
   if ~isempty(ld), ld = ld(:)'; end
   if length(twin) > 1, TW = twin{2}; else TW = []; end
   if ~isempty(TW) && ~iscell(TW), TW = padmat2cell(TW); end
   if length(twin) > 2, st = twin{3}; st = st(:); else st = []; end
   
   if ~isempty(ld) && all(length(ld) ~= [1 n n+1])
      error('Length of "ld" must equal 1, n, or n + 1.')
   elseif ~isempty(TW)
      if iscell(TW), TW = cell2padmat(TW); end
      if all(size(TW,1) ~= [n n+1]) || mod(size(TW,2),2) ~= 0 || ...
            any(all(isnan(TW'))) || ...
            any(any(TW(:,1:2:end-1) > TW(:,2:2:end))) || ...
            any(any(xor(isnan(TW(:,1:2:end-1)),isnan(TW(:,2:2:end)))))
         error('TW not valid time windows.')
      end
   elseif ~isempty(st) && ~isempty(loc) && length(st(:)) ~= m
      error('Starting time "st" must be an m-element vector.')
   end
end

% Loc Seq feasibilty function
if ~isempty(locfeas) &&  strcmp(locfeas{1},'maxTCfeas') && ...
      all(isinf(locfeas{2}))
   locfeas = [];  % maxTC = Inf => always feasible
end
if isfirstcall && ~isempty(locfeas)
   if length(locfeas(:)) < 1
      error('"locfeas" must be at least a one element cell array.')
   end
   if ~ischar(locfeas{1})
      error('First element of "locfeas" must be a string.')
   elseif ~strcmp(locfeas{1},'maxTCfeas') && ~exist(locfeas{1},'file')
      error(['Function "' locfeas{1} '" not found.'])
   end
end

% Empty "loc" used for error checking and to store input arguments
if isempty(loc)
   if nargout > 0, TC = []; XFlg = []; out = []; end
   return
end
% End (Input Error Checking) **********************************************

% Initial timing output structure
if nargout > 2 || ~isempty(locfeas)
   out = struct('Loc',[],'Cost',[],'Demand',[],'Arrive',[],'Wait',[],...
      'Start',[],'LD',[],'Depart',[],'Total',[],'EarlySF',[],'LateSF',[]);
   out(1:m) = out;
end

% Evaluate each loc seq
for i = 1:m
    
   if iscell(loc), r = loc{i}; else r = loc(:)'; end
   
   % 1. Capacity feasibility
   if ~isempty(q) && ~isinf(Q)
      if nargout > 2 || ~isempty(locfeas), out(i).Demand = q(r); end
      if sum(q(r)) > Q; XFlg(i) = -1; continue, end
   end
   
   % Calculate loc seq cost
   c = diag(C(r(1:end-1),r(2:end)))';
   if isempty(ld) || all(ld == 0)
      ldi = zeros(1,length(r));
   else
      if length(ld) == 1
         ld = [0 ld*ones(1,n-1)];
         if r(1) == r(end), ld = [ld 0]; end
      end
      ldi = ld(r);
      if r(1) == r(end)
         if length(ld) ~= n+1
            error('Length of "ld" must equal n + 1.')
         end
         ldi(end) = ld(n+1);
      end
   end
   TC(i) = sum(c) + sum(ldi);
   if nargout > 2 || ~isempty(locfeas)
      out(i).Loc = r;
      out(i).Cost = [0 c];
      if ~isempty(ld), out(i).LD = ldi; end
      out(i).Total = [0 c] + ldi;
   end
   
   % 2. Time window feasibility
   if ~isempty(TW)
      B = TW(:,1:2:end-1);
      E = TW(:,2:2:end);
      Br = B(r,:); Er = E(r,:);
      if r(1) == r(end)
         if size(B,1) ~= n+1, error('Length of TW must equal n + 1.'), end
         Br(end,:) = B(n+1,:); Er(end,:) = E(n+1,:);
      end
      if ~isempty(st), sti = st(i); else sti = []; end
      if nargout < 3 && isempty(locfeas)
         TC(i) = locTW(c,ldi,Br,Er,sti);
      else
         [TC(i),s,w] = locTW(c,ldi,Br,Er,sti);
         
         if ~isinf(TC(i))
            s_late = latestart(c,ldi,Br,Er);
         else
            s_late = NaN;
         end        
         out(i).Arrive = [0 s(2:end)-w(2:end)];
         out(i).Wait = w;
         out(i).Start = s;
         out(i).Depart = s + ldi;
         out(i).Total = [0 c] + w + ldi;
         out(i).EarlySF = [s(1) s(end) + ldi(end)];
         out(i).LateSF = [s_late(1) s_late(1) + TC(i)];
      end
      if isinf(TC(i)), XFlg(i) = -2; continue, end
   end
   
   % 3. User defined feasibility function
   if ~isempty(locfeas)
      isfeas = feval(locfeas{1},out(i),locfeas{2:end});
      if length(isfeas(:)) ~= 1 % | ~islogical(isfeas)
         error('Output argument "isfeas" must be a scalar logical value.')
      end
      if isfeas == 0, 
         TC(i) = Inf; XFlg(i) = -3; continue, end
   end
   
end % FOR loop


% *************************************************************************
% *************************************************************************
% *************************************************************************
function [TC,s,w] = locTW(t,ld,B,E,st)
%LOCTW Single loc seq time window.

tol = 1e-8;
n = size(B,1);

if isempty(st), s = min(B(1,:)); else s = st; end

s = s + ld(1);
for i = 2:n  % Forward scan to determine earliest finish time
   s = s + t(i-1) + ld(i); 
   Bi = B(i,:) + ld(i);
   if ~any(s + tol >= Bi && s - tol <= E(i,:))
      s = min(Bi(Bi >= s));
      if isempty(s)
         TC = Inf; s = NaN; w = NaN; return
      end
   end
end
f = s;

s = f - ld(n);
for i = n-1:-1:1  % Reverse scan to determine latest start time for the
   % earliest finish
   s = s - t(i) - ld(i);
   Ei = E(i,:) - ld(i);
   if ~any(s + tol >= B(i,:) & s - tol <= Ei)
      s = max(Ei(Ei <= s));
   end
end
TC = f - s;
if isnan(TC), TC = sum(t) + sum(ld); end % If all Br == -Inf and all Er = Inf

if nargout > 1
   s = [s zeros(1,n-1)];
   w = zeros(1,n);
   for i = 2:n  % Second forward scan to delay waits as much as possible
      % to the end of the loc seq in case unexpected events occur
      s(i) = s(i-1) + ld(i-1) + t(i-1); 
      Bi = B(i,:);
      if ~any(s(i) + tol >= Bi & s(i) + ld(i) - tol <= E(i,:))
         w(i) = s(i);
         s(i) = min(Bi(Bi >= s(i)));
         w(i) = s(i) - w(i);
      end
   end
end


% *************************************************************************
% *************************************************************************
% *************************************************************************
function s = latestart(t,ld,B,E)
%LATESTART Determine latest start time.

tol = 1e-8;
n = size(B,1);

s = max(E(end,:)) - ld(n);
for i = n-1:-1:1  % Reverse scan to determine latest start time
   s = s - t(i) - ld(i);
   Ei = E(i,:) - ld(i);
   if ~any(s + tol >= B(i,:) && s - tol <= Ei)
      s = max(Ei(Ei <= s));
   end
end


% *************************************************************************
% *************************************************************************
% *************************************************************************
function isfeas = maxTCfeas(outi,maxTC)
%MAXTCFEAS Maximum total cost loc seq feasibility function.
% isfeas = maxwaitfeas(outi,maxTC)
%   outi = struct array of outputs from LOCTC for single loc seq i
%          (automatically passed to function)
%  maxTC = scalar maximum total cost (including un/loading times) of loc seq
%
% Loc Seq is feasible if sum(outi.Total) <= maxTC
%
% This function can be used as a template for developing other
% loc seq feasibility functions.

% Input error check
if ~isnumeric(maxTC) || length(maxTC(:)) ~= 1 || maxTC < 0
   error('"maxTC" must be a nonnegative scalar.')
end

% Feasibility test
if sum(outi.Total) <= maxTC
   isfeas = true;
else
   isfeas = false;
end
