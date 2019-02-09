function [IJC11,IJC12,IJC22] = addconnector(XY1,XY2,IJC2,p,cir,thresh)
%ADDCONNECTOR Add connector from new location to transportation network.
%[IJC11,IJC12,IJC22] = addconnector(XY1,XY2,IJC2,p,cir,thresh)
%   XY1 = m1 x 2 matrix of m1 new location longitude-latitude pairs 
%         (in decimal degrees)
%   XY2 = m2 x 2 matrix of longitude-latitude pairs of original network   
%         nodes (in decimal degrees)
%  IJC2 = n2 x 3 matrix arc list of original network
%     p = distance parameter for DISTS, should be in same units as the
%         distances in IJC2
%       = 'mi', default, great circle distance in statute miles
%   cir = circuity factor (between 1 and 2) for connectors that represents 
%         the expected increase in arc distance compared to DISTS distance
%       = 1.50, default
%thresh = threshold (between 0 and 1) to only add arc to closest node in
%         original network (if ratio of distance from new location to 
%         closest node and to second closest node is less than threshold)
%       = 0.10, default
%       = 0 => don't consider threshold
%       = 1 => only add arc to closest node
% IJC11 = 3-column matrix arc list of connectors between new locations
% IJC12 = 3-column matrix arc list of connectors from new location to
%         original nodes
% IJC22 = 3-column matrix arc list of modified original network, where arc 
%         [i j] becomes [i+m1 j+m1]
%
% Examples:
% % 3 new nodes connected to 4 original nodes (Euclidean arc distances)
% XY1 = [2 1; 5 -1]; 
% XY2 = [0 0; 4 3; 4 -3; 8 0];
% IJC2 = [1 2 5; 1 3 5; 2 4 5; 3 4 5];
% [IJC11,IJC12,IJC22] = addconnector(XY1,XY2,IJC2,2)
% pplot(IJC11,XY1,'r-')
% pplot(IJC12,[XY1; XY2],'g-')
% pplot(IJC22,[XY1; XY2],'b-')
%
% % Connect cites around Raleigh, NC to road network
% xy1xy2 = [-79 35.5; -78 36];
% [XY,IJD] = subgraph(usrdnode('XY'),isinrect(usrdnode('XY'),xy1xy2),...
%    usrdlink('IJD'));
% [Name,XYcity] = uscity10k('Name','XY',isinrect(uscity10k('XY'),xy1xy2));
% [IJD11,IJD12,IJD22] = addconnector(XYcity,XY,IJD);
% makemap(XY)
% pplot(IJD11,XYcity,'r-')
% pplot(IJD12,[XYcity; XY],'g-')
% pplot(IJD22,[XYcity; XY],'b-')
% pplot(XYcity,'k.')
% pplot(XYcity,Name)
%
% Note: (1) Arc between a new location and the node in the original network
%  is added to the combined network when the great circle distance times 
%  circuity factor is less than shortest distance between the locations in 
%  remainder of network. Nodes considered are those defining the location's
%  triangle (using DELAUNAY) and, if not a triangle node, the closest node 
%  to the location (using DISTS).
%  (2) Single connector arc from new location to closest node in original
%  network if distance < thresh x distance to second closest node; 
%  connectors to other new locations added only their distance x thresh <= 
%  distance of shortest connector.
%  (3) Arc between two new locations in the same or adjacent triangles is
%  added to combined network when the great circle distance times circuity
%  factor is less than shortest distance between the locations in remainder
%  of network.
%  (4) Arc between new locations outside the convex hull of XY2 added to 
%  any new location that is one of the three closest nodes to the location.

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(3,6)

if nargin < 4 || isempty(p), p = 'mi'; end
if nargin < 5 || isempty(cir), cir = 1.50; end
if nargin < 6 || isempty(thresh), thresh = 0.10; end

[m1,cXY1] = size(XY1);
[m2,cXY2] = size(XY2);

if cXY1 ~= 2 || ~isnumeric(XY1)
   error('XY1 not a valid two-column matrix.')
elseif cXY2 ~= 2 || ~isnumeric(XY2)
   error('XY2 not a valid two-column matrix.')
elseif isempty(IJC2) || size(IJC2,2) < 2 || size(IJC2,2) > 3 || ...
      min(min(abs(IJC2(:,[1 2])))) < 1 || max(max(abs(IJC2(:,[1 2])))) > m2
   error('IJC2 not a valid arc list.')
elseif length(cir(:)) ~= 1 || cir < 1 || cir > 2 || ~isnumeric(cir)
   error('"cir" must be scalar between 1 and 2.')
elseif length(thresh(:)) ~= 1 || thresh < 0 || thresh > 1 || ...
      ~isnumeric(thresh)
   error('"thresh" must be scalar between 1 and 2.')   
end
% End (Input Error Checking) **********************************************

if m2 > 3
   try
%       T = delaunay(XY2(:,1),XY2(:,2));
%       idxT = tsearch(XY2(:,1),XY2(:,2),T,XY1(:,1),XY1(:,2));
      DT = DelaunayTri(XY2);
      T = DT.Triangulation;
      idxT = pointLocation(DT,XY1);
   catch
      T = [];
   end
else
   T = [];
end

IJC12 = [];
mind12i = zeros(m1,1);
% New Location to Orginal Node Connectors
for i = 1:m1
   d = dists(XY1(i,:),XY2,p)' * cir;
   [sd,idxsd] = sort(d);
   mind12i(i) = sd(1);
   if is0(sd(2)) || sd(1)/sd(2) < thresh
      IJC12 = [IJC12; i -idxsd(1) sd(1)];
   else
      if ~isempty(T) && ~isnan(idxT(i))   % Inside convex hull
         idxi = unique([T(idxT(i),:) idxsd(1)]);
      else   % Outside convex hull or single triangle
         idxi = idxsd(1:min(m2,3));   % Use 3 closest pts
      end
      D = dijk(list2adj(IJC2),idxi,idxi);
      isconnect = zeros(length(idxi),1);
      for j = 1:length(idxi)
         if ~isconnect(j)
            k = argmin(d(idxi) + D(:,j));
            if ~isconnect(k)
               IJC12 = [IJC12; i -idxi(k) d(idxi(k))];
               isconnect(k) = 1;
            end
         end
      end
   end
end

% Add offset for nodes of original network
IJC12(:,2) = sign(IJC12(:,2)).*(abs(IJC12(:,2))+m1);
IJC22 = [IJC2(:,1)+m1 sign(IJC2(:,2)).*(abs(IJC2(:,2))+m1) IJC2(:,3)];
if ~isempty(T), T = T + m1; end

IJC11 = [];
% New Location to New Location Connectors
for i = 1:m1
   if ~isempty(T) && ~isnan(idxT(i))   % Inside convex hull
      idxN = trineighbors(idxT(i),T);
      idxi = find(ismember(idxT,[idxT(i) idxN(~isnan(idxN))]'));
      idxi = idxi(idxi > i);
      if ~isempty(idxi)
         d = dists(XY1(i,:),XY1(idxi,:),p) * cir;
         mind11i = min(d);
         if ~is0(mind11i) && mind12i(i)/mind11i >= thresh
            k = find(argmin([d;dijk(list2adj([IJC12; IJC22]),i,idxi)]) == 1);
            if ~isempty(k)
               IJC11 = [IJC11; ones(length(k),1)*i -idxi(k) d(k)'];
            end
         end
      end
   else   % Outside convex hull
      d = dists(XY1(i,:),[XY1; XY2],p)' * cir;
      [sd,idxsd] = sort(d);
      idxi = idxsd(2:min(m1+m2,4));  % Use 3 closest pts not including self
      idxi = idxi(idxi <= m1);       % Only use new locations
      if ~isempty(idxi)
         if ~is0(sd(idxi(1))) && mind12i(i)/sd(idxi(1)) >= thresh
            if ~isempty(IJC11) % Remove duplicate arcs
               idxi = setdiff(idxi,IJC11(i == abs(IJC11(:,2)),1));
            end
            if ~isempty(idxi)
               idxi(d(idxi)' >= dijk(list2adj([IJC12; IJC22]),i,idxi)) = [];
               if ~isempty(idxi)
                  IJC11 = [IJC11; ones(length(idxi),1)*i -idxi d(idxi)];
               end
            end
         end
      end
   end
end
