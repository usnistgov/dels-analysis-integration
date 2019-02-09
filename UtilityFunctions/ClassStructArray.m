tic;
s2(10e6) = Node;
for i = 1:10e6
    s2(i).Node_ID = i;
end

for i = 1:length(s2)
    s2(i).Node_ID;
end
toc;

tic;
s1 = struct('ID', []);
for i = 1:10e6
    s1(i).ID = i;
end

for i = 1:length(s1)
    s1(i).ID;
end
toc;

tic;
s3 = zeros(10e6,1);
for i = 1:10e6
    s3(i)= i;
end

for i = 1:length(s3)
    s3(i);
end
toc;