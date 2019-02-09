
%% Calculate Relative Value of Each Storage Location.
A = list2adj([MovementNetwork.EdgeSetList(:, 2:end); StorageNetwork.EdgeSetList(:, 2:end)]);
tic
%PD = find(NodeSetList(:,2) == 0.5*aisle_width+PD_aisle*aisle_width & NodeSetList(:,3) == 0);
PD = findobj(MovementNetwork.NodeSet, 'Type', 'P&D');
D = dijk(A, PD.Node_ID, StorageNetwork.NodeSetList(:,1));
N = length(StorageNetwork.NodeSetList(:,1));
if N > 200
    delta_ij = zeros(N);
        parfor i= 1:N
            delta_ij(i, :) = dijk(A, StorageNetwork.NodeSetList(i,1), StorageNetwork.NodeSetList(:,1));
        end
else
    delta_ij = dijk(A, StorageNetwork.NodeSetList(:,1), StorageNetwork.NodeSetList(:,1));
end
toc

%% Set Up Experiment

% Demand Model
S = 0.2;
N = length(StorageNetwork.NodeSetList);

p = zeros(N,1);
for k = 1:N
    p(k) = (((1+S)*(k/N))/(S+(k/N))) - (((1+S)*((k-1)/N))/(S+((k-1)/N)));
end

%% Random Storage
q = p(randperm(length(p)));

%Expected Single Command
E_SC = 0;

for i = 1:N
   E_SC = E_SC + 2*q(i)*D(i); 
end

E_SC

%Expected Dual Command
E_TB = 0;

for i = 1:N
    for j = 1:N
        E_TB = E_TB + q(i)*q(j)*delta_ij(i,j);
    end
end

E_DC = E_SC + E_TB

%% Sort the Storage Locations by Distance
%Assume the most frequently picked SKUs are assigned to the most desirable
%locations.
[sortedD, I] = sort(D);

E_SC = 0;

for i = 1:N
   E_SC = E_SC + 2*p(i)*sortedD(i); 
end

E_SC

E_TB = 0;

for i = 1:N
    for j = 1:N
        E_TB = E_TB + p(i)*p(j)*delta_ij(I(i),I(j));
    end
end

E_DC = E_SC + E_TB
