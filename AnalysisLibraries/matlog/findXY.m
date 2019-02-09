function idx = findXY(XY,xy1xy2)
%FINDXY Find XY points inside rectangle.
%   idx = findXY(XY,xy1xy2)
%       = findXY(XY)          Graphical selection of rectangle
%xy1xy2 = rectangle
%       = [min(X) min(Y); max(X) max(Y)]
%
% Graphical selection of rectangle:
%    (1) Press <SPACEBAR> or select point outside axes to toggle zoom
%    (2) Press <ESC> key to erase last points selected
%    (3) Press <RETURN> to stop selecting points
%    (4) Use 'Erase Iter Plot' on Matlog figure menu to erase green circles
%        around selected points (or 'delete(findobj('Tag','iterplot'))')
%
% Note: Wrapper for idx = FIND(ISINRECT(XY,xy1xy2))

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
% End (Input Error Checking) **********************************************

if nargin > 1 && ~isempty(xy1xy2)
   idx = find(isinrect(XY,xy1xy2));
else
   idx = [];
   done = 0;
   h = [];
   disp('Press <SPACEBAR> to zoom, <ESC> to erase, and <RETURN> to stop')
   while ~done
      isin = isinrect(XY);
      if islogical(isin) && any(isin)
         cidx = find(isin(:));
         h = pplot(XY(cidx,:),'go','Tag','iterplot');
         drawnow
         idx = [idx; cidx];
      elseif ~isempty(isin) && isin == 32   % SPACEBAR to toggle zoom
         zoom
      elseif ~isempty(isin) && isin == 27 && ishandle(h) % ESC key to erase
         idx = setdiff(idx,cidx);
         delete(h)
         drawnow
      elseif ~isempty(isin) && isin == 13   % RETURN key to exit
         idx = sort(idx);
         done = 1;
      end
   end
end


