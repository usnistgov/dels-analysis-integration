function [idx1,idx2,idx3] = loc2listidx(loc,IJC1,IJC2,IJC3)
%LOC2LISTIDX Find indices of loc seq segments in arc list.
%             idx = loc2listidx(loc,IJC)            % Single arc list
%     [idx1,idx2] = loc2listidx(loc,IJC1,IJC2)      % Multipart arc lists
%[idx1,idx2,idx3] = loc2listidx(loc,IJC1,IJC2,IJC3)
%   loc = vector of single-seq vertices
%   IJC = n-row matrix arc list
%       = [IJC1; IJC2; IJC3], arc list composed of up to 3 separate parts
%   idx = index vector of rows in IJC, where idx(1) is arc IJC(idx(1),:)
%         corresponding to first segment [loc(1) loc(2)] of loc seq
%  idx1 = index vector of rows in IJC1
%  idx2 = index vector of rows in IJC2 offset by size(IJC1,1)
%  idx3 = index vector of rows in IJC3 offset by size([IJC1; IJC2],1)
%
% Use of a multipart arc list allows reference to be made to the
% original arc lists (e.g., in the label roads example, the "LinkTag" is
% refinded with respect to the original list IJD, not IJD2).
%
% Examples:
% % 4-node graph
% XY = [0 0; 1 1; 1 -1; 2 0];
% IJC = [1 2 12; 1 3 13; 2 4 24; 3 4 34];
% loc = [1 2 4];
% idx = loc2listidx(loc,IJC)                 % idx = 1  3
%
% % Label roads along shortest loc seq from Fayetteville to Raleigh
% xy1xy2 = [-79 35; -78 36];
% [XY,IJD,isXY,isIJD] = subgraph(usrdnode('XY'),...
%    isinrect(usrdnode('XY'),xy1xy2),usrdlink('IJD'));
% s = usrdlink(isIJD);
% [Name,XYcity] = uscity50k('Name','XY',isinrect(uscity50k('XY'),xy1xy2));
% [IJD11,IJD12,IJD22] = addconnector(XYcity,XY,IJD);
% makemap(XY)
% pplot([IJD11; IJD12; IJD22],[XYcity; XY],'r-')
% pplot(XYcity,'b.')
% pplot(XYcity,Name)
% idxFay = strmatch('Fayetteville',Name);
% idxRal = strmatch('Raleigh',Name);
% [d,loc] = dijk(list2adj([IJD11; IJD12; IJD22]),idxFay,idxRal);
% [idx11,idx12,idx22] = loc2listidx(loc,IJD11,IJD12,IJD22);
% pplot({loc},[XYcity; XY],'y-','Linewidth',2)
% isEndTag = any(diff(double(s.LinkTag(idx22,:)),1,1)')'; % Don't use
% isEndTag = [[isEndTag; 0] | [0; isEndTag]];             % repeated tags
% pplot(IJD(idx22(isEndTag),:),cellstr(s.LinkTag(idx22(isEndTag),:)),XY)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(2,4)

if nargout + 1 ~= nargin
   error('Number of output arguments must equal number of arc lists.')
end

if nargin < 4, IJC3 = []; n3 = 0; else n3 = size(IJC3,1); end
if nargin < 3, IJC2 = []; n2 = 0; else n2 = size(IJC2,1); end
n1 = size(IJC1,1);

try
   if ~isempty(IJC2)
      if ~isempty(IJC1)
         IJC1 = [IJC1(:,[1 2]); IJC2(:,[1 2])];
      else
         IJC1 = IJC2(:,[1 2]);
      end
   end
   if ~isempty(IJC3)
      if ~isempty(IJC1)
         IJC1 = [IJC1(:,[1 2]); IJC3(:,[1 2])];
      else
         IJC1 = IJC3(:,[1 2]);
      end
   end
   A = list2adj([IJC1(:,[1 2]) (1:n1+n2+n3)']);
catch
   error('Incorrect arc lists input.')
end

loc = loc(:);
if ~isreal(loc) || any(loc < 1 | loc > length(A))
   error('"loc" not a valid loc seq.')
end
% End (Input Error Checking) **********************************************

Ar = list2adj([loc(1:end-1) loc(2:end) (1:length(loc)-1)'],length(A));

if any(any(Ar~=0 & A==0))
   error('Segment of loc seq not in arc list.')
end

A(Ar == 0) = 0;
IJCA = adj2list(A);
IJCr = adj2list(Ar);
idx1 = IJCA(invperm(IJCr(:,3)),3)';

if nargout > 2
   idx3 = idx1(idx1 > n1+n2) - (n1+n2);
   idx1(idx1 > n1+n2) = [];
end
if nargout > 1
   idx2 = idx1(idx1 > n1) - n1;
   idx1(idx1 > n1) = [];
end
