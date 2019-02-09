function [loc,TC] = tsp2opt(loc,varargin)
%TSP2OPT 2-optimal exchange procedure for TSP loc seq improvement.
%[loc,TC] = tsp2opt(loc,C,cap,twin,locfeas,h)
%    loc = vector of single-seq vertices, where loc(1) = loc(end)
%          (loc seq can be infeasible)
%        = m-element cell array of m loc seqs
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
%     h = (optional) handle to vertex plot, e.g., h = PPLOT(XY,'.');
%         use 'Set Pause Time' on figure's Matlog menu to pause plot
%     TC = m-element vector of loc seq costs
%
% See LOCTC for information about the input parameters
%
% Note: Also checks reverse of loc seq for improvement in addition to two-
%       edge exchanges
%
% Example:
% vrpnc1
% C = dists(XY,XY,2);
% h = pplot(XY,'r.');
% rand('state',100)
% loc = [1 randperm(size(XY,1)-1)+1 1];
% [loc,TC] = tsp2opt(loc,C,[],[],[],h);
% pplot({loc},XY,num2cellstr(1:size(XY,1)))

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************

persistent C h issym isonlyC  % Set to empty

if nargin < 2
   if isempty(C)
      error('Additional input arguments required for first call.')
   else
      isfirstcall = 0;
   end
   TC = locTC(loc);
else
   isfirstcall = 1;
   if length(varargin) < 5
      [varargin{length(varargin)+1:5}] = deal([]);
   end
   [C,cap,twin,locfeas,h] = deal(varargin{:});
   try  % Use for error checking and to store input arguments
      TC = locTC(loc,C,cap,twin,locfeas);
   catch
      errstr = lasterr;
      idx = find(double(errstr) == 10);
      error(errstr(idx(1)+1:end))
   end
end

if ~iscell(loc), iscellloc = 0; loc = {loc(:)'}; else, iscellloc = 1; end

if isfirstcall
   if ~isempty([loc{:}])
      for i = 1:length(loc)
         if loc{i}(1) ~= loc{i}(end)
            error(['loc{' int2str(i) '}(1) not equal to loc{' ...
                  int2str(i) '}(n+1).'])
         elseif length(loc{i}) > size(C,1) + 1
            error(['Length of loc{' int2str(i) '} cannot exceed n + 1.'])
         end
      end
   else % Empty "loc" used for error checking and to store input arguments
      if nargout > 1, TC = []; end
      return
   end
   if isempty(h), h = NaN; end
   if (~ishandle(h) && ~isnan(h)) || (ishandle(h) && (length(h) ~= 1 || ...
         ~strcmp(get(h,'Type'),'line') || ...
         ~strcmp(get(h,'LineStyle'),'none') || ...
         length(get(h,'XData')) ~= size(C,1) || ...
         length(get(h,'YData')) ~= size(C,1)))
      error('Invalid handle "h".')
   end
end
% End (Input Error Checking) **********************************************

if isfirstcall 
   if ~any(any(triu(C)~=tril(C)')), issym = 1; else issym = 0; end
end

if isfirstcall
   if (isempty(twin) || (length(twin) < 2 && ...
         (isempty(twin{1}) || all(twin{1} == 0)))) && ...
         (isempty(locfeas) || ...
         (strcmp(locfeas{1},'maxTCfeas') && isinf(locfeas{2})))
      isonlyC = 1;
   else 
      isonlyC = 0;
   end
end

if ishandle(h)
   axes(get(h,'Parent'))
   delete(findobj(gca,'Tag','locplot'))
   XY = [get(h,'XData')' get(h,'YData')'];
   if strcmp(get(gca,'Tag'),'proj'), XY = invproj(XY); end
   title(['TSP 2-Opt Loc Seq Improvement: TC = ' num2str(sum(TC))])
   pplot(loc,XY,'m','Tag','locplot')
   if isempty(pauseplot('get')), pauseplot(Inf), end
end

% Main Loop
for k = 1:length(loc)
   r = loc{k};
   done = 0;
   while ~done
      done = 1;
      for i = 1:length(r)-2
         for j = i+2:min(length(r)-1,length(r)+i-3)
            if isonlyC
               d = C(r(i),r(j)) - C(r(i),r(i+1)) + ...
                  C(r(i+1),r(j+1)) - C(r(j),r(j+1));
               if ~issym
                  d = d + sum(diag(C(r(j:-1:i+2),r(j-1:-1:i+1)))) - ...
                     sum(diag(C(r(i+1:j-1),r(i+2:j))));
               end
               if d < 0
                  r = [r(1:i) fliplr(r(i+1:j)) r(j+1:end)];
                  TC(k) = TC(k) + d;
                  done = 0;
               end
            else
               rij = [r(1:i) fliplr(r(i+1:j)) r(j+1:end)];
               TCij = locTC(rij);
               if TCij < TC(k)
                  TC(k) = TCij;
                  r = rij;
                  done = 0;
               end
            end % if
            if ~done, break, end
         end % j
         if ~done, break, end
      end % i
      
      if done && ~(isonlyC && issym)  % Check reverse loc seq
         rflip = fliplr(r);
         TCflip = locTC(rflip);
         if TCflip < TC(k)
            TC(k) = TCflip;
            r = rflip;
            done = 0;
         end
      end
      
      if ~done && ishandle(h)
         delete(findobj(gca,'Tag','locplot'))
         title(['TSP 2-Opt Loc Seq Improvement: TC = ' num2str(sum(TC))])
         pplot({r},XY,'m','Tag','locplot')
         pauseplot
      end
      
   end % while
   loc{k} = r;
end % for

if ~iscellloc
   loc = loc{:};
elseif ishandle(h)
   delete(findobj(gca,'Tag','locplot'))
   title(['TSP 2-Opt Loc Seq Improvement: TC = ' num2str(sum(TC))])
   pplot(loc,XY,'m','Tag','locplot')
   pauseplot
end
