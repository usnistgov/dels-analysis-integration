function XFlg = getfile(baseurl,fnin,fnout)
%GETFILE Download file from Internet and save local copy.
% XFlg = getfile(baseurl,fnin,fnout)
% baseurl = base URL address
%         = 'http://www.ie.ncsu.edu/kay/matlog/', default
%    fnin = name of file to read from from web
%   fnout = name of file to write to local directory
%         = 'fnin', default
%    XFlg = 1, able to get file
%         = 0, not able

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
narginchk(2,3)

if nargin < 3 || isempty(fnout), fnout = fnin; end
if isempty(baseurl), baseurl = 'http://www.ie.ncsu.edu/kay/matlog/'; end

if ~ischar(baseurl) || ~ischar(fnin) || ~ischar(fnout)
   error('Input arguments must be strings.')
end
baseurl = baseurl(:)';
fnin = fnin(:)'; fnout = fnout(:)';
% End (Input Error Checking) **********************************************

try
   url = java.net.URL([baseurl fnin]);
   br = java.io.DataInputStream(openStream(url));
catch
   if nargout > 0
      XFlg = 0;
      return
   else
      rethrow(lasterr)
   end
end

fid = fopen(fnout,'wb');

x = read(br);
while x > -1
   fwrite(fid,x);
   x = read(br);
end

close(br);
fclose(fid);

if nargout > 0, XFlg = 1; end
