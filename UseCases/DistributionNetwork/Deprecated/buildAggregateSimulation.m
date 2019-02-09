Solution = struct('depotSet', [], 'depotNodeSet', [], 'customerSet', [], 'customerNodeSet', [], 'transportationNodeSet', [], 'edgeSet', [], 'transportation_channel_sol', [], 'commoditySet', [], 'resourceSol', [], 'policySol', []);

clear TransportationSet EdgeSet tf1 commodity_set customerNodeSet depotNodeSet
solution=round(solution);
FlowEdge_solution = [solution(length(FlowEdge_CommoditySet)+1: end), FlowEdgeSet];
transportation_channel_sol = FlowEdge_solution(FlowEdge_solution(:,1) ==1,:);

commodity_route = [FlowEdge_CommoditySet(solution(1:length(FlowEdge_CommoditySet))>0,1:4), solution(solution(1:length(FlowEdge_CommoditySet))>0)];

for i = 1:length(transportation_channel_sol)
    transportation_channel_sol(i,6) = sum(commodity_route(commodity_route(:,1) == transportation_channel_sol(i,2) & commodity_route(:,2) == transportation_channel_sol(i,3), 5));
    transportation_channel_sol(i,7) = transportation_channel_sol(i,6) / sum(commodity_route(commodity_route(:,1) == transportation_channel_sol(i,2), 5));
end


%TO DO: Build commoditySet based on  Aggregate Flows
commoditySet = struct('ID', [], 'Origin', [], 'Destination', [], 'Quantity', [], 'Route', []);

% Need a more robust way to find selected Depots
selectedDepotSet = transportation_channel_sol(transportation_channel_sol(:,5)>1000, 2);
depotMapping = transportation_channel_sol(transportation_channel_sol(:,5)>1000, 2:3);

for j = 1:length(depotMapping(:,1))
    transportation_channel_sol(transportation_channel_sol(:,2)==depotMapping(j,2),2) = depotMapping(j,1);
end

numCustomers = length(customerSet(:,1));
customerNodeSet(numCustomers) = Customer;
for i = 1:numCustomers
    customerNodeSet(i).Node_ID = customerSet(i,1);
    customerNodeSet(i).Node_Name = strcat('Customer_', num2str(customerSet(i,1)));
    customerNodeSet(i).Echelon = 1;
    customerNodeSet(i).X = customerSet(i,2);
    customerNodeSet(i).Y = customerSet(i,3);
    customerNodeSet(i).Type = 'Customer_probflow';
    customerNodeSet(i).routingProbability = transportation_channel_sol(transportation_channel_sol(:,2) == customerSet(i,1),7);
    
    %Aggregate the Commodities Into 1 Commodity for Each Customer
    commoditySet(i).ID = i;
    commoditySet(i).Origin = i;
    commoditySet(i).Quantity = sum(transportation_channel_sol(transportation_channel_sol(:,2) == customerSet(i,1), 6));
    customerNodeSet(i).setCommoditySet(commoditySet(i));
end

% Build Depots
numDepot = length(depotSet(:,1));
depotNodeSet(numDepot) = Depot;
for i = 1:numDepot
    depotNodeSet(i).Node_ID = depotSet(i,1);
    depotNodeSet(i).Node_Name = strcat('Depot_', num2str(depotSet(i,1)));
    depotNodeSet(i).Echelon = 3;
    depotNodeSet(i).X = depotSet(i,2);
    depotNodeSet(i).Y = depotSet(i,3);
    depotNodeSet(i).Type = 'Depot_probflow';
    depotNodeSet(i).routingProbability = transportation_channel_sol(transportation_channel_sol(:,2) == depotSet(i,1) ...
                                                        & transportation_channel_sol(:,5)<1000,7);
end

% Add Transportation Channels for Flow Edges
j = numCustomers + numDepot+1;
nodeSet = [customerSet; depotSet];
TransportationSet(length(transportation_channel_sol(1:end-length(selectedDepotSet),1))) = Transportation_Channel;
for k = 1:length(TransportationSet)
    if transportation_channel_sol(k,1) == 1
            TransportationSet(j-numCustomers - numDepot).Node_ID = j;
            TransportationSet(j-numCustomers - numDepot).Type = 'Transportation_Channel_noInfo';
            TransportationSet(j-numCustomers - numDepot).Node_Name = strcat('Transportation_Channel_', num2str(j));
            TransportationSet(j-numCustomers - numDepot).Echelon = 2;
            TransportationSet(j-numCustomers - numDepot).TravelRate = 30;
            TransportationSet(j-numCustomers - numDepot).TravelDistance = sqrt(sum((nodeSet(transportation_channel_sol(k,2),2:3)-nodeSet(transportation_channel_sol(k,3),2:3)).^2));
            %Set Depot as Source; Depots always have higher Node IDs
            if nodeSet(transportation_channel_sol(k,2),1)>nodeSet(transportation_channel_sol(k,3),1)
                TransportationSet(j-numCustomers - numDepot).Source = nodeSet(transportation_channel_sol(k,2),1);
                TransportationSet(j-numCustomers - numDepot).Target = nodeSet(transportation_channel_sol(k,3),1);
            else
                TransportationSet(j-numCustomers - numDepot).Source = nodeSet(transportation_channel_sol(k,3),1);
                TransportationSet(j-numCustomers - numDepot).Target = nodeSet(transportation_channel_sol(k,2),1);
            end

            %Clean-up transportation_channel; set flow edges to 0;
            match = (transportation_channel_sol(:,2) == transportation_channel_sol(k,3) & transportation_channel_sol(:,3) == transportation_channel_sol(k,2));
            transportation_channel_sol(k,:)= zeros(1,7);
            if any(match)
                transportation_channel_sol(match==1,:)= zeros(1,7);
            end
        j = j+1;
    end
end

TransportationSet = TransportationSet(1:j-numCustomers - numDepot-1);
EdgeSet(8*length(TransportationSet)) = Edge;
k = 1;
for j = 1:length(TransportationSet)
    e2 = TransportationSet(j).createEdgeSet(selectedDepotSet);
    EdgeSet(k:k+length(e2)-1) = e2;
    k = k+length(e2);
end

EdgeSet = EdgeSet(1:k-1);


Solution(1).depotSet = depotSet(selectedDepotSet-numCustomers,:);
Solution(1).customerSet = customerSet;
Solution(1).transportation_channel_sol = transportation_channel_sol;
Solution(1).commoditySet = commoditySet;
Solution(1).depotNodeSet = depotNodeSet(selectedDepotSet-numCustomers);
Solution(1).customerNodeSet = customerNodeSet;
Solution(1).transportationNodeSet = TransportationSet;
Solution(1).edgeSet = EdgeSet;

%% Build & Run Simulations
model = 'Distribution';
library = 'Distribution_Library';
open(model);
warning('off','all');
%MCGA_solution = 4*ones(1,5);


for i = 1:length(Solution)
    delete_model(model);
    
    %simOut = sim(model, 'StopTime', '1000', 'SaveOutput', 'on');
    save_system(model);
    [df1, cf1, tf1, ef1] = buildSimulation(model, library, Solution(i).customerNodeSet, Solution(i).depotNodeSet, Solution(i).transportationNodeSet, Solution(i).edgeSet, Solution(i).commoditySet);
    se_randomizeseeds(model, 'Mode', 'All', 'Verbose', 'off');
end