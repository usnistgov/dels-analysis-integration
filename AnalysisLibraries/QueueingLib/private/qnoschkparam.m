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
% @deftypefn {Function File} {[@var{err} @var{lambda} @var{S} @var{V} @var{m}] = } qnoschkparam( lambda, S, V, m )
%
% Validate input parameters for open, single class networks.
% @var{err} is the empty string on success, or a suitable error message
% string on failure.
%
% @end deftypefn

% Author: Moreno Marzolla <moreno.marzolla(at)unibo.it>
% Web: http://www.moreno.marzolla.name/

function [err, lambda, S, V, m] = qnoschkparam( varargin )
  
  err = '';

  assert( nargin >= 2 );

  lambda = varargin{1};

  S = varargin{2};

  %[V, m] = varargin{3:4};

  if ~( isscalar(lambda) && lambda > 0 )
    err = 'lambda must be a positive scalar';  
    return;
  end

  if ~( isnumeric(S) && isvector(S) && isempty(S)==0 )
    err = 'S must be a nonempty vector';
    return;
  end

  if ( any(S<0) )
    err = 'S must contain nonnegative values';
    return;
  end

  S = S(:)';

  if ( nargin < 3 )
    V = ones(size(S));
  else
    V = varargin{3};

    if ~( isnumeric(V) && isvector(V) )
      err =  'V must be a vector';
      return;
    end
    if ( any(V<0) )
      err =  'V must contain nonnegative values';
      return;
    end
    V = V(:)';
  end

  if ( nargin < 4 ) 
    m = ones(size(S));
  else
    m = varargin{4};

    if ~( isnumeric(m) && isvector(m) )
      err = 'm must be a vector';
      return;
    end
    m = m(:)';
  end

  [er, S, V, m] = common_size(S, V, m);
  if (er ~= 0 )
    err = 'S, V and m are of incompatible size';
    return;
  end

end
