function varargout = inputevaldlg(prompt,title,defval,pflag)
%INPUTEVALDLG Input dialog with evaluation of values.
%[val1,val2,...] = inputevaldlg(prompt,title,defval)  % Cell array inputs
%            val = inputevaldlg(s,title)              % Structure input
% prompt = cell array of prompt strings for each input value
%      s = single structure, where the name of each field is prompt string
%          and default values are the field values (empty values are
%          ignored)
%  title = title for the dialog
%        = name of structure, default for structure input
% defval = default values for inputs (optional)
%          (new dialog is created for any single structure default values)
%[val1,val2,...] = output values, if cell array inputs (cell array of 
%          output values, if single output argument)
%   val  = structure of values, if structure input
%        = [], if dialog cancelled
%
%
% Examples:
% % Calling dialog directly
% x = 0;
% y = false;
% z = 'Hello';
% prompt = {'x = ','y = ','z = '};
% title = 'Example Dialog';
% defval = {x,y,z};
% [x,y,z] = inputevaldlg(prompt,title,defval)
%
% % Calling from within a function
% function [x,y,z] = myfun(x,y,z)
% %MYFUN My function that calls INPUTEVALDLG
% if nargin < 1 | isempty(x), x = 0; end
% if nargin < 2 | isempty(y), y = false; end
% if nargin < 3 | isempty(z), z = 'Hello'; end
% if nargin < 1  % Use dialog when no input arguments
%    prompt = {'x = ','y = ','z = '};
%    title = 'MYFUN My function that calls INPUTEVALDLG';
%    defval = {x,y,z};
%    [x,y,z] = inputevaldlg(prompt,title,defval);
%    if isempty(x), [x,y,z] = deal([]); return, end  % Cancelled dialog
% end
%
% % Creating an option structure for MCNF
% opt = mcnf('defaults')
% opt = inputevaldlg(opt)
%
% (When called within a function, the previous output values are used as
% default values for inputs if function has previousely called the dialog.
% Same as INPUTDLG except that the input values are evaluated instead of
% being returned as strings.)
%
% See also INPUTDLG

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
persistent prevval
narginchk(1,5)

if nargin < 2 || isempty(title), title = ''; end
if nargin < 3, defval = []; else defval = defval(:); end
if nargin < 4, pflag = []; end

if iscell(prompt)  % Input cell arrays
   isinputstruct = false;
   prompt = prompt(:);
elseif isstruct(prompt)  % Input a structure
   isinputstruct = true;
   if isempty(title), title = inputname(1); end
   if isempty(defval), defval = struct2cell(prompt); end
   isval = ~cellfun('isempty',defval);
   defval = defval(isval);
   prompt = fieldnames(prompt);
   promptin = prompt;
   prompt = promptin(isval);
else
   error('"prompt" must be a cell or a structure.')
end

if isempty(defval), defval = {}; [defval{1:length(prompt)}] = deal([]); end

% Use previous values if function already called
ST = dbstack;
if length(ST) > 1
   origdefval = defval;
   if ~isempty(prevval) && strcmp(prevval.CallingFunction,ST(2).name) && ...
         isequal(prompt,prevval.Prompt) && isequal(title,prevval.Title) && ...
         isequal(origdefval,prevval.OrigDefval)
      prompt = prevval.Prompt;
      title = prevval.Title;
      defval = prevval.Defval;
      pflag = prevval.Pflag;
   end
end

if isempty(pflag)
   pflag.isexpression = false(1,length(prompt));
   pflag.isstructval = false(1,length(defval));
end

if ~isempty(defval) && ~iscell(defval)
   error('"defval" must be a cell array.')
elseif ~isempty(defval) && length(prompt) ~= length(defval)
   error('"prompt" and "defval" must have the same number of elements."')
elseif ~isinputstruct && nargout ~= 1 && nargout ~= length(prompt)
   error('Number of output values must equal elements in "prompt".')
elseif isinputstruct && nargout ~= 1
   error('Single structure input can have only a single output value.')
end
% End (Input Error Checking) **********************************************

doeval = true(1,length(defval));
dvstr = cell(1,length(prompt)); [dvstr{:}] = deal('');

if ~all(cellfun('isempty',defval))
   for i = 1:length(defval)
      dvi = defval{i};
      if isempty(dvi)
         dvstr{i} = '';
      elseif pflag.isexpression(i)  % Don't add quotes to expression
         dvstr{i} = defval{i};
      elseif ischar(dvi) && size(dvi,1) == 1  % Add quotes to string
         dvstr{i} = ['''' defval{i} ''''];
         % Display matrices with total string length < 68 char
      elseif isnumeric(dvi) && matstrlen(dvi) < 68
         dvstr{i} = mat2str(defval{i});
      elseif islogical(dvi) && length(dvi) == 1  % Logical scalar
         if dvi, dvstr{i} = 'true'; else dvstr{i} = 'false'; end
      elseif isstruct(dvi) && length(dvi) == 1 && ~pflag.isstructval(i)
         pflag.isstructval(i) = true;                      % Structure
         dvstr{i} = '[Will create another input dialog when finished]';
      else  % Don't display non-scalar defaults, just size and class info
         doeval(i) = false;
         s = whos('dvi');
         str = '[';
         for j = 1:length(s.size)-1
            str = [str num2str(s.size(j)) 'x'];
         end
         dvstr{i} = [str num2str(s.size(j+1)) ' ' s.class ']'];
      end
   end
end

val = inputdlg(prompt,title,1,dvstr);

iserrors = false;
iscancel = false;
if isempty(val)  % Dialog canceled
   valout = cell(length(prompt),1);
   iscancel = true;
else
   for i = 1:length(val)
      if ~doeval(i) && ~pflag.isstructval(i) && ~strcmp(val{i},dvstr{i})
         doeval(i) = true;  % Evaluate if change made to default
      end
      if doeval(i) && ~isempty(val{i})
         if pflag.isstructval(i)  % Create another dialog for structure
            valout{i} = inputevaldlg(defval{i},prompt{i});
            val{i} = valout{i};
            pflag.isstructval(i) = false;
            pflag.isexpression(i) = true;  % Re-evaluate all if error
         else
            try
               valout{i} = evalin('base',val{i});
               pflag.isexpression(i) = true;  % Re-evaluate all if error
            catch
               val{i} = lasterr;  % Display error string
               val{i} = val{i}(1:min(length(val{i}),68)); %Cut so single line
               iserrors = true;
            end
         end
      elseif ~doeval(i) && ~isempty(val{i})
         valout{i} = defval{i};  % Pass thru default if no change
         val{i} = defval{i};
      else
         valout{i} = [];
      end
   end
   valout = valout(:);
end

if iserrors  % Recursive redo of dialog
   valout = inputevaldlg(prompt,title,val,pflag);
end

if isinputstruct  % Return structure if input was a structure
   fullvalout = cell(length(promptin),1);
   fullvalout(isval) = valout;
   varargout = {cell2struct(fullvalout,promptin,1)};
elseif nargout == length(prompt)
   varargout = valout;
elseif length(prompt) > 1
   varargout = {valout};
else
   varargout = valout;
end

% Save dialog info in "ans" in base workspace
if length(ST) > 1 && ~iscancel
   prevval.Prompt = prompt;
   prevval.Title = title;
   prevval.OrigDefval = origdefval;
   prevval.Defval = val(:);
   prevval.Pflag = pflag;
   prevval.CallingFunction = ST(2).name;
end



% *************************************************************************
% *************************************************************************
% *************************************************************************
function n = matstrlen(mat)
%MATSTRLEN Length of string version of matrix.

mat = mat(:);
n = 0;
for i = 1:length(mat)
   n = n + length(mat2str(mat(i))) + 1;  % Add 1 for space between elements
end
n = n - 1;  % Subtract last space
