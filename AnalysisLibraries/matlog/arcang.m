function ang = arcang(xy,XY)
%ARCANG Arc angles (in degrees) from xy to XY.
% ang = arcang(xy,XY), counterclockwise in degrees from east

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if length(xy(:)) ~= 2
   error('"xy" must be a 2-D point.')
elseif length(XY(:)) ~= 2 && size(XY,2) ~= 2
   error('"XY" must be a 2-column matrix.')
end
% End (Input Error Checking) **********************************************

if ~isempty(XY)
   ang = 180*atan2(XY(:,2) - xy(2), XY(:,1) - xy(1))/pi;
else
   ang = 0;
end
