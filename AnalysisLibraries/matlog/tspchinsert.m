function loc = tspchinsert(XY,h)
%TSPCHINSERT Convex hull insertion algorithm for TSP loc seq construction.
%   loc = tspchinsert(XY,h)
%    XY = n x 2 matrix of vertex cooridinates
%     h = (optional) handle to vertex plot, e.g., h = PPLOT(XY,'.');
%         use 'Set Pause Time' on figure's Matlog menu to pause plot
%   loc = (n + 1)-vector of vertices
%
% (a.k.a. the Vacuum Bag Algorithm)
%
% Example:
% vrpnc1
% h = pplot(XY,'r.');
% pplot(XY,num2cell(1:size(XY,1)))
% loc = tspchinsert(XY,h);
% TD = locTC(loc,dists(XY,XY,2))

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,2);

if nargin < 2 || isempty(h), h = NaN; end

[n,cXY] = size(XY);
if cXY ~= 2
   error('XY must be a 2-column matrix.')
elseif (~ishandle(h) && ~isnan(h)) || (ishandle(h) && (length(h) ~= 1 ||...
      ~strcmp(get(h,'Type'),'line') || ...
      ~strcmp(get(h,'LineStyle'),'none') || ...
      length(get(h,'XData')) ~= n || length(get(h,'YData')) ~= n))
   error('Invalid handle "h".')
end
% End (Input Error Checking) **********************************************

D = dists(XY,XY,2);

x = XY(:,1)'; y = XY(:,2)';

if n > 3, tri = delaunay(x,y); end

if n <= 3 || isempty(tri)	% tri == [] => Colinear points
   loc = [1:n 1];
   return
end
   
A = tri2adj(tri);
k = convhull(x,y)';
l = setdiff(1:n,k);
dk = 0;
for i = 1:length(k)-1
   dki = D(k(i),k(i+1));
   dk = dk + dki;
   t = l(all(A(l,[k(i) k(i+1)]) == 1,2));
   if isempty(t)
      kl(i) = NaN;
      dkl(i) = Inf;
   else
      t = t(1);
      kl(i) = t;
      dkl(i) = D(k(i),t) + D(t,k(i+1)) - dki;
   end
end

if ishandle(h)
   axes(get(h,'Parent'))
   title('Convex Hull Insertion TSP Loc Seq Construction')
   delete(findobj(gca,'Tag','locplot'))
   pplot(adj2list(A),XY,'c:','Tag','locplot')
   hh = pplot({k},XY,'m','Tag','locplot');
   if isempty(pauseplot('get')), pauseplot(Inf), end
end

while ~isempty(l)
   [dki,ikl] = min(dkl);
   if dki < Inf
      k = [k(1:ikl) kl(ikl) k(ikl+1:end)];
      dk = dk + dki;
      l = setdiff(l,kl(ikl));
      t1 = l(all(A(l,[k(ikl) k(ikl+1)]) == 1,2));
      if isempty(t1)
         kl(ikl) = NaN;
         dkl(ikl) = Inf;
      else
         t1 = t1(1);			% add: check for closest if t>1
         kl(ikl) = t1;
         dkl(ikl) = D(k(ikl),t1) + D(t1,k(ikl+1)) - D(k(ikl),k(ikl+1));
      end
      t2 = l(all(A(l,[k(ikl+1) k(ikl+2)]) == 1,2));
      if isempty(t2)
         kl = [kl(1:ikl) NaN kl(ikl+1:end)];
         dkl = [dkl(1:ikl) Inf dkl(ikl+1:end)];
      else
         t2 = t2(1);
         kl = [kl(1:ikl) t2 kl(ikl+1:end)];
         dki = D(k(ikl+1),t2) + D(t2,k(ikl+2)) - D(k(ikl+1),k(ikl+2));
         dkl = [dkl(1:ikl) dki dkl(ikl+1:end)];
      end
      for i = find(kl == k(ikl+1))
         t = l(all(A(l,[k(i) k(i+1)]) == 1,2));
         if isempty(t)
            kl(i) = NaN;
            dkl(i) = Inf;
         else
            t = t(1);
            kl(i) = t;
            dkl(i) = D(k(i),t) + D(t,k(i+1)) - D(k(i),k(i+1));
         end
      end
   elseif ~isempty(l)			% Vertices not assigned to loc
      for i = l
         [di,ik] = min(D(k,i));
         k = [k(1:ik) i k(ik+1:end)];
         dk = di + D(i,ik+1);
      end
      l = [];
   end
   if ishandle(h)
      delete(hh); hh = pplot({k},XY,'m','Tag','locplot');
      pauseplot
   end
end
i1 = find(k == 1);
loc = [k(i1:end-1) k(1:i1-1) 1];
