function varargout = mat2vec(X)
%MAT2VEC Convert columns of matrix to vectors.
% [X(:,1),X(:,2),...] = mat2vec(X)
%
% (Additional output vectors assigned as empty)

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if ~isnumeric(X)
   error('X must be numeric.')
end
% End (Input Error Checking) **********************************************

varargout = cell(1,max(1,nargout));
X = num2cell(X,1);
varargout(1,1:min(nargout,size(X,2))) = X(1,1:min(nargout,size(X,2)));
