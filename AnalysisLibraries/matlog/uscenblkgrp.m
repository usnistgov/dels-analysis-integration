function varargout = uscenblkgrp(varargin)
%USCENBLKGRP US census block group data.
%      s = uscenblkgrp          Output all variables as structure 's'
%[x1,x2] = uscenblkgrp          Output only first 1, 2, etc., variables
%      s = uscenblkgrp('x',...) Output only variables 'x', ... as str. 's'
%[x,...] = uscenblkgrp('x',...) Output variables 'x', ... as variables
%        = uscenblkgrp(...,is)  Output subset x(is) using SUBSETSTUCT(s,is)
%                               where 'is' is vector of elements to extract
%
% Loads data file "uscenblkgrp.mat" that contain the following variables:
%         ST = m-element cell array of m 2-char state abbreviations
%         XY = m x 2 matrix of block-group pop center lon-lat (in dec deg)
%        Pop = m-element vector of total population estimates (2010)
%   LandArea = m-element vector of land area (square miles)
%  WaterArea = m-element vector of water area (square miles)
%     SCfips = m-element vector of state and 3-digit county FIPS codes
%TractBlkGrp = m-element vector of tract and 1-digit block-group codes,
%              where the block-group code is the leftmost digit of the
%              4-digit block codes of the blocks that comprise the group
%
% Example: Plot all census tracts in Raleigh-Cary and Durham-Chapel Hill
% %        Metropolitan Statistical Areas (Source: see [3], below)
% % 39580 Raleigh-Cary, NC Metropolitan Statistical Area
% %       37069         Franklin County, NC
% %       37101         Johnston County, NC
% %       37183         Wake County, NC
% % 20500 Durham-Chapel Hill, NC Metropolitan Statistical Area
% %       37037         Chatham County, NC
% %       37063         Durham County, NC
% %       37135         Orange County, NC
% %       37145         Person County, NC
% x = [37069 37101 37183 37037 37063 37135 37145];
% RCD = uscenblkgrp(mor(x,uscenblkgrp('SCfips')))
% % RCD =           ST: {858x1 cell}
% %                 XY: [858x2 double]
% %                Pop: [858x1 double]
% %           LandArea: [858x1 double]
% %          WaterArea: [858x1 double]
% %             SCfips: [858x1 double]
% %        TractBlkGrp: [858x1 double]
% makemap(RCD.XY)
% pplot(RCD.XY,'g.')
%
% Sources:
% [1] http://www.census.gov/geo/www/2010census/centerpop2010/blkgrp/bgcenters.html
%     (file: .../blkgrp/CenPop2010_Mean_BG.txt)
% [2] http://www.census.gov/geo/www/2010census/rel_blk_layout.html
%     (all files in: ...2010census/t00t10.html)
% [3] http://www.census.gov/population/metro/files/lists/2009/List1.txt
%
%  Block-group data derived from US Census Bureau's 2010 Census Centers of
%  Population by Census Block Group data (file [1]) and Census 2000
%  Tabulation Block to 2010 Census Tabulation Block data (files in [2]).
%  File [1] used for ST, XY, Pop, SCfips, and TractBlkGrp, where ST is
%  converted to alpha from numeric FIPS codes using FIPSNUM2ALPHA. Files in
%  [2] used for LandArea and WaterArea.

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
varnames = {'ST','XY','Pop','LandArea','WaterArea','SCfips','TractBlkGrp'};
[errstr,varargout] = loaddatafile(varargin,nargout,varnames,mfilename);
if ~isempty(errstr), error(errstr), end
% End (Input Error Checking) **********************************************
