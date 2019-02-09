function varargout = mapdata(varargin)
%MAPDATA Data for maps of the World, US, and North Carolina.
%      s = mapdata          Output all variables as structure 's'
%[x1,x2] = mapdata          Output only first 1, 2, etc., variables
%      s = mapdata('x',...) Output only variables 'x', ... as structure 's'
%[x,...] = mapdata('x',...) Output variables 'x', ... as variables
%        = mapdata(...,is)  Output subset 'x(is)' using SUBSETSTUCT(s,is)
%                           where 'is' is vector of elements to extract
%
% Loads data file "mapdata.mat" that contain the following variables:
% World = structure of World data with fields:
%       .XYB = international borders
%       .XYC = world coastline
%    US = structure of United States data with fields:
%       .XYB = US international borders
%       .XYC = US coastline
%       .XYS = US state borders
%    NC = structure of North Carolina data with fields:
%       .XYS = NC state border
%
% Data source: World from World Coast Line (1:5,000,000) and US from World
% Data Bank II (1:2,000,000; N 53.61 S 14.9 W -125 E -65) of the Coastline 
% Extractor created by Rich Signell of US Geological Survey and hosted by 
% NOAA/National Geophysical Data Center, Marine Geology & Geophysics 
% Division (http://rimmer.ngdc.noaa.gov/coast/). Data thined and sorted 
% using REDUCEM from Mapping Toolbox and JOIN_CST from Coastline Extractor.

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
varnames = {'World','US','NC'};
[errstr,varargout] = loaddatafile(varargin,nargout,varnames,mfilename);
if ~isempty(errstr), error(errstr), end
% End (Input Error Checking) **********************************************
