function answer = issquare (S)
    temp = size(S);
    if (length(temp) > 2)
        answer = false;
        return;
    end
    answer = (temp(1) == temp(2));
end

%!test
%! S = eye(2,2);
%! (issquare(S));

%!test
%! S = zeros(2,2);
%! (issquare(S));

%!test
%! S = [1 2 2 1];
%! (~issquare(S));

%!test
%! S = [];
%! (issquare(S));

%!test
%! S = 1;
%! (issquare(S));
