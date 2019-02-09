function hh = gantt(Bars,varargin)
%GANTT Gantt chart.
%     h = gantt(Bars)                                  % Plot activity bars
%       = gantt(Bars,'PropName',PropValue,...)         % Bar properties
%       = gantt(Bars,Labels)                           % Label each bar
%       = gantt(Bars,Labels,'PropName',PropValue,...)  % Label properties
%  Bars = m-element cell array, where Bars{i} = n x 2 matrix of n activity
%         bars for resource i and Bars{i}(j,1) and Bars{i}(j,2) are the 
%         beginning and ending times for activity j
%       = m x 2 matrix, if each resource has only one activity
%Labels = m-element cell array of bar labels
%     h = m-element cell array of handles to bar rectangles or labels
%
% Example:
% Bars = {[1 4]; [2 4; 5 6]; [1 2; 2 3]}
% Labels = {'bar1';{'bar2','bar3'};{'bar4','bar5'}}
% hbars = gantt(Bars)
% hlabels = gantt(Bars,Labels)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if ~iscell(Bars) && isnumeric(Bars)
   Bars = mat2cell(Bars,ones(size(Bars,1),1),size(Bars,2));
end
Bars = Bars(:);
Labels = {}; Prop = {};
if nargin > 1
   if ischar(varargin{1})
      Prop = varargin(1:end);
   else
      Labels = varargin{1}(:);
      if length(varargin) > 1, Prop = varargin(2:end); end
   end
end

if ~iscell(Bars) || any(cellfun('ndims',Bars) ~= 2) || ...
      any(cellfun('size',Bars,2) ~= 2) || ...
      ~all(cellfun('isclass',Bars,'double'))
   error('Error in Bars argument.')
elseif ~isempty(Labels) && (~iscell(Labels) || ...
      length(Labels) ~= length(Bars) || ...
      any(cellfun('length',Labels(~cellfun('isclass',Labels,'char'))) ~= ...
      cellfun('size',Bars(~cellfun('isclass',Labels,'char')),1)))
   error('Error in Labels argument.')
elseif ~isempty(Labels) && isempty(findobj('Tag','Gantt Bar'))
   error('Must first run GANTT(Bars) before GANTT(Lables).')
end
% End (Input Error Checking) **********************************************

xexpand = 0.05;  % Expand x axis by xexpand percent on both ends
yoffset = 0.4;   % Bar height 0.0 <= yoffset <= 0.5

defBarProp = {'FaceColor','w','Tag','Gantt Bar'};
defLabelProp = {'HorizontalAlignment','center','Tag','Gantt Label'};

if isempty(Labels)  % Draw Bars
   
   cax = newplot;   
   for i = 1:length(Bars)
      for j = 1:size(Bars{i},1)
         x = Bars{i}(j,1);
         y = length(Bars) - i + 1 - yoffset;
         ht = 2*yoffset;
         w = Bars{i}(j,2) - Bars{i}(j,1);
         if w <= 0, continue, end  % Skip if bar has nonpositive width
         h{i}(j,1) = rectangle('Pos',[x y w ht]);
         
         BarProp = {defBarProp{:},Prop{:}};
         set(h{i}(j),BarProp{:})
      end
   end
   
   set(gca,'YTick',1:length(Bars))
   set(gca,'YTickLabel',num2cell(length(Bars):-1:1))
   
   xlim0 = get(gca,'XLim');
   xoffset = xexpand * (xlim0(2) - xlim0(1));
   xlim = [xlim0(1) - xoffset xlim0(2) + xoffset];
   if xlim(1) < 0 && xlim0(1) >= 0
      xlim(1) = 0;
   end
   set(gca,'XLim',xlim);
      
else  % Draw Labels
   
   for i = 1:length(Bars)
      for j = 1:size(Bars{i},1)
         x = (Bars{i}(j,1) + Bars{i}(j,2))/2;
         y = length(Bars) - i + 1;
         if Bars{i}(j,2) - Bars{i}(j,1) <= 0, continue, end
         if ischar(Labels{i}), lab = Labels{i}; else lab = Labels{i}(j); end
         LabelProp = {defLabelProp{:},Prop{:}};
         h{i}(j,1) = text(x,y,lab,LabelProp{:});
      end
   end
   
end

if nargout > 0, hh = h'; end
