% Copyright (C) 2014 Moreno Marzolla
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
% @deftypefn {Function File} {@var{C} =} erlangc (@var{A}, @var{m})
%
% @cindex Erlang-C formula
%
% Compute the steady-state probability @math{E_C(A, m)} that an open
% queueing system with @math{m} identical servers, infinite wating
% space, arrival rate @math{\lambda}, individual service rate
% @math{\mu} and offered load @math{A = \lambda / \mu} has all the
% servers busy.
%
% @tex
% @math{E_C(A, m)} is defined as:
%
% $$
% E_C(A, m) = \displaystyle{ {A^m \over m!} {1 \over 1-\rho} \left( \sum_{k=0}^{m-1} {A^k \over k!} + {A^m \over m!} {1 \over 1 - \rho} \right) ^{-1}}
% $$
%
% where @math{\rho = A / m = \lambda / (m \mu)}.
% @end tex
%
% @strong{INPUTS}
%
% @table @var
%
% @item A Offered load. @math{A = \lambda / \mu} where
% @math{\lambda} is the mean arrival rate and @math{\mu} the mean
% service rate of each individual server (real, @math{0 < A < m}).
%
% @item m Number of identical servers (integer, @math{m @geq{} 1}).
% Default @math{m = 1}
%
% @end table
%
% @strong{OUTPUTS}
%
% @table @var
%
% @item B The value @math{E_C(A, m)}
%
% @end table
%
% @var{A} or @var{m} can be vectors, and in this case, the results will
% be vectors as well.
%
% @seealso{qsmmm}
%
% @end deftypefn

% Author: Moreno Marzolla <moreno.marzolla(at)unibo.it>
% Web: http://www.moreno.marzolla.name/
function C = erlangc(A, m)
  if ( nargin < 1 || nargin > 2 )
    error('Please use the correct number of inputs');
  end

  assert( isnumeric(A) && all(A(:) > 0), 'A must be positive');
   
  if ( nargin == 1 )
    m = 1;
  else
    assert( isnumeric(m) && all( fix(m(:)) == m(:)) && all( m(:) > 0 ), 'm must be a positive integer');
  end
  
  [err, A, m] = common_size(A, m);
  if ( err )
    error('parameters are not of common size');
  end
  
  assert(all( A(:) < m(:) ), 'A must be < m');
   
  rho = A ./ m;
  B = erlangb(A, m);
  C = B ./ (1 - rho .* (1 - B));
end

%!test
%! fail("erlangc('foo',1)", "positive");
%! fail("erlangc(1,'bar')", "positive");
