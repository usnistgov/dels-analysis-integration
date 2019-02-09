function D = dists(X1,X2,p,e)
%DISTS Metric distances between vectors of points.
%     D = dists(X1,X2,p,e)
%    X1 = n x d matrix of n d-dimensional points
%    X2 = m x d matrix of m d-dimensional points
%     D = n x m matrix of distances
%     p = 2, Euclidean (default): D(i,j) = sqrt(sum((X1(i,:) - X2(j,:))^2))
%       = 1, rectilinear: D(i,j) = sum(abs(X1(i,:) - X2(j,:))
%       = Inf, Chebychev dist: D(i,j) = max(abs(X1(i,:) - X2(j,:))
%       = (1 Inf), lp norm: D(i,j) = sum(abs(X1(i,:) - X2(j,:))^p)^(1/p)
%       = 'rad', great circle distance in radians of a sphere
%         (where X1 and X2 are decimal degree longitudes and latitudes)  
%       = 'mi' or 'sm', great circle distance in statute miles on the earth
%       = 'km', great circle distance in kilometers on the earth
%     e = epsilon for hyperboloid approximation gradient estimation
%       = 0 (default); no error checking if any non-empty 'e' input
%      ~= 0 => general lp used for rect., Cheb., and p outside [1,2]
%
% Examples:
% x1 = [1 1], x2 = [2 3]
% d = dists(x1,x2,1)       %  d = 3
%
% X2 = [0 0;2 0;2 3]
% d = dists(x1,X2,1)       %  d = 2  2  3
%
% D = dists(X2,X2,1)       %  D = 0  2  5
%                          %      2  0  3
%                          %      5  3  0
%
% city2lonlat = @(city,st) ...
%    uscity('XY',strcmp(city,uscity('Name'))&strcmp(st,uscity('ST')));
% d=dists(city2lonlat('Raleigh','NC'),city2lonlat('Gainesville','FL'),'mi')
%
%                          %  d = 475.9923
%
% Great circle distances are calculated using the Haversine Formula (R.W.
% Sinnott, "Virtues of the Haversine", Sky and Telescope, vol 68, no 2,
% 1984, p 159, reported in "http://www.census.gov/cgi-bin/geo/gisfaq?Q5.1")

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 22-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************

if isempty(X1) || isempty(X2), D = []; return, end

nd = size(X1); n = nd(1); d = nd(2);   % In case X not 2-D matrix
m = size(X2,1);
if nargin < 3 || isempty(p), p = 2; end
if nargin < 4 || isempty(e), e = 0; end

if nargin < 4  % Only do error checking if e not input
   narginchk(2,4);
   
   if isempty(X1) || ~isnumeric(X1) || ~ismatrix(X1)
      error('X1 must be non-empty numeric 2-D matrix.');
   elseif ~isnumeric(X2) || ~ismatrix(X1)
      error('X2 must be non-empty numeric 2-D matrix.');
   elseif size(X2,2) ~= d
      error('Rows of X1 and X2 must have same dimensions.');
   elseif ischar(p)
      p = lower(p);
      if d ~= 2
         error('Points must be 2-dimensional for great-circle distances.');
      elseif ~any(strcmp(p,{'rad','mi','sm','km'}))
         error('"p" must be either "rad," "mi," "sm," or "km".');
      end
   elseif ~ischar(p) && (length(p(:)) ~= 1 || ~isnumeric(p))
      error('"p" must be a scalar number.');
   end
end
% End (Input Error Checking) **********************************************

% Interchange if X2 is the only 1 point
intrchg = 0;
if n > 1 && m == 1
   tmp = X2; X2 = X1; X1 = tmp;
   m = n;n = 1;
   intrchg = 1;
end

% 1-dimensional points
if d == 1
   if e == 0
      if m ~= 0
         D = abs(X1(:,ones(1,m)) - X2(:,ones(1,n))');
      else
         D = abs(X1(1:n-1) - X1(2:n))';	% X1 intra-seq. dist.
      end
   else
      if m ~= 0
         D = sqrt((X1(:,ones(1,m)) - X2(:,ones(1,n))').^2 + e);
      else
         D = sqrt((X1(1:n-1) - X1(2:n)).^2 + e)';
      end
   end
   
   % X1 only 1 point   
elseif n == 1
   X1 = X1(ones(1,m),:);      % Expand X1 to match X2
   n = m;
   if p == 2                  % Euclidean distance
      D = sqrt(sum(((X1 - X2).^2 + e),2)');
   elseif ischar(p)           % Great-circle distance
      X1 = pi*X1/180;X2 = pi*X2/180;
      D = 2*asin(min(1,sqrt(sin((X1(:,2) - X2(:,2))/2).^2 + ...
         cos(X1(:,2)).*cos(X2(:,2)).* ...
         sin((X1(:,1) - X2(:,1))/2).^2)))';
   elseif p == 1 && e == 0     % Rectilinear distance
      D = sum(abs(X1 - X2),2)';
   elseif (p >= 1 && p <= 2) || (e ~= 0 && p > 0) % General lp distance
      D = sum((((X1 - X2).^2 + e).^(p/2)),2)'.^(1/p);
   elseif p == Inf && e == 0   % Chebychev distance
      D = max(abs(X1 - X2),2)';
   else                       % Otherwise
      D = zeros(1,n);
      for j = 1:n
         D(j) = norm(X1(j,:) - X2(j,:),p);
      end
   end
   
   % X1 and X2 are 2-dimensional points   
elseif d == 2
   if p == 2                  % Euclidean distance
      D = sqrt((X1(:,ones(1,m)) - X2(:,ones(1,n))').^2 + e + ...
         (X1(:,2*ones(1,m)) - X2(:,2*ones(1,n))').^2 + e);
   elseif ischar(p)           % Great-circle distance
      X1 = pi*X1/180;X2 = pi*X2/180;
      cosX1lat = cos(X1(:,2));cosX2lat = cos(X2(:,2));
      D = 2*asin(min(1,sqrt(...
         sin((X1(:,2*ones(1,m)) - X2(:,2*ones(1,n))')/2).^2 + ...
         cosX1lat(:,ones(1,m)).*cosX2lat(:,ones(1,n))'.* ...
         sin((X1(:,ones(1,m)) - X2(:,ones(1,n))')/2).^2)));
   elseif p == 1 && e == 0     % Rectilinear distance 
      D = abs(X1(:,ones(1,m)) - X2(:,ones(1,n))') + ...
         abs(X1(:,2*ones(1,m)) - X2(:,2*ones(1,n))');
   elseif (p >= 1 && p <= 2) || (e ~= 0 && p > 0)  % General lp distance
      D = (((X1(:,ones(1,m)) - X2(:,ones(1,n))').^2 + e).^(p/2) + ...
         ((X1(:,2*ones(1,m)) - X2(:,2*ones(1,n))').^2 + e).^(p/2)).^(1/p); 
   elseif p == Inf && e == 0   % Chebychev distance
      D = max(abs(X1(:,ones(1,m)) - X2(:,ones(1,n))'),...
         abs(X1(:,2*ones(1,m)) - X2(:,2*ones(1,n))'));
   else                       % Otherwise
      D = zeros(n,m);
      for i = 1:n
         for j = 1:m
            D(i,j) = norm(X1(i,:) - X2(j,:),p);
         end
      end   
   end
   
   % X1 and X2 are 3 or more dim. point   
else
   if p == 2                  % Euclidean distance
      D = sqrt(sum((repmat(reshape(X1,[n 1 d]),1,m) - ...
         repmat(reshape(X2,[1 m d]),n,1)).^2 + e,3));
   elseif p == 1 && e == 0     % Rectilinear distance
      D = sum(abs(repmat(reshape(X1,[n 1 d]),1,m) - ...
         repmat(reshape(X2,[1 m d]),n,1)),3);
   elseif (p >= 1 && p <= 2) || (e ~= 0 && p > 0)  % General lp distance
      D = sum(((repmat(reshape(X1,[n 1 d]),1,m) - ...
         repmat(reshape(X2,[1 m d]),n,1)).^2 + e).^(p/2),3).^(1/p);
   elseif p == Inf && e == 0   % Chebychev distance
      D = max(abs(repmat(reshape(X1,[n 1 d]),1,m) - ...
         repmat(reshape(X2,[1 m d]),n,1)),[],3);
   else                       % Otherwise
      D = zeros(n,m);
      for i = 1:n
         for j = 1:m
            D(i,j) = norm(X1(i,:) - X2(j,:),p);
         end
      end   
   end
end      

% Convert 'rad' to 'km' or 'mi' (or 'sm'), adjusting for bulge of earth
if ischar(p) && ~strcmp(p,'rad')
   meanlat = (X1(1:size(D,1),2*ones(m,1)) + X2(:,2*ones(size(D,1),1))')/2;
   if strcmp(p,'km')
      D = (6378.388 - 21.476*abs(sin(meanlat))).*D;
   else   % 'mi' or 'sm'
      D = (3963.34 - 13.35*abs(sin(meanlat))).*D;
   end
end

% Transpose D if X2 was interchanged
if intrchg == 1, D = D.'; end
