function delete_model( model )
%DELETE_MODEL Summary of this function goes here
%   Detailed explanation goes here

open(model);
a = find_system(model);
for i = 2:length(a)
    try delete_block(a(i))
    catch continue;
    end
end

l = find_system(model, 'FindAll', 'on', 'type', 'line');

for i = 1:length(l)
    try delete_line(l(i))
    catch continue
    end
end

end

