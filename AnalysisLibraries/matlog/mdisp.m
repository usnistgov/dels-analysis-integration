function strout = mdisp(X,row,col,rowtitle,fracdig,allfrac,isnosep,colsp)
%MDISP Matrix display.
%     str = mdisp(X,row,col,rowtitle,fracdig,allfrac,isnosep,colsp)
%       X = m x n array of real numbers
%     row = m-element cell array of row heading strings
%         = m-element numeric array of row numbers
%         = numbers 1 to m, default
%     col = n-element cell array of column heading strings
%         = n-element numeric array of column numbers
%         = numbers 1 to n, default
%rowtitle = scalar or string title for row headings
%         = name of first input argument, default
% fracdig = digits for fractional portion of number
%         = 2, default
% allfrac = digits for fractional portion of all fractional columns
%         = 4, default
% isnosep = output to "str" without horizontal and vertical separators
%           (to allow pasting into Excel as fixed-width text)
%         = true, default
%   colsp = spaces between columns
%         = 2, defualt
%     str = output as a string
%
% Note: NaN's displayed as blank spaces (can use to control formating).
%       Adds comma separators to numbers in array.
%
% Examples:
% X = rand(5,4);
% mdisp(X)
% mdisp(X < .5)
% mdisp(X * 10000)
% mdisp(fliplr(X),{'R1','row 2','R 3','RowFour','Row 5'},size(X,2):-1:1)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(1,8)
X = squeeze(X);  % Remove any singleton dimensions

if nargin < 2 || isempty(row), row = 1:size(X,1); end
if nargin < 3 || isempty(col), col = 1:size(X,2); end
if nargin < 4 || isempty(rowtitle), rowtitle = inputname(1); end
if nargin < 5 || isempty(fracdig), fracdig = 2; end
if nargin < 6 || isempty(allfrac), allfrac = 4; end
if nargin < 7 || isempty(isnosep), isnosep = true; end
if nargin < 8 || isempty(colsp), colsp = 2; end

if isnumeric(row), row = cellstr(num2str(row(:))); end
if isnumeric(col), col = cellstr(num2str(col(:))); end
if isnumeric(rowtitle), rowtitle = num2str(rowtitle(:)); end

if ~isreal(X) || ~ismatrix(X)
   error('X must be a 2-D matrix of real numbers.')
elseif ~iscell(row) || ~all(cellfun('isclass',row,'char')) || ...
      any(cellfun('prodofsize',row) ~= cellfun('length',row))
   error('"row" must be a cell array of strings.')
elseif ~iscell(col) || ~all(cellfun('isclass',col,'char')) || ...
      any(cellfun('prodofsize',col) ~= cellfun('length',col))
   error('"col" must be a cell array of strings.')
elseif length(row) ~= size(X,1)
   error('Length of "row" must equal the number of rows in X.')
elseif length(col) ~= size(X,2)
   error('Length of "col" must equal number columns in X, or one more.')
elseif ~ischar(rowtitle) || size(rowtitle,1) > 1
   error('"rowtitle" must be a scalar or string.')
elseif ~isscalar(fracdig) || ~isreal(fracdig) || ...
      round(fracdig) ~= fracdig || fracdig < 0
   error('"fracdig" must be a nonnegative scalar.')
elseif ~isscalar(allfrac) || ~isreal(allfrac) || ...
      round(allfrac) ~= allfrac || allfrac < 0
   error('"allfrac" must be a nonnegative scalar.')
elseif length(isnosep(:)) ~= 1 || ~islogical(isnosep)
   error('"isnosep" must be a logical scalar.')
elseif ~isscalar(colsp) || ~isreal(colsp) || ...
      round(colsp) ~= colsp || colsp < 0
   error('"colsp" must be a nonnegative scalar.')
end
% End (Input Error Checking) **********************************************

n = fracdig;      % Display digits for fractional values of X
nfrac = allfrac;  % Display digits for all fractional X
s = colsp;        % Spaces between columns
vsep = ':';       % Separator between row headings and data
hsep = '-';       % Separator between column headings and data

if islogical(X), X = double(X); end
if issparse(X), X = full(X); end

iscolint = all(isint(X) | isnan(X) | isinf(X), 1);
iscolfrac = all(abs(X) < 1 | isnan(X) | isinf(X), 1);

for j = 1:size(X,2)
   if iscolint(j)
      nij = 0;
   elseif iscolfrac(j)  % Ignore all 0 digits in column of fractions
      Xj = abs(X(:,j)) * 10.^(1:nfrac);
      idx0 = find(all(Xj==round(Xj),1),1);
      if isempty(idx0)
         nij = nfrac;
      else
         nij = idx0;
      end
   else
      nij = n;
   end
   for i = 1:size(X,1)
      X(i,j) = round(X(i,j)*10^nij)/10^nij;

      cij = sprintf('%f',X(i,j));

      if isnan(X(i,j))
         c{i,j} = ' ';
      elseif isinf(X(i,j))
         c{i,j} = cij;
      else
         [a,b] = strtok(cij,'.');
         z = [fliplr(length(a)-3:-3:1) length(a)];
         c{i,j} = cij(1:z(1));
         for k = 2:length(z)
            if ~isequal(cij(z(k-1)),'-'), sep = ','; else sep = ''; end
            c{i,j} = [c{i,j} sep cij(z(k-1)+1:z(k))];
         end
         if nij > 0
            if isempty(b), b = '.'; end
            if nij > length(b)-1, b(end+1:nij+1) = '0'; end
            c{i,j} = [c{i,j} '.' b(2:nij+1)];
         end
      end
   end
end

for j = 1:size(c,2)
   C{j} = strjust(char(c{:,j}));
   w0 = length(col{j});
   w = size(C{j},2);
   if w0 > w
      C{j} = [blanks(s) col{j}; ones(1,w0+s)*hsep;
         ones(size(C{j},1),ceil((w0-w)/2) + s)*' ' C{j} ...
         ones(size(C{j},1),floor((w0-w)/2))*' '];
   else
      C{j} = [blanks(ceil((w-w0)/2) + s) col{j} blanks(floor((w-w0)/2));...
         ones(1,w+s)*hsep; ones(size(C{j},1),s)*' ' C{j}];
   end
end

C0 = strjust(char({rowtitle row{:}}));

if size(C0,1) > 2 || ~isempty(rowtitle)
   str = [[C0(1,:); ones(1,size(C0,2))*hsep; C0(2:end,:)] ...
      ones(size(C0,1)+1,1)*vsep [C{:}]];
else
   str = [C{:}];
end

if nargout > 0
   if isnosep
      str(2,:) = [];
      str(:,size(C0,2)+1) = [];
   end
   strout = str21line(str);
else
   disp(' '), disp(str)
end

% clipboard('copy',str21line(str))


% *************************************************************************
% *************************************************************************
% *************************************************************************
function str1 = str21line(str)
%Convert multi-line string to single line string with line breaks.

str1 = [];
for i = 1:size(str,1)
   str1 = [str1 sprintf('%s\n',str(i,:))];
end


