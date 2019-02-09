function [TCout,aout] = sdpi(W,D,a0,C,XY)
%SDPI Steepest Descent Pairwise Interchange Heuristic for QAP.
% [TC,a] = sdpi(W,D,a0,C,XY)
%      m = number of machines and sites
%      W = m x m machine-machine weight matrix
%      D = m x m site-site distance matrix
%     a0 = m-element initial assignment vector (optional)
%        = [], generate random initial assignment using RANDPERM(m)
%        = if 'a0' is scalar, then perform 'a0' different runs and report
%          best solution found
%      C = m x m machine-site fixed cost matrix (optional), where
%          C(i,j) is the fixed cost of assigning Machine i to Site j
%     XY = m x 2 matrix of 2-D site locations to generate plots (optional)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(2,5);

if nargin < 3 || isempty(a0), a0 = 1; end
if nargin < 4, C = []; end
if nargin < 5, XY = []; end

[m,cW] = size(W);
[rD,cD] = size(D);

if length(a0(:)) == 1, nruns = a0; a0 = []; else nruns = 1; end

if m ~= cW
   error('W must be a square matrix.')
elseif rD ~= cD
   error('D must be a square matrix.')
elseif m ~= rD
   error('W and D must be the same size.')
elseif ~isempty(a0) && (length(a0(:)) ~= m || any(sort(a0) ~= 1:m))
   error('a0 not a feasible assignment vector.')
elseif ~isempty(C) && any(size(C) ~= [m m])
   error('C must be m x m matrix.')
elseif ~isempty(XY) && any(size(XY) ~= [m 2])
   error('XY must be m x 2 matrix.')
end
% End (Input Error Checking) **********************************************

TC = Inf;

if ~isempty(XY)
   sdpiplot(XY), title(''), pauseplot(Inf)
   defpause = 1;
end

if nargout == 0 && nruns > 1, disp(' '), end

for k = 1:nruns
   
   TC0 = Inf;
   if isempty(a0), ak = randperm(m); else ak = a0; end
   TCk = sum(sum(W(ak,ak).*D));    % Initial TC
   
   if (nargout == 0 || ~isempty(XY)) && nruns == 1
      if isint(TCk), s = 'd'; else s = 'f'; end
      str1 = sprintf(['Initial TC = %' s],TCk);
      str2 = ['         a =' sprintf(' %d',ak)];
      if nargout == 0, fprintf('\n%s\n%s\n',str1,str2), end
      if ~isempty(XY)
         sdpiplot(XY,W,ak), title(str1), pauseplot(defpause)
      end
   end
   
   while TCk < TC0
      TC0 = TCk;
      a0k = ak;
      for i = 1:m-1
         for j = i+1:m
            aij = a0k;
            aij([j i]) = aij([i j]);
            if isempty(C)
               TCij = sum(sum(W(aij,aij).*D));
            else
               D = D + diag(diag(ones(m)));
               TCij = sum(sum((W(aij,aij) + diag(diag(C(aij,:)))) .* D));
            end
            
            if TCij < TCk
               TCk = TCij;
               ak = aij;
               ik = i; jk = j;
            end
         end
      end
      
      if ~isequal(a0k,ak)
         if (nargout == 0 || ~isempty(XY)) && nruns == 1
            if isint(TCk), s = 'd'; else s = 'f'; end
            str1 = sprintf(['Interchange %d and %d: TC = %' s],jk,ik,TCk);
            str2 = ['         a =' sprintf(' %d',ak)];
            if nargout == 0, fprintf('%s\n%s\n',str1,str2), end
            if ~isempty(XY)
               sdpiplot(XY,W,ak), title(str1), pauseplot(defpause)
            end
         end
         if TCk < TC && nruns > 1 && ~isempty(XY)
            sdpiplot(XY,W,ak)
            title(['Min TC = ',num2str(TCk)])
            pauseplot(defpause)
         end
      end
      
   end % End WHILE (One Run)
   
   if nargout == 0
      if isint(TCk), s = 'd'; else s = 'f'; end
      if nruns == 1
         disp([sprintf(['Final   TC = %' s '\n         a ='],TCk) ...
               sprintf(' %d',ak)])
         disp(' ')
      else
         disp([sprintf(['Run %d: Min TC = %' s '\n            a = '],...
               k,TCk) sprintf(' %d',ak)])
         TCsave(k) = TCk;
      end
   end
   if TCk < TC
      TC = TCk;
      a = ak;
   end
   
end %End FOR (All Runs)

if nargout == 0 && nruns > 1
   nTC = sum(TCsave == TC);
   TCpercent = round(100*(nTC/nruns));
   if isint(TC), s = 'd'; else s = 'f'; end
   disp([sprintf(['\nMin TC = %' s ...
            '   (Found in %d of %d runs (%d%%))\n     a ='], ...
         TC,nTC,nruns,TCpercent) sprintf(' %d',a)]), disp(' ')
end
if nargout > 0
   TCout = TC;
   aout = a;
end


% *************************************************************************
% *************************************************************************
% SDPIPLOT Plot results ***************************************************
function sdpiplot(XY,W,a)

m = size(XY,1);
if nargin < 3 || isempty(a), a = 1:m; end
if nargin < 2, W = []; end

h = findobj('Tag','sdpiplot');
if isempty(h)
   pplot
else
   delete(h)
end
D = dists(XY,XY);
s = max(.1*max(max(D)), min(D(~is0(D))));
s = s/4;

if ~isempty(W)
   [i,j,w] = adj2list(triu(W+W'));
   w = 0.5 + 18*(w-min(w))/(max(w)-min(w));
   for k = 1:length(w)
      pplot([i(k) j(k)],XY(invperm(a),:),'r-','LineWidth',w(k),...
         'Tag','sdpiplot');
   end
end

X = XY(:,1)'; Y = XY(:,2)';
fill([X-s;X+s;X+s;X-s],[Y-s;Y-s;Y+s;Y+s],a,'Tag','sdpiplot');
pplot(XY,'ko','MarkerSize',9,'MarkerFaceColor','w','Tag','sdpiplot');
pplot(XY,num2cell(1:m),'FontSize',7,'Horiz','center','Vert','middle',...
   'Tag','sdpiplot');
pplot(XY+s/2,num2cell(a),'FontSize',11,'FontWeight','bold',...
   'Color',[.1 1 1],...
   'Hori','left','Vert','middle','Tag','sdpiplot');
