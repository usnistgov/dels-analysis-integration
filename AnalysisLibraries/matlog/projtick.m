function out = projtick(h)
%PROJTICK Project tick marks on projected axes.
%   out = projtick(h)
%     h = axes handle
%       = current axes, default
%   out = 1, ticks projected, if axes created using PPLOT('proj')
%       = 0, otherwise

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if nargin < 1 || isempty(h)
   if isempty(findobj('Type','axes'))
      if nargout > 0, out = 0; end
      return
   end
   h = gca;
elseif ishandle(h) && ~strcmp(get(h,'Type'),'axes')
   error('"h" must be an axes handle.')
end
% End (Input Error Checking) **********************************************

% Return if ticks turned off or axes not 'proj'
if isempty(get(h,'XTick')) && isempty(get(h,'YTick')) || ...
      ~strcmpi(get(h,'Tag'),'proj')
   if nargout > 0, out = 0; end
   return
end

% Reset to auto to get new ticks
set(h,'XTickLabelMode','auto','XTickMode','auto',...
   'YTickLabelMode','auto','YTickMode','auto')

ylim = invproj(get(h,'YLim')');
ymin = ylim(1); ymax = ylim(2);
pytick = get(h,'YTick');
if length(pytick) < 2
   error('Need at least two tick marks for projection.')
end
tickstep = abs(pytick(2)-pytick(1));
if tickstep > 30, tickstep = tickstep/2; end

if ymin >= 0		% All latitudes in northern hemisphere
   yticklab = [fliplr(pytick(1):-tickstep:ymin) pytick(2):tickstep:ymax];
elseif ymax < 0	% All latitudes in southern hemisphere
   yticklab = [fliplr(pytick(end-1):-tickstep:ymin) ...
         pytick(end):tickstep:ymax];
else					% Range of latitudes cross the Equator
   yticklab = [fliplr(0:-tickstep:ymin) tickstep:tickstep:ymax];
end

set(h,'YTickLabel',yticklab,'YTick',proj(yticklab'))

if nargout > 0, out = 1; end


