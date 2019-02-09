numCustomers = 5;
numDepot = 5;
gridSize = 240; %240 minutes square box, guarantee < 8hour RT
intraDepotDiscount = 0.1;

%Generate Customer Locations
customerSet = zeros(numCustomers,3);
customerNodeSet(numCustomers) = Customer;
for i = 1:numCustomers
    %[i x y]
    customerSet(i,:) = [i, gridSize*rand(1), gridSize*rand(1)];
    customerNodeSet(i).Node_ID = customerSet(i,1);
    customerNodeSet(i).Node_Name = strcat('Customer_', num2str(customerSet(i,1)));
    customerNodeSet(i).Echelon = 1;
    customerNodeSet(i).X = customerSet(i,2);
    customerNodeSet(i).Y = customerSet(i,3);
    customerNodeSet(i).Type = 'Customer';
end


%Generate Customer Locations
depotSet = zeros(numDepot,3);
depotNodeSet(numDepot) = Depot;
j = numCustomers+1;
for i = 1:numDepot
    %[i x y]
    min = 0.25*gridSize;
    max = 0.75*gridSize;
    x = (max-min)*rand(1) + min;
    y = (max-min)*rand(1) + min;
    depotSet(i,:) = [j, x, y];
    depotNodeSet(i).Node_ID = depotSet(i,1);
    depotNodeSet(i).Node_Name = strcat('Depot_', num2str(depotSet(i,1)));
    depotNodeSet(i).Echelon = 3;
    depotNodeSet(i).X = depotSet(i,2);
    depotNodeSet(i).Y = depotSet(i,3);
    depotNodeSet(i).Type = 'Depot';
    j = j+1;
end

nodeSet = [customerSet; depotSet];
numNodes = numCustomers+numDepot;
numCommodity = (numCustomers-1)*numCustomers;
supply_data = zeros(numNodes*numCommodity, 3);

% arc_data: i j capacity fixed_cost
nbArc = numNodes*(numNodes-1);
arc_data = zeros(nbArc, 4);
g = 1;
for i = 1:numNodes
    for j = 1:numNodes
        if eq(i,j)==0
            arc_data(g,:) = [nodeSet(i,1), nodeSet(j,1), 10e5, 0.01];
            g=g+1;
        end
    end
end

%split depots
for i =1:numDepot
    depotSet(end+1,:) = [depotSet(end,1)+1, depotSet(i,2), depotSet(i,3)];
    arc_data(arc_data(:,1) == depotSet(i,1)) = depotSet(end,1);
    %arc_comm_data(arc_comm_data(:,1) == depotSet(i,1)) = depotSet(end,1);
    arc_data(end+1,:) = [depotSet(i,1), depotSet(end,1), 10e5, 10000];
end

nodeSet = [customerSet; depotSet];
nbArc = length(arc_data);
numNodes = length(nodeSet);

%supply_data: k i supply
k = 1;
for i = 1:numCustomers
    for j = 1:numCustomers
        if eq(i,j)==0
            supply = randi(1000);      
            supply_data(numNodes*(k-1)+1:numNodes*(k-1)+ numNodes,1) = k;
            supply_data(numNodes*(k-1)+1:numNodes*(k-1)+ numNodes,2) = 1:numNodes;
            supply_data(numNodes*(k-1)+i,3) = supply;
            supply_data(numNodes*(k-1)+j,3) = -1*supply;
            k = k+1;
        end
    end
end

% arc_comm_data: k i j cost
arc_comm_data = zeros(nbArc*numCommodity, 4);
for k = 1:numCommodity
        arc_comm_data((k-1)*nbArc+1:k*nbArc,:) = [k*ones(nbArc,1), arc_data(:,1:2),sqrt((nodeSet(arc_data(:,1),2)-nodeSet(arc_data(:,2),2)).^2 + (nodeSet(arc_data(:,1),3)-nodeSet(arc_data(:,2),3)).^2)];
end


arc_comm_data(arc_comm_data(:,2)>numCustomers & arc_comm_data(:,3)>numCustomers,4) = intraDepotDiscount*arc_comm_data(arc_comm_data(:,2)>numCustomers & arc_comm_data(:,3)>numCustomers,4);


%Flag Customer to Customer Edges
for j= 1:length(arc_comm_data)
    if le(arc_comm_data(j,2), numCustomers) && le(arc_comm_data(j,3), numCustomers)
       arc_comm_data(j,4) = inf; 
    end
end
arc_comm_data = arc_comm_data(arc_comm_data(:,4)<inf,:);


%scatter([customerSet(:,2); depotSet(:,2)], [customerSet(:,3); depotSet(:,3)])
scatter(customerSet(:,2),customerSet(:,3))
hold on;
scatter(depotSet(:,2),depotSet(:,3), 'filled')
hold off;






