FlowEdge_solution = [solution(length(FlowEdge_CommoditySet)+1: end), FlowEdgeSet];
commodity_route = [FlowEdge_CommoditySet(solution(1:length(FlowEdge_CommoditySet))>0,1:4), solution(solution(1:length(FlowEdge_CommoditySet))>0)];
%save('MCFNsol_v2_10x10', 'solution', 'arc_solution', 'commodity_route')


gplot(list2adj(commodity_route(:,1:2)), [customerSet(:,2:3); depotSet(:,2:3)])
hold on;
scatter(customerSet(:,2),customerSet(:,3))
scatter(depotSet(:,2),depotSet(:,3), 'filled')
hold off;

%% MCFN to System Model
Solution = struct('depotSet', [], 'depotNodeSet', [], 'customerSet', [], 'customerNodeSet', [], 'transportationNodeSet', [], 'edgeSet', [], 'transportation_channel_sol', [], 'commoditySet', [], 'resourceSol', [], 'policySol', []);

% Build Customer Set
numCustomers = length(customerSet(:,1));
customerNodeSet(numCustomers) = Customer;
for i = 1:numCustomers
    customerNodeSet(i).Node_ID = customerSet(i,1);
    customerNodeSet(i).Node_Name = strcat('Customer_', num2str(customerSet(i,1)));
    customerNodeSet(i).Echelon = 1;
    customerNodeSet(i).X = customerSet(i,2);
    customerNodeSet(i).Y = customerSet(i,3);
    customerNodeSet(i).Type = 'Customer';
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
    depotNodeSet(i).Type = 'Depot_roundrobin';
end
    

    clear TransportationSet EdgeSet tf1 commodity_set
 
    solution=round(solution);
    FlowEdge_solution = [solution(length(FlowEdge_CommoditySet)+1: end), FlowEdgeSet];
    transportation_channel_sol = FlowEdge_solution(FlowEdge_solution(:,1) ==1,:);
    commoditySet = buildCommoditySet(FlowEdge_CommoditySet,FlowNode_CommoditySet,solution);
    
    % Need a more robust way to find selected Depots
    selectedDepotSet = transportation_channel_sol(transportation_channel_sol(:,5)>1000, 2);
    depotMapping = transportation_channel_sol(transportation_channel_sol(:,5)>1000, 2:3);

    for j = 1:length(depotMapping(:,1))
        transportation_channel_sol(transportation_channel_sol(:,2)==depotMapping(j,2),2) = depotMapping(j,1);
    end

    % Add Transportation Channels for Flow Edges
    j = numCustomers + numDepot+1;
    nodeSet = [customerSet; depotSet];
    TransportationSet(length(transportation_channel_sol(1:end-length(selectedDepotSet),1))) = Transportation_Channel;
    for k = 1:length(TransportationSet)
        if transportation_channel_sol(k,1) == 1
                TransportationSet(j-numCustomers - numDepot).Node_ID = j;
                TransportationSet(j-numCustomers - numDepot).Type = 'Transportation_Channel';
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
                transportation_channel_sol(k,:)= zeros(1,5);
                if any(match)
                    transportation_channel_sol(match==1,:)= zeros(1,5);
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

  
    Solution(i).depotSet = depotSet(selectedDepotSet-numCustomers,:);
    Solution(i).customerSet = customerSet;
    Solution(i).transportation_channel_sol = transportation_channel_sol;
    Solution(i).commoditySet = commoditySet;
    Solution(i).depotNodeSet = depotNodeSet(selectedDepotSet-numCustomers);
    Solution(i).customerNodeSet = customerNodeSet;
    Solution(i).transportationNodeSet = TransportationSet;
    Solution(i).edgeSet = EdgeSet;


%% Build & Run Simulations
model = 'Distribution_v3';
library = 'Distribution_Library';
open(model);
warning('off','all');

delete_model(model);
depotSet = Solution(i).depotNodeSet;
customerSet = Solution(i).customerNodeSet;
commoditySet = Solution(i).commoditySet;
transportationSet = Solution(i).transportationNodeSet;
edgeSet = Solution(i).edgeSet;


buildSimulation(model, library, customerSet, depotSet, transportationSet, edgeSet, commoditySet);
se_randomizeseeds(model, 'Mode', 'All', 'Verbose', 'off');
save_system(model);
simOut = sim(model, 'StopTime', '1000', 'SaveOutput', 'on');

warning('on','all');
