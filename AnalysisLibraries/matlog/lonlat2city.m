function [idx,dist,drt,dstr] = lonlat2city(XY,city)
%LONLAT2CITY Determine nearest city given longitude-latitude of location.
% [idx,dist,drt,dstr] = lonlat2city(XY,city)
%    XY = n x 2 matrix of lon-lat (in decimal degrees) of n locations
%
% Optional input argument:
%  city = stucture with fields:
%       .Name = m-element cell array of m city name strings
%       .ST = m-element cell array of m 2-char state abbreviations
%       .XY = m x 2 matrix of city lon-lat (in decimal deg)
%       = USCITY50K, default (which contains all cities in US with
%                             population of at least 50,000)
%
% Output arguments: 'dstr' is displayed if no output arguments specified
%       idx = index of nearest city
%      dist = distance to nearest city (in miles)
%       drt = direction to nearest city, reported from 0 to 2PI 
%             radians clockwise from north
%      dstr = display of nearest city to lat-lon (in city, if dist < 4 mi)
%           = string, if n == 1
%           = n-element cell array, if n > 1 (use disp(dstr{i}) to display 
%                                              ith display string)
% Example:
% xy = uszip5('XY',28711==uszip5('Code5'));
% lonlat2city(xy)                     %  xy is 14.72 mi E of Asheville, NC
% lonlat2city(xy,uscity)              %  xy is in Montreat, NC

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ******************************************************
narginchk(1,2);

Xname = inputname(1); if isempty(Xname), Xname = 'X'; end

[n,cXY] = size(XY);
if cXY ~= 2
   error('XY must be 2-column matrix.')
end

if nargin < 2
   city = uscity50k;
else
   if ~isstruct(city)
      error('"city" must be a structure.')
   elseif ~all(ismember({'Name','ST','XY'},fieldnames(city)))
      error('Fields in structure "city" not correct.')
   elseif ~iscell(city.Name)
      error('"city.Name" must be a cell array.')
   end
   m = length(city.Name(:));
   if ~iscell(city.ST) || length(city.ST) ~= m
      error('"city.ST'' must be an m-element cell array.')
   elseif ~isreal(city.XY) || ischar(city.XY) || ...
         ~isequal(size(city.XY),[m 2])
      error('"city.XY" must be an m x 2 matrix of real numbers.')
   end
end
% End (Input Error Checking) ************************************************

InCityDist = 4;

[dist,idxx] = min(dists(XY,city.XY,'sm'),[],2);
[drtsrt,drt] = getdirection(n,city.XY(idxx,:),XY);

if nargout < 4 && n > 1
   dstr = cell(n,1);
end
if nargout == 0, disp(' '), end
for i = 1:n
   if n == 1
      d = [Xname,' is '];
   else
      d = [Xname,' ',num2str(i),' is '];
   end
   if dist(i) > InCityDist
      d = [d,num2str(dist(i),'%.2f'),' mi ',drtsrt{i},' of '];
   else   
      d = [d,'in '];
   end
   d = [d,city.Name{idxx(i)},', ',city.ST{idxx(i)}];
   if nargout == 0
      disp(d)
   else
      idx = idxx;
      if nargout == 4
         if n == 1 
            dstr = d;
         else
            dstr(i) = {d};
         end
      end
   end
end
if nargout == 0, disp(' '), end

 
% **************************************************************************
% **************************************************************************
% **************************************************************************
function [drtsrt,drt] = getdirection(n,fromlonlat,tolonlat)

lon1 = pi*fromlonlat(:,1)/180;lat1 = pi*fromlonlat(:,2)/180;
lon2 = pi*tolonlat(:,1)/180;lat2 = pi*tolonlat(:,2)/180;

% Great circle direction from Ed Williams, Aviation Formulary V1.24,
% http://www.best.com/~williams/avform.htm#Crs
drt = mod(atan2(cos(lat2).*sin(lon2-lon1),...
   cos(lat1).*sin(lat2) - sin(lat1).*cos(lat2).*cos(lon2-lon1)),2*pi);

rng = ones(n,1)*[0 1 3 5 7 9 11 13 15 16]*pi/8;
str = {'N','NE','E','SE','S','SW','W','NW','N'};

[j,i] = find((drt(:,ones(1,9)) >= rng(:,1:9) & drt(:,ones(1,9)) < rng(:,2:10))');
drtsrt = str(j);
