function opt = optstructchk(optdef,optin)
%OPTSTRUCTCHK Validate 'opt' structure.
%    opt = optstructchk(optdef,varargin)
% optdef = default opt structure
%        = MFUN('defaults'), to get default for function MFUN
%  optin = input opt cell from varargin
%    opt = structure, if valid
%        = string, if error
%
% Note: Option values are not vailidated, just its structure
% Used in MINISUMLOC and MCNF

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
% End (Input Error Checking) **********************************************

if length(optin) == 1, optin = optin{:}; end
opt = optdef;

if iscell(optin)
   if length(optin) == 1 || (length(optin)/2 ~= floor(length(optin)/2))
      opt = 'Cell array ''opt'' must contain field-value pairs.';
   else
      for i = 1:2:length(optin)-1
         if ~isfield(optdef,optin{i})
            opt = 'Field in cell array ''opts'' not valid.';
            return
         elseif ~isempty(optin{i+1})
            opt = setfield(opt,optin{i},optin{i+1});
         end
      end
   end
elseif isstruct(optin)
   fnin = fieldnames(optin); fn = fieldnames(optdef);
   if ~strcmpi(strcat(fnin{:}),strcat(fn{:}))
      opt = '"opt" not valid options structure.';
   else
      opt = optin;
      for i = 1:length(fnin)
         if isempty(getfield(opt,fnin{i}))
            opt = '"opt" structure cannot contain an empty field.';
            return
         end
      end
   end
elseif ~isempty(optin)
   opt = '"opt" must be an options structure or cell array.';
end
