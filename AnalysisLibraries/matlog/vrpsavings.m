function [loc,TC] = vrpsavings(C,varargin)
%VRPSAVINGS Clark-Wright savings algorithm for VRP loc seq construction.
% [loc,TC] = vrpsavings(C,cap,twin,locfeas,Sij,h)
%  [Sij,s] = vrpsavings(C,'savings')                       % Output default
%      C = n x n matrix of costs between n vertices
%    cap = {q,Q} = cell array of capacity arguments, where
%              q = n-element vector of vertex demands, with depot q(1) = 0
%              Q = maximum loc seq load
%   twin = {ld,TW} = cell array of time window arguments
%             ld = 1, n, or (n+1)-element vector of load/unload timespans
%             TW = n or (n+1) x 2 matrix of time windows
%                = (n+1)-element cell array, if multiple windows
%locfeas = {'locfeasfun',P1,P2,...} = cell array specifying user-defined
%          function to test the feasibility of a single loc seq
%    Sij = 2-column matrix of savings indices [i j]
%        = (default) indices corresponding to savings S(i,j) in
%          non-increasing order, where
%             S(i,j) = C(i,1) + C(1,j) - C(i,j), for i,j = 2:n, i ~= j
%      h = (optional) handle to vertex plot, e.g., h = PPLOT(XY,'.');
%          use 'Set Pause Time' on figure's Matlog menu to pause plot
%    loc = m-element cell array of m loc seqs
%     TC = m-element vector of loc seq costs
%      s = vector of savings S(i,j) corresponding to Sij
%
% See LOCTC for information about the input parameters
%
% (Based on G. Clark and J.W. Wright, Oper. Res., 12, 1964, as described in
%  R.C. Larson and A.R. Odoni, Urban Operations Res., Prentice-Hall, 1981.)
%
% Example:
% vrpnc1  % Loads XY, q, Q, ld, and maxTC
% C = dists(XY,XY,2);
% h = pplot(XY,'r.');
% pplot(XY,num2cellstr(1:size(XY,1)))
% [loc,TC] = vrpsavings(C,{q,Q},{ld},{'maxTCfeas',maxTC},[],h);

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,6)

if length(varargin) < 5, [varargin{length(varargin)+1:5}] = deal([]); end
[cap,twin,locfeas,Sij,h] = deal(varargin{:});

outputdef = 0;
if strcmpi('savings',cap), cap = []; outputdef = 1; end

try  % Use for error checking and to store input arguments
   locTC([],C,cap,twin,locfeas);
catch
   errstr = lasterr;
   idx = find(double(errstr) == 10);
   error(errstr(idx(1)+1:end))
end

n = length(C);

if isempty(Sij), [Sij,s] = savings(C); end
if isempty(h), h = NaN; end

if outputdef, loc = Sij; TC = s; return, end

if size(Sij,2) ~= 2 || any(Sij(:,1) == Sij(:,2)) || any(Sij(:,1) < 1) ...
      || any(Sij(:,2) < 1) || any(Sij(:,1) > n) || any(Sij(:,2) > n)
   error('Incorrect savings indices "Sij".')
elseif (~ishandle(h) && ~isnan(h)) || (ishandle(h) && (length(h) ~= 1 ||...
      ~strcmp(get(h,'Type'),'line') || ...
      ~strcmp(get(h,'LineStyle'),'none') || ...
      length(get(h,'XData')) ~= n || length(get(h,'YData')) ~= n))
   error('Invalid handle "h".')
end
% End (Input Error Checking) **********************************************

if ishandle(h)
   axes(get(h,'Parent'))
   delete(findobj(gca,'Tag','locplot'))
   XY = [get(h,'XData')' get(h,'YData')'];
   if strcmp(get(gca,'Tag'),'proj'), XY = invproj(XY); end
   title('Savings Algorithm for VRP Loc Seq Construction')
   pplot(XY(1,:),'rs','Tag','locplot')
   if isempty(pauseplot('get')), pauseplot(Inf), end
end

% Internal variable definitions:
%
%       S(i,j) = savings associated with adding edge (i,j) to a loc seq
%            s = current edge
%    i(s) = is = beginning vtx of edge 's'
%    j(s) = js = ending vtx of edge 's'
% intvtx(i(s)) = 1, if vtx i(s) is interior vtx of a loc seq
%        b(is) = loc seq that vtx 'is' is beginning vtx in
%              = 0, if 'is' not beginning vtx
%        e(is) = loc seq that vtx 'is' is ending vtx in
%              = 0, if 'is' not ending vtx
%           ir = max{b(is),e(is)} = loc seq that vtx 'is' is beginning or
%                                   ending vtx in
%              = 0, if vtx 'is' not beginning or ending vtx
%           nr = no. of current loc seq
%        r{nr} = loc seq 'nr'
%    nvtxinloc = no. vtx in all loc seqs created so far

% Create multi-vertex loc seqs (single-vertex loc seqs created later)
i = Sij(:,1); j = Sij(:,2);
[intvtx,b,e,qr] = deal(zeros(1,n));
nr = 0;
s = 1;
while s <= length(i)
   
   % Both vtx i & j not interior
   if ~intvtx(i(s)) && ~intvtx(j(s))             
      is = i(s);
      js = j(s);
      ir = b(is) + e(is);
      jr = b(js) + e(js);
      replot = 1;
      
      % Make new loc using vtx i & j
      if ~ir && ~jr && isfinite(locTC(add1s([is js])))        
         nr = nr + 1;
         r{nr} = [is js];
         b(is) = nr;
         e(js) = nr;
         str = sprintf('Make New Loc Seq %d using Vertices %d and %d',...
            nr,is,js);
         
         % Add vtx j to loc i
      elseif ir && ~jr && e(is) && isfinite(locTC(add1s([r{ir} js])))      
         r{ir} = [r{ir} js];
         e(js) = ir;
         intvtx(is) = 1;
         str = sprintf('Add Vertex %d to End of Loc Seq %d',js,ir);
         
         % Add  vtx i to loc j
      elseif ~ir && jr && b(js) && isfinite(locTC(add1s([is r{jr}])))    
         r{jr} = [is r{jr}];
         b(is) = jr;         
         intvtx(js) = 1;
         str = sprintf('Add Vertex %d to Beginning of Loc Seq %d',is,jr);
        
         % Combine loc i & j
      elseif ir && jr && ir ~= jr && e(is) && b(js) && ...
            isfinite(locTC(add1s([r{ir} r{jr}])))    
         e(r{jr}(end)) = ir;
         r{ir} = [r{ir} r{jr}];
         r{jr} = [];
         intvtx([is js]) = 1;
         str = sprintf('Combine Loc Seqs %d and %d',ir,jr);
        
         % Can't make new loc seq
      else
         replot = 0;
      end   % Make new loc using vtx i & j
      
      if ishandle(h) && replot == 1
         rr = r;
         for k = 1:nr, rr{k} = [1 rr{k} 1]; end
         str = sprintf('VRP Savings: %s, TC = %f',str,sum(locTC(rr)));
         fprintf('%s\n',str), title(str)
         delete(findobj(gca,'Tag','locplot'))
         pplot(XY(1,:),'rs','Tag','locplot')
         pplot(rr,XY,'m','Tag','locplot')
         pauseplot
      end
      
   end   % Both vtx i & j not interior
   
   s = s + 1;
   b(1) = 0; e(1) = 0;   % Re-set in case is = 1 or js = 1 was added to loc
   
end   % while

% Create single-vertex loc seqs
for s = find(~b(2:end) & ~e(2:end)) + 1
   nr = nr + 1;
   r{nr} = s;
   if ~isfinite(add1s(s))
      if nargout < 4
         error(['Loc Seq [1 ',num2str(s),' 1] infeasible.'])
      else
         XFlg = -1; loc = add1s(s); TC = []; return
      end
   end
end
if nr == 0, loc = 1; end   % Depot-only loc seq
XFlg = 1;

% Remove empty loc seqs in 'r' to make 'loc'
m = 0;
for k = 1:nr
   if ~isempty(r{k})
      m = m + 1;
      loc{m} = add1s(r{k});
   end
end

if nargout > 1, TC = locTC(loc); else TC = []; end

if ishandle(h) && nargout > 1
   str = sprintf('VRP Savings: Final TC = %f and %d Loc Seqs',...
      sum(TC),length(TC));
   fprintf('%s\n\n',str)
   title(str)
   delete(findobj(gca,'Tag','locplot'))
   pplot(XY(1,:),'rs','Tag','locplot')
   pplot(loc,XY,'m','Tag','locplot')
   pauseplot
end


% *************************************************************************
% *************************************************************************
% *************************************************************************
function loc = add1s(loc)
%ADDLS Add depot to begin and end of loc seq.

if loc(1) ~= 1, loc = [1 loc]; end
if loc(end) ~= 1, loc = [loc 1]; end


% *************************************************************************
% *************************************************************************
% *************************************************************************
function [Sij,s] = savings(C)
%SAVINGS Ordered savings.

n = length(C);

[i,j,s] = argsort(...
   C(2:end,1)*ones(1,n-1) + ones(n-1,1)*C(1,2:end) - C(2:end,2:end));
Sij = flipud([i j s]);
Sij(Sij(:,1) == Sij(:,2),:) = [];
s = Sij(:,3);
Sij = Sij(:,[1 2]) + 1;
