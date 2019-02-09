function xy1xy2 = grect
%GRECT Get rectangular region in current axes.
%  xy1xy2 = grect
%  xy1xy2 = [min(X) min(Y); max(X) max(Y)]
%
% In order to support the features of FINDXY: 
%    if key pressed instead of mouse button, then decimal current character
%       is returned;
%    if first point selected is outside axes, then empty return and zoom
%       state is toggled;
%    if second point selected is outside axes, then empty return

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
% End (Input Error Checking) **********************************************

k = waitforbuttonpress; 
if k == 1                                % keyboard button pressed
   xy1xy2 = double(get(gcf,'CurrentCharacter'));
else  
   
   xy1 = get(gca,'CurrentPoint');        % button down detected
   
   if ~isinrect(xy1,[get(gca,'XLim')' get(gca,'YLim')'])
      zoom                               % toggle zoom    
      xy1xy2 = [];
   elseif ~strcmp(getappdata(gcf,'ZoomOnState'),'on')
      %zoom off
      finalRect = rbbox;                 % return figure units
      xy2 = get(gca,'CurrentPoint');     % button up detected
      
      if ~isinrect(xy2,[get(gca,'XLim')' get(gca,'YLim')'])
         xy1xy2 = [];
      else
         xy1 = xy1(1,1:2); 				  % extract x and y
         xy2 = xy2(1,1:2);
         x1 = min(xy1(1),xy2(1));
         y1 = min(xy1(2),xy2(2));
         x2 = x1 + abs(xy1(1) - xy2(1));
         y2 = y1 + abs(xy1(2) - xy2(2));
         xy1xy2 = [x1 y1; x2 y2];
         
         if strcmp(get(gca,'Tag'),'proj')
            xy1xy2 = invproj(normlonlat(xy1xy2));
         end
      end
   else 
      xy1xy2 = [];
   end
end
