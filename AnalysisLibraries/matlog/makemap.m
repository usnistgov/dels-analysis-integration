function h = makemap(region,expand)
%MAKEMAP Create projection plot of World or US.
%     h = makemap(region)
%       = makemap(XY,expand)
%region = 'World', (default) world coastline and international borders
%       = 'US', United States coastline and state and international borders
%       = 'NC', North Carolina state border
%    XY = longitude-latitude pairs (in decimal degrees) used to fix axes
%         limits by calling BOUNDRECT(XY,expand) to get bounding rectangle
%expand = nonnegative expansion factor for bounding rectangle (if XY input)
%       = 0.10, default
%     h = handle of line objects created
%  h(1) = coastlines
%  h(2) = international borders
%  h(3) = (World) arctic (66.5) and antarctic (-66.5) circles and tropics
%         of Cancer (23.5) and Capricorn (-23.5) parallels
%       = (US) State borders
%
% Calls MAPDATA to get map data

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if nargin < 1 || isempty(region), region = 'World'; end

if (~ischar(region) && ~isnumeric(region)) || iscell(region)
   error('Argument "region" must be a string or matrix XY.')
end
if ischar(region)
%    region = strmatch(lower(region),{'world','us','nc'});
   region = find(strcmpi(region,{'world','us','nc'}));
   if isempty(region)
      error('Argument "region" must be a string "World" or "US" or "NC".')
   elseif nargin > 1
      error('Argument "expand" only used with XY.')
   elseif exist('mapdata.mat','file') ~= 2
      error('Data file "mapdata.mat" not found');
   end
   XY = [];
else
   XY = region;
   if nargin < 2 || isempty(expand), expand = 0.10; end
end
% End (Input Error Checking) **********************************************

if ~isempty(XY)
   if all(isinrect(XY,[-125 14.9; -65 53.61]))
      region = 2;
   else
      region = 1;
   end
end

pplot('proj')

if region == 1
   World = mapdata('World');
   hh = [pplot(World.XYC,' ','DisplayName','World Coastlines'); ...
         pplot(World.XYB,':','DisplayName','World Int Borders')];
   xlim = [-180 180];
   set(gca,'XLim',xlim);
   grid on
   hh = [hh; pplot([nan nan;xlim(1) 23.5;xlim(2) 23.5;...
             nan nan;xlim(1) -23.5;xlim(2) -23.5;...
             nan nan;xlim(1) 66.5;xlim(2) 66.5;...
             nan nan;xlim(1) -66.5;xlim(2) -66.5],'r:', ...
             'DisplayName','World Artic and Tropic')];
elseif region == 2
   US = mapdata('US');
   hh = [pplot(US.XYC,' ','DisplayName','US Coastlines'); ...
         pplot(US.XYB,' ','DisplayName','US Int Borders'); ...
         pplot(US.XYS,':','DisplayName','US State Borders')];
elseif region == 3
   NC = mapdata('NC');
   hh = pplot(NC.XYS,' ','DisplayName','NC State Border');
end

if ~isempty(XY)
   xy1xy2 = boundrect(XY,expand);
   xy1xy2(xy1xy2(:,1) < -180,1) = -180;
   xy1xy2(xy1xy2(:,1) > 180,1) = 180;
   xy1xy2(xy1xy2(:,2) < -90,2) = -90;
   xy1xy2(xy1xy2(:,2) > 90,2) = 90;
   xy1xy2(proj(xy1xy2(:,2)) < -90,2) = min(XY(:,2));  % Use min/max lat b/c
   xy1xy2(proj(xy1xy2(:,2)) > 90,2) = max(XY(:,2));   % proj(-90/90) blows up
   brXY = proj(xy1xy2);
   axis(brXY(:))
   projtick
end

% Set Maximum X,Y Limits for PPLOT border
s = get(gca,'UserData');
if isstruct(s) && isfield(s,'MaxXYLim')
   s.MaxXYLim = [get(gca,'XLim')' get(gca,'YLim')'];
   set(gca,'UserData',s)
end

% Set PROJTICK as callback on zoom
hzoom = zoom;
set(hzoom,'ActionPostCallback',@projtickcallback)

if nargout > 0, h = hh; end


% *************************************************************************
% *************************************************************************
% *************************************************************************
function projtickcallback(src,eventdata)
% PROJTICK as callback.
projtick;
