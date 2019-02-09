function [IJC,idxIJC] = thin(IJC)
%THIN Thin degree-two nodes from graph.
% [tIJC,idxIJC] = thin(IJC)
%   IJC = n-row matrix arc list of original graph
%  tIJC = tn-row matrix arc list of thinned graph
%idxIJC = tn-element cell array, where idxIJC{i} is an index array of arcs 
%         in IJC that comprise arc [tIJC(i,1) tIJC(i,2)]
%
% Note: Any directed arcs in IJC are converted to undirected arcs.
%       Returns empty tIJC if all of the nodes are thinned.
%
% Examples:
% % 9-node graph
% XY = [3 5; 2 4; 5 4; 4 3; 0 4; 0 2; 2 2; 4 2; 3 1];
% IJC = [1 -2 12; 1 -3 13; 2 -4 24; 3 -4 34; 2 -5 25; 4 -5 45; 2 -6 26;
%        5 -7 57; 6 -7 67; 4 -8 48; 5 -8 58; 7 -9 79; 8 -9 89]
% [tIJC,idxIJC] = thin(IJC);
% tIJC, idxIJC{:}
% pplot
% pplot(tIJC,XY,'y-','LineWidth',4)
% pplot(XY,'b.')
% pplot(IJC,XY,'b-')
% pplot(XY,'NumNode')
% [tXY,stIJC] = subgraph(XY,[],tIJC)          % Determine thinned XY and 
%                                             % re-number nodes in tIJC
% pplot(tXY,'NumNode','MarkerEdgeColor','r')  % Re-label nodes in plot
%
% % Thin North Carolina Interstate highways
% [XY,IJD]=subgraph(usrdnode('XY'),usrdnode('NodeFIPS')==37,...
%      usrdlink('IJD'),usrdlink('Type')=='I');
% [tIJD,idxIJD] = thin(IJD);
% makemap(XY)
% pplot(tIJD,XY,'y-','LineWidth',3)
% pplot(IJD,XY,'r-')
% [tXY,stIJD] = subgraph(XY,[],tIJD)  % Determine thinned XY and 
%                                     % re-number nodes in tIJD

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if size(IJC,2) < 2
   error('IJC must be at least a two-column matrix.')
end
% End (Input Error Checking) **********************************************

IJCin = IJC;  % Keep input IJC in case not changed
IJC = [IJC(:,1) -abs([IJC(:,2)]) IJC(:,3)];  % Make all arcs symmetric
A = list2adj(IJC);

if nargout > 1
   A1 = list2adj([IJC(:,[1 2]) (1:size(IJC,1))']);
   A2 = sparse(length(A),length(A));
   n2 = 0;
end

i = find(sum(A>0) == 2);
dothin = false;  % dothin = false;
done = false;
while ~isempty(i) && ~done
   for j = 1:length(i)
      
      k = find(A(i(j),:) > 0);  % Only two found since node is degree two
      
      if length(k) ~= 2         % All nodes in graph are thinned
         done = true;
         continue
      end
      
      if A(k(1),k(2)) == 0 || ...  % No old arc [k(1) k(2)]
            A(i(j),k(1)) + A(i(j),k(2)) < A(k(1),k(2))  % New less than old
         
         A(k(1),k(2)) = A(i(j),k(1)) + A(i(j),k(2));
         A(k(2),k(1)) = A(i(j),k(1)) + A(i(j),k(2));
         dothin = true;  % dothin = true;
         
         if nargout > 1
            A1(k(1),k(2)) = 0; A1(k(2),k(1)) = 0;
            if A2(k(1),k(2)) == 0
               n2 = n2 + 1;
               A2(k(1),k(2)) = n2; A2(k(2),k(1)) = n2;
               idx2{n2} = [];
            end
            if A1(i(j),k(1)) ~= 0
               idx2{A2(k(1),k(2))} = [idx2{A2(k(1),k(2))} A1(i(j),k(1))];
               A1(i(j),k(1)) = 0; A1(k(1),i(j)) = 0;
            else
               idx2{A2(k(1),k(2))} = [idx2{A2(k(1),k(2))} ...
                     idx2{A2(i(j),k(1))}];
               A2(i(j),k(1)) = 0; A2(k(1),i(j)) = 0;
            end
            if A1(i(j),k(2)) ~= 0
               idx2{A2(k(1),k(2))} = [idx2{A2(k(1),k(2))} A1(i(j),k(2))];
               A1(i(j),k(2)) = 0; A1(k(2),i(j)) = 0;
            else
               idx2{A2(k(1),k(2))} = [idx2{A2(k(1),k(2))} ...
                     idx2{A2(i(j),k(2))}];
               A2(i(j),k(2)) = 0; A2(k(2),i(j)) = 0;
            end
         end
         
      elseif nargout > 1  % Keep existing arc [k(1) k(2)] 
         A1(i(j),k(1)) = 0; A1(k(1),i(j)) = 0;
         A1(i(j),k(2)) = 0; A1(k(2),i(j)) = 0;
         
         A2(i(j),k(1)) = 0; A2(k(1),i(j)) = 0;
         A2(i(j),k(2)) = 0; A2(k(2),i(j)) = 0;
      end
      
      A(i(j),k(1)) = 0; A(k(1),i(j)) = 0;
      A(i(j),k(2)) = 0; A(k(2),i(j)) = 0;
   end
   
   i = find(sum(A>0) == 2);
end

if dothin
   IJC = adj2list(A);
else
   IJC = IJCin;        % Keep input order if IJC not changed
end

if nargout > 1 && exist('idx2','var')
   IJ12 = adj2list(-A1 + A2);
   idxIJC = num2cell(abs(IJ12(:,3)));
   idxIJC(IJ12(:,3)>0) = idx2(IJ12(IJ12(:,3)>0,3));
else
   idxIJC = {};
end
