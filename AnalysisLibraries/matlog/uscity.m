function varargout = uscity(varargin)
%USCITY US cities data.
%      s = uscity             Output all variables as structure 's'
%[x1,x2] = uscity             Output only first 1, 2, etc., variables
%      s = uscity('x',...)    Output only variables 'x', ... as struct. 's'
%[x,...] = uscity('x',...)    Output variables 'x', ... as variables
%        = uscity(...,is)     Output subset 'x(is)' using SUBSETSTUCT(s,is)
%                             where 'is' is vector of elements to extract
%
% Loads data file "uscity.mat" that contain the following variables:
%      Name = m-element cell array of m city name strings
%        ST = m-element cell array of m 2-char state abbreviations
%        XY = m x 2 matrix of city lon-lat (in decimal deg)
%       Pop = m-element vector of total population estimates (2010)
%     House = m-element vector of total housing units (2010)
%  LandArea = m-element vector of land area (square miles)
% WaterArea = m-element vector of water area (square miles)
% StatePlaceFIPS = m-element vector of state and place FIPS codes
% PlaceType = m-element cell array of m place type strings
%
% Example 1: Extract name of all cities in North Carolina
% NCcity = uscity('Name',strcmp('NC',uscity('ST')))
%
% %  NCcity = 'Aberdeen'
% %            ...
% %           'Zebulon'
%
% Example 2: Find Find the lon-lat of Gainesville, FL and Raleigh, NC
% XY = uscity('XY',mand({'Gainesville','Raleigh'},uscity('Name'),...
%                       {'FL','NC'},uscity('ST')))
% % XY =
% %   -82.3459   29.6788
% %   -78.6414   35.8302%
%
% Sources:
% [1] http://www.census.gov/geo/www/gazetteer/gazetteer2010.html
%     (file: .../gazetteer/files/Gaz_places_national.txt)
% [2] http://www.census.gov/geo/www/2010census/zcta_rel/zcta_rel.html
%     (file: .../zcta_rel/zcta_place_rel_10.txt)
%
% File [1] contains data for all incorporated places and census designated
% places (CDPs) in the 50 states, the District of Columbia and Puerto Rico
% as of the January 1, 2010. File [2] used for Pop and House fields, and
% File [1] for all other fields.

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
varnames = {'Name','ST','XY','Pop','House','LandArea','WaterArea',...
      'StatePlaceFIPS','PlaceType'};
[errstr,varargout] = loaddatafile(varargin,nargout,varnames,mfilename);
if ~isempty(errstr), error(errstr), end
% End (Input Error Checking) **********************************************
