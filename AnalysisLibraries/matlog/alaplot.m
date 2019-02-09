function alaplot(X,W,P,titlestr)
%ALAPLOT Plot ALA iterations.
%  alaplot(X,W,P)
%
% Example: Plot final results from ALA
% P = [0 0;2 0;2 3], w = [1 2 1]
% [X,TC,W] = ala(2,w,P,2)
% pplot
% alaplot(X,W,P)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(3,4)

if size(X,2) ~= size(P,2)
   error('X and P not the same dimension.')
elseif ~isempty(W) && (size(X,1) ~= size(W,1))
   error('X and W must have the same number of rows.')
elseif ~isempty(W) && (size(P,1) ~= size(W,2))
   error('Number of rows in P must equal the number of columns in W.')
end
% End (Input Error Checking) **********************************************

if isempty(findobj('Type','figure')) || ...
      ~strcmp(get(gcf,'Tag'),'Matlog Figure')
   return
end

delete(findobj(gcf,'Tag','alaplot'))
if nargin > 2 && ~isempty(W)
   pplot(lev2list(W),[X;P],'g-','Tag','alaplot');
end
pplot(P,'r.','Tag','alaplot');
pplot(X,'kv','Tag','alaplot')
pplot(X,num2cell(1:size(X,1)),'Tag','alaplot')
if nargin > 3, title(titlestr), end
pauseplot


