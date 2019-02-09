function varargout = nccity(varargin)
%NCCITY North Carolina cities with populations of at least 10,000 data.
%      s = nccity          Output all variables as structure 's'
%[x1,x2] = nccity          Output only first 1, 2, etc., variables
%      s = nccity('x',...) Output only variables 'x', ... as struct. 's'
%[x,...] = nccity('x',...) Output variables 'x', ... as variables
%        = nccity(...,is)  Output subset 'x(is)' using SUBSETSTUCT(s,is)
%                          where 'is' is vector of elements to extract
%
% Loads data file "nccity.mat" that contain the following variables:
%   Name = m-element cell array of m city name strings
%     XY = m x 2 matrix of city lon-lat (in decimal deg)
%    Pop = m-element vector of total population estimates (2010)
%
% Example: Extract lon-lat of Raleigh
% xyRal = nccity('XY',strcmp('Raleigh',nccity('Name')))
%
% % xyRal =  -78.6414   35.8302
%
% (Subset of USCITY)
%
% Sources:
% [1] http://www.census.gov/geo/www/gazetteer/gazetteer2010.html
%     (file: .../gazetteer/files/Gaz_places_national.txt)
% [2] http://www.census.gov/geo/www/2010census/zcta_rel/zcta_rel.html
%     (file: .../zcta_rel/zcta_place_rel_10.txt)
%
% File [1] contains data for all incorporated places and census designated
% places (CDPs) in the 50 states, the District of Columbia and Puerto Rico
% as of the January 1, 2010. File [2] used for Pop field, and
% File [1] for all other fields.

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
varnames = {'Name','XY','Pop'};
[errstr,varargout] = loaddatafile(varargin,nargout,varnames,mfilename);
if ~isempty(errstr), error(errstr), end
% End (Input Error Checking) **********************************************
