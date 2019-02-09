function s = xls2struct(FILE,SHEET)
% XLS2STRUCT Convert Excel database to structure array.
% s = xls2struct(FILE,SHEET)
%  FILE = spreadsheet file
% SHEET = worksheet name
%     s = m-element structure array with n fields, corresponding to (m+1)
%         rows and n columns in SHEET, where the first row are the column
%         headings that are converted to structure field names
%
% Converts XLSREAD(FILE,SHEET) numeric and text arrays to a structure
% array. Worksheet should be in a database format, where each column
% contains all numeric data or all text strings, and each row represents a
% record. Each text string converted to cell in structure.

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
[X,T] = xlsread(FILE,SHEET);
if size(T,1) > size(X,1), T = T(1:size(X,1)+1,:); end
k = size(T,2) - size(X,2);
if k > 0, X = [nan(size(X,1),k) X]; end
fields = T(1,:);
T(1,:) = [];
if isempty(T), T = cell(size(X)); end
if any(cellfun('isempty',fields))
   error(['Incorrect column headings in worksheet "' SHEET '".'])
% elseif ~all(any(isnan(X),1) == all(isnan(X),1))
%    error('Columns must be all numeric or all text.')
end
% End (Input Error Checking) **********************************************

fields = strrep(fields,' ','_');
fields = strrep(fields,'''','');
fields = strrep(fields,'/','_');
fields = strrep(fields,'.','_');
fields = strrep(fields,'(','');
fields = strrep(fields,')','');
fields = strrep(fields,'$','_');

isnum = ~all(isnan(X),1);
isemptycol = ~isnum & all(cellfun('isempty',T),1);
X(:,isemptycol)  = [];
T(:,isemptycol) = [];
fields(isemptycol) = [];
isnum(isemptycol) = [];
X(:,~isnum) = [];

T(:,isnum) = mat2cell(X,ones(size(X,1),1),ones(1,size(X,2)));
s = cell2struct(T,fields,2);

fields = fields(~isnum);  % Text string converted to cell
for i = 1:size(T,1)
   for j = 1:length(fields)
      s(i) = setfield(s(i),fields{j},{getfield(s(i),fields{j})});
   end
end
   
