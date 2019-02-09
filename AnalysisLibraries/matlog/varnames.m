function [name,val] = varnames(varargin)
%VARNAMES Convert input to cell arrays of variable names and values.
% [name,val] = varnames(varargin)
%  name = cell array of variable names
%   var = cell array of vector values
%       = single vector, if all scalar values

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
% End (Input Error Checking) **********************************************

for i = 1:length(varargin)
   name{i} = inputname(i);
   val{i} = varargin{i};
end

name = name(:);

if all(cellfun('length',val) == 1)
   val = [val{:}]';
end
