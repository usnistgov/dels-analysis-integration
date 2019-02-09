function [A,idxi,idxj] = binaryorder(A)
%BINARYORDER Binary ordering of machine-part matrix.
% [A,idxi,idxj] = binaryorder(Ain)
%   Ain = m x n 0-1 machine-part matrix
%     A = machine-part matrix in binary order, where A = Ain(idxi,idxj)
%  idxi = m-element index vector of machine orderings
%  idxj = n-element index vector of part orderings

% Copyright (c) 1994-2014 by Michael G. Kay
% Matlog Version 16 03-Jan-2014 (http://www.ise.ncsu.edu/kay/matlog)

% Input Error Checking ****************************************************
if ~all(A == 1 || A == 0)
   error('"Ain" must be a 0-1 matrix.')
end
% End (Input Error Checking) **********************************************

idxi = 1:size(A,1);
idxj = 1:size(A,2);

idxi = idxi(argsort(A * (2.^(0:size(A,2)-1))'));

done = 0;
while ~done
   idxj0 = idxj;
   idxj = idxj(argsort((2.^(0:size(A,1)-1)) * A(idxi,idxj)));
   if all(idxj0 == idxj)
      done = 1;
   else
      idxi0 = idxi;
      idxi = idxi(argsort(A(idxi,idxj) * (2.^(0:size(A,2)-1))'));
      if all(idxi0 == idxi)
         done = 1;
      end
   end
end

A = A(idxi,idxj);
