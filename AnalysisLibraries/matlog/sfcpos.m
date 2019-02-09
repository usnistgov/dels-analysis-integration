function theta = sfcpos(X,Y,k)
%SFCPOS Compute position of points along a 2-D spacefilling curve.
% theta = sfcpos(X,Y,k)
%   X,Y = single point in the unit square, or
%       = multiple 2-D points that will be scaled to the unit square
%         (single points must be in the unit square and are not scaled)
%     k = (optional) number of binary digits of X and Y to take into 
%         account when computing theta to 2k binary digits (= 8, default)
%
% (Based on algorithm in J.J. Bartholdi and L.K. Platzman, Management Sci.,
%  34(3):291-305, 1988)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(2,3);

if nargin < 3 || isempty(k), k = 8; end

X = X(:);Y = Y(:);
if length(X) ~= length(Y)
   error('X and Y must be the same length');
elseif ~isreal(k) || length(k(:)) ~= 1 || k < 1
   error('"k" must be a positive integer');
end
% End (Input Error Checking) **********************************************

if any(X < 0 | X > 1 | Y < 0 | Y > 1)
   if length(X) == 1
      error('X,Y must be a point in unit square (i.e., >= 0 and <= 1)');
   else					% Scale to unit square
      maxrng = max(max(X) - min(X),max(Y) - min(Y));
      X = (X - min(X))/maxrng;
      Y = (Y - min(Y))/maxrng;
   end
end

theta = localsfcpos(X,Y,k);

% *************************************************************************
% *************************************************************************
% *************************************************************************
function theta = localsfcpos(X,Y,k)

if k == 0
   theta = .5*ones(length(X),1);
   return
end
VN = [0 1;3 2];				% Note: Matlab doesn't use 0 indices
Quad = diag(VN(min(floor(2.*X+1),2),min(floor(2.*Y+1),2)));
SubPos = localsfcpos(2*abs(X-0.5),2*abs(Y-0.5),k-1);
SubPos(Quad == 1 | Quad == 3) = 1 - SubPos(Quad == 1 | Quad == 3);
theta = (Quad + SubPos - 0.5)./4;
theta = theta - floor(theta);
