function [loc,TC] = vrpinsert(C,varargin)
%VRPINSERT Insertion algorithm for VRP loc seq construction.
% [loc,TC] = vrpinsert(C,cap,twin,locfeas,idxs,h)
% [idxs,s] = vrpinsert(C,'seeds')                          % Output default
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
%   idxs = n-element of seed indices used to start new loc seqs
%        = (default) indices of vertices furthest from the depot:
%             idxs = fliplr(argsort(max(C(1,1:end),C(1:end,1)')));
%      h = (optional) handle to vertex plot, e.g., h = PPLOT(XY,'.');
%          use 'Set Pause Time' on figure's Matlog menu to pause plot
%      s = distance from depot, where s(i) = max(C(1,s(i)),C(s(i),1))
%    loc = m-element cell array of m loc seqs
%        = (n + 1)-vector of vertices, if single loc seq
%     TC = m-element vector of loc seq costs
%
% See LOCTC for information about the input parameters
%
% Example:
% vrpnc1  % Loads XY, q, Q, ld, and maxTC
% C = dists(XY,XY,2);
% h = pplot(XY,'r.');
% pplot(XY,num2cellstr(1:size(XY,1)))
% [loc,TC] = vrpinsert(C,{q,Q},{ld},{'maxTCfeas',maxTC},[],h);

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,6)

if length(varargin) < 5, [varargin{length(varargin)+1:5}] = deal([]); end
[cap,twin,locfeas,idxs,h] = deal(varargin{:});

outputdef = 0;
if strcmpi('seeds',cap), cap = []; outputdef = 1; end

try  % Use for error checking and to store input arguments
   locTC([],C,cap,twin,locfeas);
catch
   errstr = lasterr;
   idx = find(double(errstr) == 10);
   error(errstr(idx(1)+1:end))
end

n = length(C);

if isempty(h), h = NaN; end

if ~isempty(idxs) && (length(idxs(:)) ~= n || any(sort(idxs(:)) ~= (1:n)'))
   error('"idxs" not a valid vector of seed indices.')
elseif (~ishandle(h) && ~isnan(h)) || ...
      (ishandle(h) && (length(h) ~= 1 || ...
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
   title('Insertion Algorithm for VRP Loc Seq Construction')
   pplot(XY(1,:),'rs','Tag','locplot')
   if isempty(pauseplot('get')), pauseplot(Inf), end
end

% Default seed indices: furthest from the depot
if isempty(idxs)
   idxs = fliplr(argsort(max(C(1,1:end),C(1:end,1)')));
end
if outputdef
   loc = idxs';
   if nargout > 1
      TC = max(C(1,idxs),C(idxs,1)')';
   end
   return
end

idxs = idxs(:)';
idxs = invperm(idxs);  % Now idxs(i) is order of vertex i
idxs(1) = NaN;         % Not routing depot, idxs(1), indicted by NaN

% TC for single vertex
TC1 = locTC(padmat2cell([ones(n,1) (1:n)' ones(n,1)]));

m = 0;
while ~all(isnan(idxs))
   m = m + 1;
   idxm1 = argmin(idxs);
   idxs(idxm1) = NaN;
   loc{m} = [1 idxm1 1];
   TC(m) = TC1(idxm1);
   
   done = 0;
   while ~done
      maxsav = -Inf;
      for i = find(~isnan(idxs))
         for j = 1:length(loc{m}) - 1
            rij = [loc{m}(1:j) i loc{m}(j+1:end)];
            sav = TC(m) + TC1(i) - locTC(rij);
            if sav > maxsav
               maxsav = sav;
               bestloc = rij;
               bestvtx = i;
            end
         end
      end
      if ~all(isnan(idxs)) && maxsav > -Inf
         loc{m} = bestloc;
         TC(m) = locTC(loc{m});
         idxs(bestvtx) = NaN;
         
         if ishandle(h)
            str = sprintf('VRP Insert: Vertex %d, TC = %f',...
               bestvtx,sum(TC));
            fprintf('%s\n',str)
            title(str)
            delete(findobj(gca,'Tag','locplot'))
            pplot(XY(1,:),'rs','Tag','locplot')
            pplot(loc,XY,'m','Tag','locplot')
            pauseplot
         end
         
      else
         done = 1;
      end
   end
end

if ishandle(h)
   str = sprintf('VRP Insert: Final TC = %f and %d Loc Seqs',...
      sum(TC),length(TC));
   fprintf('%s\n\n',str)
   title(str)
   delete(findobj(gca,'Tag','locplot'))
   pplot(XY(1,:),'rs','Tag','locplot')
   pplot(loc,XY,'m','Tag','locplot')
   pauseplot
end

TC = TC(:);
