% Copyright (C) 2012, 2013, 2014 Moreno Marzolla
%
% This file is part of the queueing toolbox.
%
% The queueing toolbox is free software: you can redistribute it and/or
% modify it under the terms of the GNU General Public License as
% published by the Free Software Foundation, either version 3 of the
% License, or (at your option) any later version.
%
% The queueing toolbox is distributed in the hope that it will be
% useful, but WITHOUT ANY WARRANTY; without even the implied warranty
% of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with the queueing toolbox. If not, see <http://www.gnu.org/licenses/>.

% -*- texinfo -*-
%
% @deftypefn {Function File} {[@var{err} @var{lambda} @var{S} @var{V} @var{m} @var{Z}] = } qnomchkparam( lambda, S, ... )
%
% Validate input parameters for open, multiclass network.
% @var{err} is the empty string on success, or a suitable error message
% string on failure.
%
% @end deftypefn

% Author: Moreno Marzolla <moreno.marzolla(at)unibo.it>
% Web: http://www.moreno.marzolla.name/

function [err, lambda, S, V, m] = qnomchkparam( varargin )
  
  err = '';

  assert( nargin >= 2 );

  lambda = varargin{1};
  
  S = varargin{2};
  
  if ~( isnumeric(lambda) && isvector(lambda) && length(lambda)>0 )
    err = 'lambda must be a nonempty vector';
    return;
  end

  if ( any(lambda<0) )
    err = 'lambda must contain nonnegative values';
    return;
  end

  lambda = lambda(:)';

  C = length(lambda); % Number of classes

  if ~( isnumeric(S) && ismatrix(S) && ndims(S) == 2 && size(S,1) == C )
    err = sprintf('S must be a 2-dimensional matrix with %d rows',C);
    return;
  end

  if ( any(S(:)<0) )
    err = 'S must contain nonnegative values';
    return;
  end

  K = size(S,2);

  if ( nargin < 3 )
    V = ones(size(S));
  else
    V = varargin{3};
    if ~( isnumeric(V) && ismatrix(V) && ndims(V)==2 && size(V,1) == C && size(V,2) == K )
      err = sprintf('V must be a %d x %d matrix', C, K );
      return;
    end

    if ( any(V(:)<0) )
      err = 'V must contain nonnegative values';
      return;
    end
  end

  if ( nargin < 4 ) 
    m = ones(1,K);
  else
    m = varargin{4};
    if ~( isnumeric(m) && isvector(m) && length(m) == K ) 
      err = sprintf('m must be a vector with %d elements', K );
      return;
    end
    m = m(:)';
  end

end
