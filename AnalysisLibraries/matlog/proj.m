function XY = proj(XY)
%PROJ Mercator projection.
%    XY = proj(XY)
%     y = proj(y)
%    XY = two-column matrix of longitude-latitude pairs (in decimal deg.)
%     y = column vector of latitudes (in decimal degrees)
%
% (Only latitudes are modified in the Mercator projection, longitudes are
%  unmodified and are not required.)
%
% (Based on Eric Weisstein's Mathworld website 
%  "http://mathworld.wolfram.com/MapProjection.html)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
cXY = size(XY,2);
if cXY > 2
   error('Input must be two-column matrix or column vector.')
elseif cXY == 2 && any(XY(:,1) < -180 | XY(:,1) > 180)
   error('Longitudes in XY(:,1) must be between -180 and 180 degrees.')
elseif (cXY == 1 && any(XY < -90 | XY > 90)) || ...
      (cXY == 2 && any(XY(:,2) < -90 | XY(:,2) > 90))
   error('Latitudes in XY must be between -90 and 90 degrees.')
end
% End (Input Error Checking) **********************************************

if cXY == 2
   XY(:,2) = 180*asinh(tan(pi*XY(:,2)./180))./pi;
else
   XY = 180*asinh(tan(pi*XY./180))./pi;
end


