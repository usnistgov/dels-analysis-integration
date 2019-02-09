function h = pplot(varargin)
%PPLOT Projection plot.
%        h = pplot('proj',...) % Current and subsequent plots w/ projection
%          = pplot(XY)         % Plot lines and points
%          = pplot(XY,LineSpec)       
%          = pplot(XY,LineSpec,'PropName',PropValue,...)
%          = pplot(XY,Labels,'PropName',PropValue,...) % Label points XY
%          = pplot(XY,'NumNode',...)                   % Number nodes
%          = pplot(IJ,XY,...)  % Plot graph
%          = pplot(IJ,Labels,XY,...)                   % Label arcs IJ
%          = pplot(loc,XY,...) % Plot loc seq
%          = pplot(loc,Labels,XY,...)                  % Label loc seq 'loc'
%          = pplot([IJ | loc],XY,Labels,...)           % Best-fit labels
%          = pplot(border,...) % Border offset percentage for XLim and YLim
%          = pplot('proj')     % Create new figure & axes with projection
%          = pplot             % Create without projection
%   'proj' = initialize current axes so that current and subsequent plots 
%            are projected using PROJ; if axes not initialized, then PPLOT 
%            plots data  unprojected (axes initialized by setting Tag 
%            property to 'proj')
%       XY = m x 2 matrix of m 2-D points, which, if projected, should be
%            longitude-latitude pairs (in decimal degrees)
%       IJ = n-row matrix arc list [i j] of arc heads and tails
%      loc = cell array of loc seq vectors, loc = {[loc1],[loc2],...}
%            (label arcs of single-seq and centroids of multiple loc seqs)
% LineSpec = character string to display line object (see PLOT for options)
%   Labels = cell array of strings
%          = num2cell(1:m), if numbering XY
%          = num2cell(IJD(:,3)), if labeling arc costs in n x 3 matrix IJD
%          = cellstr(chararray), if using rows of character array as labels
% PropName = any line or text object property name
%PropValue = corresponding line object property value
%            (note: a structure or cell arrays can also be used for 
%            property name-value pairs (see SET for details))
%   border = nonnegative scalar offset percentage for point/arc border, 
%            where offset is percentage of max X,Y extent (only increases 
%            XLim,YLim to MaxXYLim, which can be set as the field of a 
%            structure stored in the "UserData" of the current axes (see 
%            MAKEMAP))
%          = 0 (default, with projection), no offset
%          = 0.2 (default, no projection), 20% offset
%        h = handle of line object created, or, if labels, vector of text
%            object handles created, or, if PPLOT('proj'), handle of axes
%
% Examples:
% XY = [2 2; 3 1; 4 3; 1 4];                  % Points
% pplot(XY,'r.')
% pplot(XY,num2cell(1:4))
%
% % Names of North Carolina cities
% [Name,XY] = nccity;
% makemap(XY)
% pplot(XY,'r.')
% pplot(XY,Name)
%
% IJ = [1 2; 1 3; 1 4];                       % Arc List
% h1 = pplot(IJ,XY,'g-');
% IJlab = {'(1,2)','(1,3)','(1,4)'};
% h2 = pplot(IJ,IJlab,XY);
% delete([h1; h2])
%
% loc = {[1 4 3 2 1]};                        % Loc Seq Vector
% h3 = pplot(loc,XY,'g-');
% loclab = {'(1,4)','(4,3)','(3,2)','(2,1)'};
% h4 = pplot(loc,loclab,XY);
% set(h3,'color','b')
%
% If current figure does not exist, then new figure created with 
% DOUBLEBUFFER ON and MATLOGMENU called. If current axes does not exist, 
% then new axes created with HOLD ON, AXIS EQUAL, and BOX ON.
%
% If IJ or loc not specified for labeling points, then the Delaunay
% triangulation of the points are used to fit the labels. Edges greater
% than two times the shortest edge incident on each point are not used.

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
[projstr,XY,IJ,loc,LineSpec,Labels,arg1,arg2,arg3] = deal([]);
border = [];
Prop = {};
[PtLab,ArcLab,MultiLocLab,SingleLocLab,BFPtLab] = deal(false);

if nargin > 0 && ischar(varargin{1})
   projstr = lower(varargin{1}); 
   varargin = varargin(2:end);
elseif nargin > 0 && isreal(varargin{1}) && length(varargin{1}(:)) == 1
   border = varargin{1};  
   varargin = varargin(2:end);
end
nvarargin = length(varargin);
if nvarargin > 3, Prop = varargin(4:end); end
if nvarargin > 2, arg3 = varargin{3}; end
if nvarargin > 1, arg2 = varargin{2}; end
if nvarargin > 0, arg1 = varargin{1}; end

if isnumeric(arg1)
   if isempty(arg2)
      XY = arg1;
   else
      if ischar(arg2)
         XY = arg1; LineSpec = arg2;
         if nvarargin > 2, Prop = varargin(3:end); end
      elseif isnumeric(arg2)
         IJ = arg1; XY = arg2;
         if isempty(IJ), if nargout > 0, h = []; end, return, end
         if ~isempty(arg3)
            if ischar(arg3)
               LineSpec = arg3;
            elseif iscell(arg3)
               BFPtLab = true;  % BFPtLab = true;
               Labels = arg3;
            else
               Prop = varargin(3:end);
            end
         end
      elseif iscell(arg2)
         if ~isempty(arg3) && isnumeric(arg3)
            IJ = arg1; Labels = arg2; XY = arg3;
            if isempty(IJ), if nargout > 0, h = []; end, return, end
            ArcLab = true;  % ArcLab = true;
         else
            XY = arg1; Labels = arg2; PtLab = true;  % PtLab = true;
            if nvarargin > 2, Prop = varargin(3:end); end
         end
      end
   end
elseif iscell(arg1)
   loc = arg1;
   loc(cellfun(@(x)any(isnan(x)),loc)) = []; 
   if isnumeric(arg2)
      XY = arg2;
      if ~isempty(arg3)
         if ischar(arg3)
            LineSpec = arg3;
         elseif iscell(arg3)
            BFPtLab = true;  % BFPtLab = true;
            Labels = arg3;
         else
            Prop = varargin(3:end);
         end
      end
   elseif iscell(arg2)
      if length(arg1) > 1
         MultiLocLab = true;  % MultiLocLab = true;
      else
         SingleLocLab = true;  % SingleLocLab = true;
      end
      Labels = arg2; XY = arg3;
   else
      error('Unknown input argument combination.')
   end
else
   error('Unknown input argument combination.')
end

if isempty(LineSpec), LineSpec = ''; end
[m,cXY] = size(XY);
[n,cIJ] = size(IJ);

if ~isempty(projstr) && ~strcmpi(projstr,'proj')
   error('First argument string not "proj".')
elseif ~isempty(border) && (~isfinite(border) || border < 0)
   error('"border" must be a nonnegative scalar.')
elseif ~isempty(border) && nvarargin < 1
   error('Points or arcs must be specified together with "border".')
elseif ~isempty(border) && ~isempty(Labels)
   error('"border" cannot be specified for Labels.')
elseif nvarargin > 0 && (isempty(XY) || cXY ~= 2 || ~isnumeric(XY))
   error('XY not a valid two-column matrix.')
elseif length(LineSpec(:)) > 4 && ~strcmpi('NumNode',LineSpec)
   error('LineSpec must be a valid character string (see PLOT).')
elseif strcmpi('NumNode',LineSpec) && m > 99
   error('Maximum of 99 nodes with NumNode option.')
elseif strcmpi('NumNode',LineSpec) && nargout > 0
   error('No output arguments with NumNode option.')
elseif ~isempty(IJ) && (cIJ < 2 || min(min(abs(IJ(:,[1 2])))) < 1 || ...
      max(max(abs(IJ(:,[1 2])))) > m || cIJ > 3)
   error('IJ not a valid arc list.')
elseif ~isempty(loc) && (~all(all(cellfun('isreal',loc))) || ...
      any(cellfun('prodofsize',loc) ~= cellfun('length',loc)) || ...
      min([loc{:}]) < 1 || max([loc{:}]) > m)
   error('"loc" not a valid loc seq vector or cell array.')
elseif ~isempty(Labels) && (~all(cellfun('isreal',Labels)) || ...
      any(cellfun('length',Labels) ~= cellfun('prodofsize',Labels)))
   error('Labels must be a cell array of strings.')
elseif (PtLab || BFPtLab) && length(Labels(:)) ~= m
   error('Node Labels must be a m-element cell array.')
elseif ArcLab && length(Labels(:)) ~= n
   error('Arc Labels must be a n-element cell array.')
elseif SingleLocLab && length(Labels(:)) ~= length(loc{:}) - 1
   error('Loc Seq Labels must be a (|loc| - 1)-element cell array.')
elseif MultiLocLab && length(Labels(:)) ~= length(loc(:))
   error('Loc Seq Labels must be a |loc|-element cell array.')
end
% End (Input Error Checking) **********************************************

if strcmpi('NumNode',LineSpec)
   LineSpec = 'o';
   pplot(XY,LineSpec,'MarkerSize',12,'MarkerFaceColor','w',Prop{:});
   pplot(XY,num2cell(1:size(XY,1)),...
      'HorizontalAlignment','center','VerticalAlignment','middle');
   return  % Can't save handles from each call b/c causes error
end

if ~isempty(IJ), IJ = abs(IJ(:,[1 2])); end  % Ignore arc dir. and cost

if nvarargin == 0 || isempty(findobj('Type','figure'))  % New figure
   figure, set(gcf,'DoubleBuffer','on','Tag','Matlog Figure'), matlogmenu
end
if nvarargin == 0 || isempty(findobj('Type','axes'))
   gca; hold on, box on
   if m ~= 1, axis equal, end   % Single point corrupts axis labels 
   s.LastLineTag = [];
   s.MaxXYLim = [];
   set(gca,'UserData',s)
end

if ~isempty(projstr)
   if all(~strcmpi(get(gca,'Tag'),{'','proj'}))
      error('Tag string of current axes not empty or equal to "proj".')
   elseif strcmp(get(gca,'Tag'),'')
      set(gca,'Tag','proj')
   end
end

if nvarargin == 0, if nargout > 0, h = gca; end, return, end

if isempty(Labels)
   if ~isempty(IJ)
      X = XY(:,1); X = X(IJ); if n < 2, X = X'; end, X = [X NaN(n,1)]';
      Y = XY(:,2); Y = Y(IJ); if n < 2, Y = Y'; end, Y = [Y NaN(n,1)]';
      XY = [X(:) Y(:)];
   elseif ~isempty(loc)
      XYin = XY;
      XY = [];
      for i = 1:length(loc), XY = [XY; XYin([loc{i}],:); NaN NaN]; end
   end
end

if strcmp(get(gca,'Tag'),'proj')
   XY = proj(normlonlat(XY));
end

if isempty(Labels)  % Points and Arcs
   hout = plot(XY(:,1),XY(:,2),LineSpec,Prop{:});  % Call to PLOT
   idxtagstr = find(strcmpi(Prop,'tag'));          % Store line tag
   if ~isempty(idxtagstr)
      s = get(gca,'UserData');
      if isstruct(s) && isfield(s,'LastLineTag')
         s.LastLineTag = Prop{idxtagstr + 1};
         set(gca,'UserData',s)
      end
   end     
else                % Labels
   defLabProp = {'Clipping','on','FontSize',7};
   if PtLab || BFPtLab         % Point labels
      if PtLab
         if size(XY,1) > 2
            IJ = tri2list(delaunay(XY(:,1),XY(:,2)));
         elseif size(XY,1) > 1
            IJ = [1 2];
         else
            IJ = [1 1];
         end
      elseif ~isempty(loc)
         IJ = [];
         for k = 1:length(loc)
            i = loc{k}(1:end-1); j = loc{k}(2:end);
            IJ = [IJ; i(:) j(:)];
         end
      end
      A = list2adj(IJ);
      A = A + A';
      hout = [];
      for i = 1:m
         [halign,valign,labstr,~,padspace] = bestfitpos(PtLab,...
            XY(i,:),XY(find(A(:,i)),:),makelabstr(Labels{i}));
         LabProp = {defLabProp{:},'HorizontalAlignment',halign,...
               'VerticalAlignment',valign,Prop{:}};
         houti = text(XY(i,1),XY(i,2),labstr,LabProp{:});
         extent = get(houti,'Extent');            % Reposition if text box
         XLim = get(gca,'XLim');                  % is outside of X-axis
         if extent(1) + extent(3) > XLim(2)       % limits
            set(houti,'HorizontalAlignment','right',...
               'String',[get(houti,'String') blanks(padspace)]);
         elseif extent(1) < XLim(1)
            set(houti,'HorizontalAlignment','left',...
               'String',[blanks(padspace) get(houti,'String')]);
         end
         hout = [hout; houti];
      end
   elseif ArcLab                 % Arc labels
      hout = [];
      for i = 1:n
         [loc,ang,orient] = arcpos(XY(IJ(i,1),:),XY(IJ(i,2),:));
         LabProp = {defLabProp{:},'HorizontalAlignment','center',...
               'VerticalAlignment',orient,'Rotation',ang,Prop{:}};
         hout = [hout; text(loc(1),loc(2),makelabstr(Labels{i}),LabProp{:})];
      end
   elseif SingleLocLab           % Single loc seq labels
      hout = [];
      if length(loc{1}) > 1
         for i = 1:length(loc{1})-1
            [lc,ang,orient] = arcpos(XY(loc{1}(i),:),XY(loc{1}(i+1),:));
            LabProp = {defLabProp{:},'HorizontalAlignment','center',...
                  'VerticalAlignment',orient,'Rotation',ang,Prop{:}};
            hout = [hout; ...
                  text(lc(1),lc(2),makelabstr(Labels{i}),LabProp{:})];
         end
      end
   elseif MultiLocLab            % Multiple loc seq labels
      hout = [];
      for i = 1:length(loc)
         if length(loc{i}) > 1
            % Use arc from first and last points on loc seq for label angle
            [~,ang,orient] = arcpos(XY(loc{i}(1),:),XY(loc{i}(end),:));
            lc = mean(XY(loc{i},:));  % Use centroid for label location
            LabProp = {defLabProp{:},'HorizontalAlignment','center',...
                  'VerticalAlignment',orient,'Rotation',ang,Prop{:}};
            hout = [hout; ...
                  text(lc(1),lc(2),makelabstr(Labels{i}),LabProp{:})];
         end
      end
   end
end

if isempty(Labels)  % Border offset
   if isempty(border)
      if strcmp(get(gca,'Tag'),'proj'), border = 0; else border = 0.2; end
   end
   if border > 0
      xy1xy2 = boundrect(XY,border);
      XYLim = [get(gca,'XLim')' get(gca,'YLim')'];
      xy1xy2 = [min(xy1xy2(1,:),XYLim(1,:)); max(xy1xy2(2,:),XYLim(2,:))];
      s = get(gca,'UserData');  % Check for Maximum X,Y Limits
      if isstruct(s) && isfield(s,'MaxXYLim') && ~isempty(s.MaxXYLim)
         xy1xy2 = [max(xy1xy2(1,:),s.MaxXYLim(1,:)); ...
               min(xy1xy2(2,:),s.MaxXYLim(2,:))];
      end
      set(gca,'XLim',xy1xy2(:,1))
      set(gca,'YLim',xy1xy2(:,2))
   end
end   

if strcmp(get(gca,'Tag'),'proj'), projtick, end

if nargout > 0, h = hout; end

shg  % Re-draw plot on screen



% *************************************************************************
% *************************************************************************
% *************************************************************************
function [halign,valign,labstr,ang,padspace] = ...
   bestfitpos(PtLab,xy,XY,labstr)
%BESTFITPOS Best-fit label at point xy relative to arcs from xy to XY.

padspace = 1;    % No. of spaces to pad in order to offset text from point
threshratio = 2; % Threshold ratio to cut off edges of Delaunay tri.

if isempty(XY) || all(all(is0(xy(ones(size(XY,1),1),:) - XY)))
   ang = 0;
   valign = 'top';
   halign = 'left';
else
   if PtLab  % Use edges from Delaunay triangulation
      d = dists(xy,XY,2);
      XY = XY(d/min(d) <= threshratio,:);
   end
   
   ang = sort(arcang(xy,XY));
   if size(XY,1) == 1   % Label opposite single arc
      ang = ang + 180;
   else                 % Label between max arc angle gap
      d = diff([-180; ang; 180]);
      d = [d(2:end-1); d(1) + d(end)];
      idx = argmax(d);
      ang = ang(idx) + d(idx)/2;  % Note: ang can only be > 180, not < -180
   end
   
   if ang < 0, ang = 360 + ang; end  % Convert to range 0 to 360 degrees
   rng = [ 0  1  3  5  7  9 11 13 15 16]*22.5;
   %idx =[ 1  2  3  4  5  6  7  8  9 10];
   %      E1  NE  N NW  W SW  S SE E2
   idx = find(ang >= rng(1:9) & ang < rng(2:10));
   if ismember(idx,[4 5 6])
      halign = 'right';
      labstr = [labstr blanks(padspace)];
   elseif ismember(idx,[3 7])
      halign = 'center';
   else
      halign = 'left';
      labstr = [blanks(padspace) labstr];
   end
   if ismember(idx,[2 3 4])
      valign = 'bottom';
   elseif ismember(idx,[1 5 9])
      valign = 'middle';
   else
      valign = 'top';
   end  
end



% *************************************************************************
% *************************************************************************
% *************************************************************************
function [loc,ang,orient] = arcpos(xy1,xy2)
%ARCPOS Location, angle, and orientation for arc labels.

loc = (xy1 + xy2)/2;
ang = arcang(xy1,xy2);
if all(is0(xy1-xy2))
   orient = 'middle';
elseif ang < 90 && ang >= -90
   orient = 'bottom';
else
   orient = 'top';
end
if ang >= 90, ang = ang - 180; elseif ang < -90, ang = ang + 180; end  



% *************************************************************************
% *************************************************************************
% *************************************************************************
function ang = arcang(xy,XY)
%ARCANG Arc angles (in degrees) from xy to XY.

if ~isempty(XY)
   ang = 180*atan2(XY(:,2) - xy(2), XY(:,1) - xy(1))/pi;
else
   ang = 0;
end



% *************************************************************************
% *************************************************************************
% *************************************************************************
function labstr = makelabstr(labstr)
%NUMLAB2LABSTR Convert numeric label to a label string..

if isnumeric(labstr)
   labstr = num2str(labstr);
elseif ~ischar(labstr)
   error('Label elements must be a string or a number.')
end



% *************************************************************************
% *************************************************************************
% *************************************************************************
function h = matlogmenu(hfig)
%MATLOGMENU Create Matlog menu on the current figure's menu bar
%     h = handle of menu object created

% Input Error Checking ****************************************************
if nargin < 1 || isempty(hfig)
   hfig = gcf;
elseif ishandle(hfig) && ~strcmp(get(hfig,'Type'),'figure')
   error('"hfig" must be a figure handle.')
end
% End (Input Error Checking) **********************************************

% Top-Level Menu
hout = uimenu('Label','&Matlog');
if nargout > 0, h = hout; end

% Menu Elements
uimenu(hout,'Label','&Re-Project Ticks','Callback','projtick',...
   'Accelerator','R')

uimenu(hout,'Label','&Set Pauseplot Time','Callback','pauseplot(''set'')')

uimenu(hout,'Label','&Erase Last Line Tag','Callback',...
   'deletelntag','Accelerator','D')

% Help and About Matlog Menu Elements
uimenu(hout,'Label','Matlog &Help','Separator','on','Callback',...
   'helpwin(''matlog'')')

uimenu(hout,'Label','&About Matlog...','Callback',...
   ['msgbox({''Logistics Engineering Toolbox'''...
      ','' '',''http://www.ise.ncsu.edu/kay/matlog''},''Matlog'')'])
