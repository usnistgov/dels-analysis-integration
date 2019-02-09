numCustomers = 15;
numDepot = 10;
gridSize = 240; %240 minutes square box, guarantee < 8hour RT
intraDepotDiscount = 0.1;

FlowEdgeSet = struct('Edge_ID', [], 'sourceFlowNode', [], 'targetFlowNode', [], 'flowTypeAllowed', [], 'flowAmount', [], 'flowCapacity', [], ...
    'grossCapacity', [], 'flowFixedCost', [], 'flowUnitCost', []);

%FlowNodeSet = struct('Node_ID', [], 'X', [], 'Y', [], 'Consumption', [], 'Production', []);
CustomerSet = struct('Node_ID', [], 'X', [], 'Y', [], 'Consumption', [], 'Production', []);
DepotSet = struct('Node_ID', [], 'X', [], 'Y', [], 'Consumption', [], 'Production', []);


%Generate Customer Locations
for i = 1:numCustomers
    %[i x y]
    CustomerSet(i).Node_ID = i;
    CustomerSet(i).X = gridSize*rand(1);
    CustomerSet(i).Y = gridSize*rand(1);   
end

%Generate Customer Locations
j = numCustomers+1;
for i = 1:numDepot
    %[i x y]
    min = 0.25*gridSize;
    max = 0.75*gridSize;
    DepotSet(i).Node_ID = j;
    DepotSet(i).X = (max-min)*rand(1) + min;
    DepotSet(i).Y = (max-min)*rand(1) + min;   
    j = j+1;
end

FlowNodeSet = [CustomerSet, DepotSet];
numNodes = numCustomers+numDepot;
numCommodity = (numCustomers-1)*numCustomers;
supply_data = zeros(numNodes*numCommodity, 3);

% arc_data: i j capacity fixed_cost
g = 1;
for i = 1:numNodes
    for j = 1:numNodes
        if eq(i,j)==0
            FlowEdgeSet(g).sourceFlowNode = FlowNodeSet(i).Node_ID;
            FlowEdgeSet(g).targetFlowNode = FlowNodeSet(j).Node_ID;
            FlowEdgeSet(g).grossCapacity = 10e5;
            FlowEdgeSet(g).flowFixedCost = 0.01;
            FlowEdgeSet(g).flowUnitCost = sqrt((FlowNodeSet(FlowEdgeSet(g).sourceFlowNode).X - FlowNodeSet(FlowEdgeSet(g).targetFlowNode).X)^2 + (FlowNodeSet(FlowEdgeSet(g).sourceFlowNode).Y - FlowNodeSet(FlowEdgeSet(g).targetFlowNode).Y)^2);
            g=g+1;
        end
    end
end

%split depots
for i =1:numDepot
    DepotSet(end+1)= DepotSet(end);
    DepotSet(end).Node_ID = DepotSet(end).Node_ID+1;
    a = [FlowEdgeSet.sourceFlowNode];
    index = find(a == DepotSet(i).Node_ID);
    for j = 1:length(index)
        FlowEdgeSet(index(j)).sourceFlowNode = DepotSet(end).Node_ID;
    end
    FlowEdgeSet(end+1).Edge_ID = FlowEdgeSet(end).Edge_ID +1;
    FlowEdgeSet(end).sourceFlowNode = DepotSet(i,1);
    FlowEdgeSet(end).targetFlowNode = DepotSet(end,1);
    FlowEdgeSet(g).grossCapacity = 10e5;
    FlowEdgeSet(g).flowFixedCost = 10e5;
    FlowEdgeSet(g).flowUnitCost = 0;
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






