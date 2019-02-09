function XY = invproj(XY)
%INVPROJ Inverse Mercator projection.
%   XY = invproj(XY)
%    y = invproj(y)
%   XY = two-column matrix of longitude-latitude pairs (in decimal degrees)
%    y = column vector of latitudes (in decimal degrees)
%
% (Only latitudes are modified in the inverse Mercator projection, 
%  longitudes are unmodified and are not required.)
%
% (Based on Eric Weisstein's Mathworld website 
%  "http://mathworld.wolfram.com/MapProjection.html)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
cXY = size(XY,2);
if cXY > 2, error('Input must be two-column matrix or column vector.'), end
% End (Input Error Checking) **********************************************

if cXY == 2
   XY(:,2) = 180*atan(sinh(pi*XY(:,2)./180))./pi;
else
   XY = 180*atan(sinh(pi*XY./180))./pi;
end


