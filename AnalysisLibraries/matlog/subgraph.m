function [XY,IJC,isXY,isIJC] = subgraph(XY,isXY,IJC,isIJC)
%SUBGRAPH Create subgraph from graph.
% [sXY,sIJC,sisXY,sisIJC] = subgraph(XY,isXY,IJC,isIJC)
%                 psisIJC = subgraph(XY,isXY,IJC)        % Partial arcs
%    XY = m x 2 matrix of node coordinates
%  isXY = m-element logical vector of node subgraph elements
%   IJC = n-row matrix arc list
% isIJC = n-element logical vector of arc subgraph elements
%   sXY = nodes of subgraph
%  sIJC = arcs of subgraph (with endpoints renumbered to correspond to sXY)
% sisXY = m-element logical vector of node subgraph elements
%         (returns index vector if isXY is an index vector)
%sisIJC = n-element logical vector of arc subgraph elements
%         (returns index vector if isIJC is an index vector)
%pisIJC = logical vector of partial arc elements, if isIJC empty
%         ("partial arcs" are arcs with only one node in XY)
%
% Examples:
% % 7-node graph
% XY = [0  0
%       1  1
%       1 -1
%       2  0
%       3  1
%       3 -1
%       4  0]
% IJC = [1 -2 12
%        1 -3 13
%        2 -4 24
%        2 -5 25
%        3 -4 34
%        3 -6 36
%        4 -5 45
%        4 -6 46
%        5 -7 57
%        6 -7 67]
% isXY = logical([0 1 1 1 1 1 0])'         % Nodes 2 through 6
% isIJC = logical([1 1 0 1 0 1 0 0 1 1])'  % Exterior arcs not connected to
%                                          % node 4
% [sXY,sIJC,sisXY,sisIJC] = subgraph(XY,isXY,IJC,isIJC)
% %     sXY =  1  1   
% %            1 -1                   
% %            3  1
% %            3 -1
% %    sIJC =  1 -3 25
% %            2 -4 36
% %  sisXY' =  0  1  1  0  1  1  0
% % sisIJC' =  0  0  0  1  0  1  0  0  0  0
%
% pisIJC = subgraph(XY,isXY,IJC)           
% % pisIJC' =  1  1  0  0  0  0  0  0  1  1   % Partial arcs
%
% % North Carolina (FIPS code 37) Interstate highways (Type 'I')
% [XY,IJD,isXY,isIJD]=subgraph(usrdnode('XY'),usrdnode('NodeFIPS')==37,...
%    usrdlink('IJD'),usrdlink('Type')=='I');
% s = usrdlink(isIJD);  % Link data structure
% makemap(XY)
% pplot(IJD,XY,'r-')

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(3,4);

if nargin < 4, isIJC = []; end

m = size(XY,1);
[n,cIJC] = size(IJC);

if cIJC < 2
   error('IJC must be at least a two-column matrix.')
elseif any(IJC(:,1) < 1 | IJC(:,1) > m | ...
      abs(IJC(:,2)) < 1 | abs(IJC(:,2)) > m)
   error('Node indices in IJC must be between 1 and "m".')
elseif ~isempty(isXY) && islogical(isXY) && length(isXY(:)) ~= m
   error('"isXY" must be an m-element logical vector.')
elseif ~isempty(isXY) && ~islogical(isXY) && (any(isXY < 1 | isXY > m))
   error('"isXY" not a valid index vector.')
elseif ~isempty(isIJC) && islogical(isIJC) && length(isIJC(:)) ~= n
   error('"isIJC" must be an n-element logical vector.')
elseif ~isempty(isIJC) && ~islogical(isIJC) && (any(isXIJC < 1 | isIJC > n))
   error('"isIJC" not a valid index vector.')
elseif nargout < 2 && ~isempty(isIJC)
   error('"isIJC" must be empty when determining partial arcs.')
end
% End (Input Error Checking) **********************************************

idxXY = false;  % idxXY = false;
if isempty(isXY)
   isXY = true(m,1);  % isXY = true(m,1);
elseif ~islogical(isXY)
   idxXY = true;  % idxXY = true;
   isXY = idx2is(isXY,m);
end
isXY = isXY(:);

idxIJC = false;  % idxIJC = false;
if isempty(isIJC)
   isIJC = true(n,1);  % isIJC = true(n,1);
elseif ~islogical(isIJC)
   idxIJC = true;  % idxIJC = true;
   isIJC = idx2is(isIJC,n);
end
isIJC = isIJC(:);

if nargout > 1  % Full arc subgraph

   isIJC = isIJC & idx2is(find(isXY(IJC(:,1)) & isXY(abs(IJC(:,2)))),n);
   isXY = isXY & idx2is(IJC(isIJC,1),m) | idx2is(abs(IJC(isIJC,2)),m);
   
   XY = XY(isXY,:);
   IJC = IJC(isIJC,:);
   k = sparse(find(isXY),1,1:sum(isXY));
   IJC(:,1) = k(IJC(:,1));
   IJC(:,2) = sign(IJC(:,2)) .* k(abs(IJC(:,2)));
   
   if idxXY, isXY = find(isXY); end
   if idxIJC, isIJC = find(isIJC); end
   
else  % Partial arcs
   XY = (isXY(IJC(:,1)) & ~isXY(abs(IJC(:,2)))) | ...  % XY = pisIJC
      (~isXY(IJC(:,1)) & isXY(abs(IJC(:,2))));
   if idxXY, XY = find(XY); end
end
