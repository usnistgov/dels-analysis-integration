A = round(Generated.signals.values);
y = prctile(sum(A,2), 90)
X = (sum(A,2)<200);
A = A(X,:);
A = [A(1:3000,:); A(3000:6000,1:2) zeros(3001,1); zeros(3001,1) A(6000:9000, 2:3)]
SymboticOrderGenerator(A)
OrderSet = ans
mean(OrderSet(:,1))
mean(OrderSet(:,2))
mean(OrderSet(:,3))
std(OrderSet(:,1))
std(OrderSet(:,2))
std(OrderSet(:,3))
