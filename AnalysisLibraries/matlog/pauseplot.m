function ptout = pauseplot(pt,pt2)
%PAUSEPLOT Drawnow and then pause after plotting.
%    pauseplot(pt),         drawnow and pause for 'pt' seconds (if current
%                           figure UserData is empty)
%    pauseplot,             drawnow and pause using 'pt' from current
%                           figure's UserData (set 'pt' to 0 if empty)
%    pauseplot('set'),      prompt user to input 'pt' into UserData
%                           without drawnow and pause
%    pauseplot('set',pt),   input 'pt' into UserData without drawnow and
%                           pause
%    pt = pauseplot('get'), get 'pt' from UserData without drawnow & pause
%    pt = pause time (in seconds)
%       = Inf, to pause until any key is pressed
%    pt = [], returned if input canceled or invalid 'pt' value in UserData
%
% Calls DRAWNOW followed by PAUSE(pt)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
sget = [];
currentpt = [];
if nargin == 1 && ~ischar(pt), currentpt = pauseplot('get'); end
if nargin > 0 && ischar(pt)
   sget = pt;
   if nargin > 1, pt = pt2; else pt = []; end
end
if nargin == 0
   if isempty(findobj('Type','figure'))
      error('No figure found to get "pt".')
   end
   pt = get(gcf,'UserData');
   if isempty(pt), pt = 0; pauseplot('set',pt), end
end

if ~isempty(sget) && ~any(strcmpi(sget,{'set','get'}))
   error('Argument string must be "set" or "get".')
elseif ~isempty(sget) && isempty(findobj('Type','figure'))
   error('No figure found to use with "set" or "get".')
elseif (strcmpi(sget,{'get'}) && nargout < 1) || ...
      (~strcmpi(sget,{'get'}) && nargout > 0)
   error('Output argument specified only when using "get" option.')
elseif ~isempty(pt) && (~isreal(pt) || length(pt(:)) ~= 1 || pt < 0)
   error('"pt" must be a nonnegative real number.')
end
% End (Input Error Checking) **********************************************

prompt = ...
   'Pause time between plots (sec) (= Inf, to wait for key press) : ';
title = 'Plot Pause Time';

if ~isempty(sget)   % Only get or set pause time
   if strcmpi(sget,{'get'})
      pt = [];
      if ~isempty(findobj('Type','figure'))
         pt = get(gcf,'UserData');
         if ~isempty(pt) && (~isreal(pt) || length(pt(:)) ~= 1 || pt < 0)
            pt = [];
         end
      end
      ptout = pt;
   elseif nargin > 1
      set(gcf,'UserData',pt)
   else
      def = pauseplot('get');
      if ~isempty(def), def = num2str(def); else def = ''; end
      done = 0;
      while ~done
         pt = inputdlg(prompt,title,1,{def}); % pt = {''}, if empty OK
         % pt = {},   if Cancel
         if isempty(pt) % Cancel
            done = 1;
         else
            pt = pt{:};
            if strcmp('',pt), pt =[]; else pt = str2double(pt); end
            if isempty(pt) || (isreal(pt) && length(pt(:)) == 1 && pt >= 0)
               set(gcf,'UserData',pt)
               done = 1;
            else
               beep
            end
         end
      end % End WHILE
   end
elseif isempty(currentpt)  % Drawnow and pause
   drawnow
   if isinf(pt)
      str = get(get(gca,'XLabel'),'String');
      set(get(gca,'XLabel'),'String','Press any key to continue ...')
      shg
      pause
      set(get(gca,'XLabel'),'String',str)
   else
      pause(pt)
   end

end
