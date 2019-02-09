function xy2 = destloc(xy1,brg,d)
%DESTLOC Destination location given distance and bearing from start loc.
% xy2 = destpt(xy1,brg,d)
% xy1 = starting location
% brg = bearing, clockwise in degrees from north
%   d = distance (in miles)
% xy2 = destination location
%
% Source:
% http://www.movable-type.co.uk/scripts/latlong.html

% Input Error Checking ****************************************************
if length(xy1(:)) ~= 2
   error('"xy1" must be a 2-D point.')
elseif ~isscalar(brg)
   error('"brg" must be a scalar.')
elseif ~isscalar(d) || d < 0
   error('"d" must be a nonnegative scalar.')
end
% End (Input Error Checking) **********************************************

R = 3963.34;
xy1 = pi*xy1/180;
brg = pi*brg/180;
xy2(2) = asin(sin(xy1(2))*cos(d/R) + cos(xy1(2))*sin(d/R)*cos(brg));
xy2(1) = xy1(1) + ...
   atan2(sin(brg)*sin(d/R)*cos(xy1(2)), cos(d/R)-sin(xy1(2))*sin(xy2(2)));
xy2 = 180*xy2/pi;