function XY = normlonlat(XY)
%NORMLONLAT Convert longitude and latitude to normal form.
%    XY = normlonlat(XY)
%    XY = n x 2 matrix of longitude-latitude pairs (in decimal degrees)
%
% Normal form: -180 < X <= 180 and -90 <= Y <= 90

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if size(XY,2) ~= 2, error('XY must be a two column matrix.'), end
% End (Input Error Checking) **********************************************

X = XY(:,1); Y = XY(:,2);

Y = rem(Y,360);
isY = Y > 270;
if any(isY)
   Y(isY) = Y(isY) - 360;
end
isY = Y > 90;
if any(isY)
   X(isY) = X(isY) + 180;
   Y(isY) = 180 - Y(isY);
end
isY = Y < -270;
if any(isY)
   Y(isY) = Y(isY) + 360;
end
isY = Y < -90;
if any(isY)
   X(isY) = X(isY) + 180;
   Y(isY) = -180 - Y(isY);
end

X = rem(X,360);
if any(X > 180)
   X(X > 180) = X(X > 180) - 360;
end
if any(X < -180)
   X(X <= -180) = X(X <= -180) + 360;
end

XY = [X Y];
   
   
