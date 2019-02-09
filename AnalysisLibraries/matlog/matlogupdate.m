function nfilesrepl = matlogupdate()
%MATLOGUPDATE Automatically download updates to Matlog files.
% nfilesrepl = matlogupdate()
% nfilesrepl = number of files updated (command line prompt suppressed if
%              this output argument is requested)
%
% Note: Do not need to run this if connected to the NCSU network.
%       If off-campus, can add MATLOGUPDATE to your "startup.m" file.
%       Uses Matlog function GETFILE to copy files.
%
% (Files that need updating are determined by checking their modification
%  dates to see if they are earlier than the dates of the same files in the 
%  current Matlog directory at NCSU (http://www.ise.ncsu.edu/kay/matlog/
%  matlogdir.mat). Looks for the file "matlogupdate.m" to determine the 
%  path to the Matlog directory on the local computer.)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
fulln = which('matlogupdate.m');
if isempty(fulln)
   error('Unable to find file "matlogupdate.m" in local Matlog directory.')
end
matlogpath = fileparts(fulln);
if strcmp(matlogpath,'j:/eos/lockers/research/ie/kay/matlog') || ...
      strcmp(matlogpath,'/afs/eos/lockers/research/ie/kay/matlog')
   error('Cannot run update when connected to the NCSU network.')
end
XFlg = getfile('http://www.ise.ncsu.edu/kay/matlog/','matlogdir.mat',...
   fullfile(matlogpath,'matlogdir.mat'));
if XFlg == 0, error('Not able to connect to the Matlog website.'), end
% End (Input Error Checking) **********************************************

load matlogdir  % Load directory structure "d"
d2 = dir(matlogpath);
cn = struct2cell(d2);
cn = cn(1,:);  % Put names into cell array

replname = {};
replkbytes = 0;
for i = 1:length(d)
   if ~d(i).isdir
      j = find(strcmp(d(i).name,cn));
      dvi = datevec(d(i).date);
      if ~isempty(j), dvj = datevec(d2(j).date); end
          % Ignore hours and less due to DST error in Windows (adds hour??)
      if isempty(j) || datenum(dvi) > datenum([dvj(1:end-3) dvi(end-2:end)])
         replname{length(replname) + 1} = d(i).name;
         replkbytes = replkbytes + round(d(i).bytes/1024);
      end
   end
end

if nargout > 0, nfilesrepl = length(replname); end

% questdlg not working in 6.1, will be fixed in 6.5
if length(replname) == 0
   if nargout < 1
      fprintf('Matlog Update found no files that need updating\n\n')
   end
   return
end
if nargout < 1
   fprintf(...
      'Matlog Update found %d file(s) (%d KB) that need(s) updating:\n',...
      length(replname),replkbytes);
   fprintf('   %s\n',replname{:});
   res = input('\n   Do you want to download these files? [y/n] : ','s');
end
if nargout > 0 || strcmpi(res,'y')
   for i = 1:length(replname)
      XFlg = getfile('http://www.ise.ncsu.edu/kay/matlog/updates/',...
         replname{i},fullfile(matlogpath,replname{i}));
      if XFlg == 0
         warning(['Not able to find file "',replname{i},...
               '" on the Matlog website.'])
      end
   end
end
