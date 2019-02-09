function loc = tspspfillcur(XY,k)
%TSPSPFILLCUR Spacefilling curve algorithm for TSP loc seq construction.
%   loc = tspspfillcur(XY,k)
%    XY = n x 2 matrix of vertex cooridinates
%     k = (optional) no. of binary digits to use in SFCPOS (= 8, default)
%   loc = (n + 1)-vector of vertices
%
% (Based on algorithm in J.J. Bartholdi and L.K. Platzman, Management Sci.,
%  34(3):291-305, 1988)
%
% Example:
% vrpnc1
% loc = tspspfillcur(XY);
% TD = locTC(loc,dists(XY,XY,2))
% h = pplot(XY,'r.');
% pplot(XY,num2cell(1:size(XY,1)))
% pplot({loc},XY,'g')

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,2);
if nargin < 2, k = []; end
if size(XY,2) ~= 2, error('XY must be a 2-column matrix.'), end
% End (Input Error Checking) **********************************************

[~,loc] = sort(sfcpos(XY(:,1),XY(:,2),k));
i1 = find(loc == 1);
loc = [loc([i1:end 1:i1-1])' 1];  % Make vertex 1 first in loc seq
