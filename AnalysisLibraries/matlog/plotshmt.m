function hout = plotshmt(sh,XY,rte,tr,doproj,maxlab)
%PLOTSHMT Plot shipments.
% h = plotshmt(sh,XY,rte,tr,doproj,maxlab)
%    sh = structure array with fields:
%        .b     = beginning location of shipment
%        .e     = ending location of shipment
%        .isLTL = (optional) true if LTL used for independent shipment
%    XY = 2-column matrix of location lon-lat (in decimal deg)
%   rte = (optional) route vector
%       = m-element cell array of m route vectors
%    tr = (optional) structure with fields:
%        .b = beginning location of truck = sh(rte(1)).b, default
%        .e = ending location of truck = sh(rte(end)).e, default
%doproj = (optional) do projection using MAKEMAP
%       = true, default
%maxlab = maximum characters on each L/U side of arc label
%       = 6, default
%     h = [hTL hLTL hRte] = handles

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(2,6)

if nargin < 3, rte = []; end
if nargin < 4, tr = []; end
if nargin < 5 || isempty(doproj), doproj = true; end
if nargin < 6 || isempty(maxlab), maxlab = 6; end

if ~isempty(rte) && ~iscell(rte), rte = {rte}; end
checkrte(rte,sh)
if ~isfield(sh,'b') || ~isfield(sh,'e')
   error('Required field(s) missing in shipment structure.')
elseif max([[sh.b] [sh.e]]) > size(XY,1)
   error('Shipment location exceeds number of rows in lon-lat matrix.')
end
% End (Input Error Checking) **********************************************

rgbTL  = [0 .8 0];
rgbLTL = [0 .8 1];
rgbrte = [.8 0 1];
rgbXY  = 'r';

% Begin route-only plot
persistent hrte hXY

isfh = false;
if ~isempty(rte)
   s = dbstack;
   if length(s) > 1 && isempty(s(2).file), isfh = true; end
   if ~isempty(hrte)
      if ishandle(hrte) && isequal(gca,get(hrte,'Parent'))
         delete(hrte), delete(hXY)
      else
         hrte = []; hXY = [];
      end
   end
end

if isempty(hrte)
   if doproj, makemap(XY(unique([[sh.b] [sh.e]]),:)), else pplot, end
end

if isfh
   loc = rte2loc(rte,sh,tr);
   if isempty(hrte), hXY = pplot(XY,'r.'); pauseplot(Inf), end
   hrte = pplot(loc,XY,'-','Color',rgbrte);
   hXY = pplot(XY,'r.');
   pauseplot
   return
end
% End route-only plot

if isfield(tr,'b')||isfield(tr,'e'),istrloc = true;else istrloc = false;end

idxTL = []; idxMRte = [];
if isempty(rte)
   idxTL = 1:length(sh);
   idxXY = idxTL;
   rte = num2cell([idxTL(:) idxTL(:)],2);
else
   idxXY = rte2idx(rte);
   if istrloc
      idxMRte = 1:length(rte);
   else
      idxMRte = find(cellfun('length',rte) > 2);
      idxTL = setdiff([idxXY{:}],[idxXY{idxMRte}]);
   end
   idxXY = [idxXY{:}];
end
if isfield(sh,'isLTL')
   idxLTL = idxTL([sh(idxTL).isLTL]);
   idxTL = setdiff(idxTL,idxLTL);
else
   idxLTL = [];
end

hTL = [];
if ~isempty(idxTL)
   hTL = pplot([[sh(idxTL).b]' [sh(idxTL).e]'],XY,'-',...
      'Color',rgbTL,'DisplayName','TL');
end
hLTL = [];
if ~isempty(idxLTL)
   hLTL = pplot([[sh(idxLTL).b]' [sh(idxLTL).e]'],XY,'-',...
      'Color',rgbLTL,'DisplayName','LTL');
end
hRte = [];
if ~isempty(idxMRte)
   loc = rte2loc(rte(idxMRte),sh,tr);
   lnstyle = {'-.','-',':','--'};
   rtelab = cellstr(strcat('Rte',strjust(num2str(idxMRte(:)),'left')));
   for i = 1:length(loc)
      if all(diff(loc{i})==0), continue, end
      hRte(i) = pplot(loc(i),XY,lnstyle{mod(i,4)+1},...
         'Color',rgbrte,'DisplayName',rtelab{i});
   end
end

h = [hTL hLTL hRte];
if length(h) > 1, legend([hTL hLTL hRte]), end

pplot(XY(unique([[sh(idxXY).b] [sh(idxXY).e]]),:),'.',...
   'Color',rgbXY,'DisplayName','XY Location')

for i = 1:length(rte)
   [loc,lab] = getloclab(rte{i},rte2loc(rte{i},sh),XY,maxlab);
%    if ~isempty(lab), pplot({loc},lab,XY,'Tag','Route Label'), end
   pplot({loc},lab,XY,'DisplayName','Route Label')  % Add in R2008a
end

if nargout > 0, hout = h; end


% *************************************************************************
% *************************************************************************
% *************************************************************************
function [loc,lab] = getloclab(rte,loc,XY,maxlab)
%Determine location sequence and labels for route.

if all(diff(loc)==0), lab = []; return, end

idx = 1:length(loc);
idx = [idx([1 diff(loc)]~=0) length(loc)+1];
loc = loc(idx(1:end-1));

isO = isorigin(rte);
for i = 1:length(idx)-2
   rL = rte(idx(i):idx(i+1)-1);
   L = arclab(rL(isO(idx(i):idx(i+1)-1)),maxlab);
   rU = rte(idx(i+1):idx(i+2)-1);
   U = arclab(rU(~isO(idx(i+1):idx(i+2)-1)),maxlab);
   if isempty(L) && isempty(U)
      lab{i} = '';
   else
      ang = arcang(XY(loc(i),:),XY(loc(i+1),:));
      if ang < 90 && ang >= -90
         lab{i} = [L '>' U];
      else
         lab{i} = [U '<' L];
      end
   end
end



% *************************************************************************
% *************************************************************************
% *************************************************************************
function lab = arclab(r,maxlab)
%Create label for arc.

if isempty(r), lab = []; return, end
r = abs(r);
sr = sort(r);
idx  = find([1 diff(sr)~=1 1]);
if length(idx)-1 < length(r), r = sr; end  % Use sorted for range of values
lab = [];
for i = 1:length(idx)-1
   ri = [r(idx(i)):r(idx(i+1)-1)];
   lab = [lab num2str(ri(1))];
   if length(ri) > 2
      lab = [lab '-' num2str(ri(end))];
   elseif length(ri) == 2
      lab = [lab ',' num2str(ri(end))];
   end
   if i < length(idx)-1, lab = [lab ',']; end
end
if length(lab) > maxlab, lab = []; end


