function isin = isinrect(XY,xy1xy2)
%ISINRECT Are XY points in rectangle.
%    isin = isinrect(XY,xy1xy2)
%         = isinrect(XY)       % Graphical input of rectangle using GRECT
%  xy1xy2 = rectangle
%         = [min(X) min(Y); max(X) max(Y)]
%
% Note: isin = XY(:,1) >= min(X) & XY(:,1) <= max(X) & ...
%              XY(:,2) >= min(Y) & XY(:,2) <= max(Y)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if nargin < 2 || isempty(xy1xy2)
   xy1xy2 = grect;
elseif ~all(size(xy1xy2) == [2 2])
   error('"xy1xy2" must be a 2 x 2 matrix.')
elseif xy1xy2(1,1) > xy1xy2(2,1) || xy1xy2(1,2) > xy1xy2(2,2)
   error('min(X) must be <= max(X) and min(Y) must be <= max(Y).')
end
% End (Input Error Checking) **********************************************

if isempty(xy1xy2)
   isin = [];         % Pass through from GRECT
elseif length(xy1xy2(:)) == 1
   isin = xy1xy2;     % Pass through from GRECT
else
   isin = XY(:,1) >= xy1xy2(1,1) & XY(:,1) <= xy1xy2(2,1) & ...
      XY(:,2) >= xy1xy2(1,2) & XY(:,2) <= xy1xy2(2,2);
end
