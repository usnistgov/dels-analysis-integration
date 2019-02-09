function [loc,TC,bestvtx] = tspnneighbor(C,initvtx,h)
%TSPNNEIGHBOR Nearest neighbor algorithm for TSP loc seq construction.
% [loc,TC,bestvtx] = tspnneighbor(C,initvtx,h)
%       C = n x n matrix of costs between n vertices
% initvtx = [] (default) determine NN loc seq for all vertices and report 
%           best
%         = initial vertex (or vertices) of loc seq
%       h = (optional) handle to vertex plot, e.g., h = PPLOT(XY,'.');
%           use 'Set Pause Time' on figure's Matlog menu to pause plot
%     loc = (n + 1)-vector of vertices, best loc seq if initvtx = []
%      TC = total cost of loc seq, including C(n,1)
% bestvtx = vertex corresponding to minimum TC found
%
% Examples:
% vrpnc1
% C = dists(XY,XY,2);
% h = pplot(XY,'r.');
% pplot(XY,num2cell(1:size(XY,1)))
% [loc,TC] = tspnneighbor(C,1,h);          TC            % Initial Vertex 1
% [loc,TC,bestvtx] = tspnneighbor(C,[],h); TC, bestvtx   % All vertices

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,3);

[n,cC] = size(C);

if nargin < 2 || isempty(initvtx)
   initvtx = 1:n;
else
   initvtx = initvtx(:)';
end
if nargin < 3 || isempty(h), h = NaN; end

if cC ~= n
   error('C must be a square matrix.')
elseif any(any(C<0))
   error('C must be a non-negative matrix.')
elseif n > 1 && any(diag(C) ~= 0)
   error('C must have zeros along its diagonal.')
elseif any(initvtx < 1) || any(initvtx > n)
   error(['initvtx must be integer(s) between 1 and ' num2str(n) '.']);  
elseif (~ishandle(h) && ~isnan(h)) || (ishandle(h) && (length(h) ~= 1 ||...
      ~strcmp(get(h,'Type'),'line') || ...
      ~strcmp(get(h,'LineStyle'),'none') || ...
      length(get(h,'XData')) ~= n || length(get(h,'YData')) ~= n))
   error('Invalid handle "h".')
end
% End (Input Error Checking) **********************************************

C = C + diag(inf*ones(1,n));
TC = Inf;
loc_j = zeros(1,n);

if ishandle(h)
   axes(get(h,'Parent'))
   title('Nearest Neighbor TSP Loc Seq Construction')
   delete(findobj(gca,'Tag','locplot'))
   XY = [get(h,'XData')' get(h,'YData')'];
   if strcmp(get(gca,'Tag'),'proj'), XY = invproj(XY); end
   pplot(XY(initvtx(1),:),'ro','Tag','locplot')
   if isempty(pauseplot('get')), pauseplot(Inf), end
end

for i = initvtx
   loc_j(1) = i;
   TCj = 0;
   unvisvtx = 1:n;
   unvisvtx(i) = [];
   for j = 2:n
      [d_nearvtx,idx_nearvtx] = min(C(loc_j(j-1),unvisvtx));
      loc_j(j) = unvisvtx(idx_nearvtx);
      TCj = TCj + d_nearvtx;
      unvisvtx(idx_nearvtx) = [];
      
      if length(initvtx) == 1 && ishandle(h)
         pplot({[loc_j(j-1) loc_j(j)]},XY,'m','Tag','locplot')
         pauseplot
      end
      
   end
   TCj = TCj + C(loc_j(n),loc_j(1));
   if TCj < TC
      loc = loc_j;
      TC = TCj;
      bestvtx = i;
   end
   
   if length(initvtx) > 1 && ishandle(h)
      delete(findobj(gca,'Tag','locplot'))
      pplot(XY(i,:),'ro','Tag','locplot')
      pplot({loc_j},XY,'m','Tag','locplot')
      pauseplot
   end
   
end

% Make vertex 1 first in loc seq
if n > 1
   i1 = find(loc == 1);
   loc = [loc([i1:end 1:i1-1]) 1];
else
   loc = 1; TC = 0; bestvtx = 1;   % Single vertex loc seq
end

if ishandle(h)
   delete(findobj(gca,'Tag','locplot'))
   pplot(XY(bestvtx,:),'ro','Tag','locplot')
   pplot({loc},XY,'m','Tag','locplot')
   pauseplot
end
