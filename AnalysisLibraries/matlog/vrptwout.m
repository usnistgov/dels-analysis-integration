function [Barsout,Labels,s] = vrptwout(out)
%VRPTWOUT Generate output VRP with time windows.
% [Bars,Labels,s] = vrptwout(out)
%   [Bars,Labels] = vrptwout(out)  % Display "s" in command window
%   out = output structure from LOCTC
%   Bars, Labels = inputs for GANTT chart of loc seqs
%     s = output as string with tabs between values so that it can be
%         directly pasted into a spreadsheet (also copied to clipboard)
%
% Example:
% XY = nccity('XY');
% XY = XY(dists(XY(1,:),XY,'mi')/35 < 2, :);  % Within 2 hours at 35 mph
% n = size(XY,1);
% T = dists(XY,XY,'mi')/35;
% q = [0 10*ones(1,n-1)];
% Q = 100;
% ld = 12/60;
% rand('state',5538)
% B = floor(rand(n-1,1)*10)+7;
% TW = [B B+floor(rand(n-1,1)*4)+1];
% TW = [-inf inf;TW;-inf inf];
% loc = vrpsavings(T,{q,Q},{ld,TW});
% makemap(XY)
% pplot(XY,'r.')
% pplot(XY,num2cell(1:n))
% pplot(loc,XY,'m')
% [TC,XFlg,out] = locTC(loc,T,{q,Q},{ld,TW});
% [Bars,Labels] = vrptwout(out);
% figure
% gantt(Bars)
% gantt(Bars,Labels)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if ~isequal(fieldnames(out)',{'Loc','Cost','Demand','Arrive','Wait',...
         'Start','LD','Depart','Total','EarlySF','LateSF'})
   error('"out" is not a valid output structure from LOCTC.')
end
% End (Input Error Checking) **********************************************

s = [];
s = [s sprintf(['Cust\tCases\tDrive (hr)\tArrive\tWait (hr)\t'...
         'Start\tL/D (hr)\tDepart\tTotal Time (hr)\n'])];

for i = 1:length(out)
   if isempty(out(i).Demand)
      out(i).Demand = zeros(1,length(out(i).Loc));
   end
   if isempty(out(i).LD), out(i).LD = zeros(1,length(out(i).Loc)); end
   s = [s sprintf('\nLoc Seq \t%d\n',i)];
   s = [s sprintf(['%3d\t\t\t\t\t',...
            '%s\t%6.2f\t',...
            '%s\t%6.2f\n'],...
         out(i).Loc(1),...
         dec2tstr(out(i).Start(1)),out(i).LD(1),...
         dec2tstr(out(i).Depart(1)),out(i).Total(1))];
   for j = 2:length(out(i).Loc)
      s = [s sprintf(['%3d\t',...
               '%3d\t%6.2f\t',...
               '%s\t%6.2f\t',...
               '%s\t%6.2f\t',...
               '%s\t%6.2f\n'],...
            out(i).Loc(j),...
            out(i).Demand(j),out(i).Cost(j),...
            dec2tstr(out(i).Arrive(j)),out(i).Wait(j),...
            dec2tstr(out(i).Start(j)),out(i).LD(j),...
            dec2tstr(out(i).Depart(j)),out(i).Total(j))];
   end
   s = [s sprintf(['Total\t',...
            '%3d\t%6.2f\t',...
            '\t%6.2f\t',...
            '\t%6.2f\t',...
            '\t%6.2f\t\n'],...
         sum(out(i).Demand),sum(out(i).Cost),...
         sum(out(i).Wait),sum(out(i).LD),sum(out(i).Total))];
   ES = out(i).EarlySF(1); LS = out(i).LateSF(1);
   EF = out(i).EarlySF(2); LF = out(i).LateSF(2);
   if LS < EF
      Bars{i} = [ES LS; LS EF; EF LF];
      Labels{i} = {'',num2str(i),''};
   else
      Bars{i} = [ES EF; LS LF];
      Labels{i} = {num2str(i),num2str(i)};
   end
end

if nargout > 0, Barsout = Bars; end
if nargout < 3, disp(' '), disp(s), end
clipboard('copy',s)


% *************************************************************************
% *************************************************************************
% *************************************************************************
function tstr = dec2tstr(t)
%Convert decimal time to time string.
tstr = datestr(mod(t/24,1),15);
