function [loc,TC,bestvtx] = vrpsweep(XY,varargin)
%VRPSWEEP Gillett-Miller sweep algorithm for VRP loc seq construction.
% [loc,TC,bestvtx] = vrpsweep(XY,C,cap,twin,locfeas,h)
%     XY = n x 2 matrix of vertex cooridinates
%      C = n x n matrix of costs between n vertices
%        = dists(XY,XY,2), default
%    cap = {q,Q} = cell array of capacity arguments, where
%              q = n-element vector of vertex demands, with depot q(1) = 0
%              Q = maximum loc seq load
%   twin = {ld,TW} = cell array of time window arguments
%             ld = 1, n, or (n+1)-element vector of load/unload timespans
%             TW = n or (n+1) x 2 matrix of time windows
%                = (n+1)-element cell array, if multiple windows
%locfeas = {'locfeasfun',P1,P2,...} = cell array specifying user-defined
%          function to test the feasibility of a single loc seq
%      h = (optional) handle to vertex plot, e.g., h = PPLOT(XY,'.');
%          use 'Set Pause Time' on figure's Matlog menu to pause plot
%    loc = m-element cell array of m loc seqs
%     TC = m-element vector of loc seq costs
%bestvtx = vertex corresponding to minimum TC found (pos => CW; neg => CCW)
%
% See LOCTC for information about the input parameters
%
% (Adapted from on B.E. Gillett and L.R. Miller, Oper. Res., 22, 1974.)
%
% Example:
% vrpnc1  % Loads XY, q, Q, ld, and maxTC
% h = pplot(XY,'r.');
% pplot(XY,num2cellstr(1:size(XY,1)))
% [loc,TC,bvtx] = vrpsweep(XY,[],{q,Q},{ld},{'maxTCfeas',maxTC},h);

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,6)

if length(varargin) < 5, [varargin{length(varargin)+1:5}] = deal([]); end
[C,cap,twin,locfeas,h] = deal(varargin{:});

[n,cXY] = size(XY);
if cXY ~= 2, error('XY must be a 2-column matrix.'), end

if isempty(C), C = dists(XY,XY,2); end

try  % Use for error checking and to store input arguments
   tsp2opt([],C,cap,twin,locfeas);
catch
   errstr = lasterr;
   idx = find(double(errstr) == 10);
   error(errstr(idx(1)+1:end))
end

if isempty(h), h = NaN; end

if length(C) ~= n
   error('Length of C does not match XY.')
elseif (~ishandle(h) && ~isnan(h)) || ...
      (ishandle(h) && (length(h) ~= 1 || ...
      ~strcmp(get(h,'Type'),'line') || ...
      ~strcmp(get(h,'LineStyle'),'none') || ...
      length(get(h,'XData')) ~= n || length(get(h,'YData')) ~= n))
   error('Invalid handle "h".')
end
% End (Input Error Checking) **********************************************

% Sort vertices x- and y-(2:end) based on angle with x(1)and y(1)
[~,sidx] = sort(-atan2(XY(2:end,2) - XY(1,2), XY(2:end,1) - XY(1,1)));
sidx = [1; sidx+1]';

if ishandle(h)
   axes(get(h,'Parent'))
   delete(findobj(gca,'Tag','locplot'))
   XY = [get(h,'XData')' get(h,'YData')'];
   if strcmp(get(gca,'Tag'),'proj'), XY = invproj(XY); end
   title('VPR Sweep: Vertices Sorted Based on Angle with Depot')
   pplot({[sidx 1]},XY,'m','Tag','locplot');
   pplot(XY(1,:),'rs','Tag','locplot')
   if isempty(pauseplot('get')), pauseplot(Inf), end
end

initsvtx = [2:n -2:-1:-n];

% Determine best loc seq
TC = Inf;
for i = initsvtx
   if i >= 0
      dirstr = 'CW';
      swpvtx = sidx([i:n 2:i-1]);
   else
      dirstr = 'CCW';
      swpvtx = sidx([-i:-1:2 n:-1:-i+1]);
   end
   
   ri = {}; TCi = [];
   done = 0; m = 1; k = 1;
   while ~done
      TCim = locTC([1 swpvtx(1:k) 1]);
      if isinf(TCim)
         [rim,TCim] = tsp2opt([1 swpvtx(1:k) 1]);
         if isinf(TCim)
            [ri{m},TCi(m)] = tsp2opt([1 swpvtx(1:k-1) 1]);
            swpvtx(1:k-1) = [];
            m = m + 1;
            if isempty(swpvtx), done = 1; else k = 1; end
         else
            if k < length(swpvtx)
               k = k + 1;
            else
               ri{m} = rim; TCi(m) = TCim;
               done = 1;
            end
         end
      else
         if k < length(swpvtx)
            k = k + 1;
         else
            [ri{m},TCi(m)] = tsp2opt([1 swpvtx(1:k) 1]);
            done = 1;
         end
      end
   end % while
   
   if sum(TCi) < sum(TC)
      TC = TCi;
      loc = ri;
      bestvtx = sign(i)*sidx(abs(i));
      
      if ishandle(h)
         str = sprintf('VRP Sweep: %s from Vertex %d, TC = %f',...
            dirstr,abs(bestvtx),sum(TC));
         fprintf('%s\n',str), title(str)
         delete(findobj(gca,'Tag','locplot'))
         pplot(XY(1,:),'rs','Tag','locplot')
         pplot(loc,XY,'m','Tag','locplot')
         pauseplot
      end
      
   end
end % for

if ishandle(h)
   str = sprintf('VRP Sweep: Final TC = %f and %d Loc Seqs',...
      sum(TC),length(TC));
   fprintf('%s\n\n',str)
   title(str)
   delete(findobj(gca,'Tag','locplot'))
   pplot(XY(1,:),'rs','Tag','locplot')
   pplot(loc,XY,'m','Tag','locplot')
   pauseplot
end
