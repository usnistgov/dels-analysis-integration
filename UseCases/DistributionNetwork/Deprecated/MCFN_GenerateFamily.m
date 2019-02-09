%% Build and Run Optimizations
%[fn1, customerSet, depotSet] = DistributionFlowNetworkGenerator;
fn1.solveMultiCommodityFlowNetwork;
flowNetworkSet = GenerateFlowNetworkSet( fn1, depotSet(1:length(depotSet)/2,:), 1e6);


Solution = struct('depotSet', [], 'depotNodeSet', [], 'customerSet', [], 'customerNodeSet', [], 'transportationNodeSet', [], 'edgeSet', [], 'transportation_channel_sol', [], 'commoditySet', [], 'resourceSol', [], 'policySol', []);
%% MCFN to System Model
%TO DO: Support the generation of an aggregate probabilistic flow simulation.

for ii = 1:length(flowNetworkSet)
    clear customerNodeSet depotNodeSet TransportationSet EdgeSet tf1 commodity_set
    commoditySet = struct('ID', [], 'Origin', [], 'Destination', [], 'Quantity', [], 'Route', []);
    
    %transportation_channel_sol = Binary Origin Destination grossCapacity flowFixedCost
    transportation_channel_sol = flowNetworkSet(ii).FlowEdge_Solution(flowNetworkSet(ii).FlowEdge_Solution(:,1) ==1,:);
    transportation_channel_sol(:,2) = []; %Drop FlowEdgeID for now
    
    commodity_route = flowNetworkSet(ii).commodityFlowSolution(:, 2:end); %drop FlowEdgeID for now
    
    for j = 1:length(transportation_channel_sol)
        transportation_channel_sol(j,6) = sum(commodity_route(commodity_route(:,1) == transportation_channel_sol(j,2) & commodity_route(:,2) == transportation_channel_sol(j,3), 5));
        transportation_channel_sol(j,7) = transportation_channel_sol(j,6) / sum(commodity_route(commodity_route(:,1) == transportation_channel_sol(j,2), 5));
    end
    
    % Need a more robust way to find selected Depots
    %SelectedDepotSetIndex = find(fn1.FlowEdge_Solution(:,1) == 1 & ismember(fn1.FlowEdge_Solution(:,3), depotSet(1:length(depotSet)/2)) ==1);
    selectedDepotSet = transportation_channel_sol(transportation_channel_sol(:,5)>=depotFixedCost, 2);
    depotMapping = transportation_channel_sol(transportation_channel_sol(:,5)>=depotFixedCost, 2:3);

    for j = 1:length(depotMapping(:,1))
        transportation_channel_sol(transportation_channel_sol(:,2)==depotMapping(j,2),2) = depotMapping(j,1);
    end

    % Build Customer Set
    numCustomers = length(customerSet(:,1));
    customerNodeSet(numCustomers) = Customer;
    for j = 1:numCustomers
        customerNodeSet(j).Node_ID = customerSet(j,1);
        customerNodeSet(j).Node_Name = strcat('Customer_', num2str(customerSet(j,1)));
        customerNodeSet(j).Echelon = 1;
        customerNodeSet(j).X = customerSet(j,2);
        customerNodeSet(j).Y = customerSet(j,3);
        customerNodeSet(j).Type = 'Customer_probflow';
        customerNodeSet(j).routingProbability = transportation_channel_sol(transportation_channel_sol(:,2) == customerSet(j,1),7);
    
        %Aggregate the Commodities Into 1 Commodity for Each Customer
        commoditySet(j).ID = j;
        commoditySet(j).Origin = j;
        commoditySet(j).Destination = 0;
        commoditySet(j).Route = 0;
        commoditySet(j).Quantity = sum(transportation_channel_sol(transportation_channel_sol(:,2) == customerSet(j,1), 6));
        customerNodeSet(j).setCommoditySet(commoditySet(j));
    end

    % Build Depots
    numDepot = length(depotSet(:,1));
    depotNodeSet(numDepot) = Depot;
    for j = 1:numDepot
        depotNodeSet(j).Node_ID = depotSet(j,1);
        depotNodeSet(j).Node_Name = strcat('Depot_', num2str(depotSet(j,1)));
        depotNodeSet(j).Echelon = 3;
        depotNodeSet(j).X = depotSet(j,2);
        depotNodeSet(j).Y = depotSet(j,3);
        depotNodeSet(j).Type = 'Depot_probflow';
        depotNodeSet(j).routingProbability = transportation_channel_sol(transportation_channel_sol(:,2) == depotSet(j,1) ...
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

  
    Solution(ii).depotSet = depotSet(selectedDepotSet-numCustomers,:);
    Solution(ii).customerSet = customerSet;
    Solution(ii).transportation_channel_sol = transportation_channel_sol;
    Solution(ii).commoditySet = commoditySet;
    Solution(ii).depotNodeSet = depotNodeSet(selectedDepotSet-numCustomers);
    Solution(ii).customerNodeSet = customerNodeSet;
    Solution(ii).transportationNodeSet = TransportationSet;
    Solution(ii).edgeSet = EdgeSet;
end

%% Build and Run Low-Fidelity Simulations
for ii = 1:length(Solution)
    % Build & Run Simulations
    model = 'Distribution';
    library = 'Distribution_Library';
    open(model);
    warning('off','all');

    delete_model(model);
    buildSimulation(model, library, ...
        Solution(ii).customerNodeSet, Solution(ii).depotNodeSet, Solution(ii).transportationNodeSet, Solution(ii).edgeSet, Solution(ii).commoditySet);
    se_randomizeseeds(model, 'Mode', 'All', 'Verbose', 'off');
    save_system(model);
    close_system(model,1);
    solution = MultiGA_Distribution(model, Solution(ii).customerNodeSet, Solution(ii).depotNodeSet, 1000*ones(length(Solution(ii).depotNodeSet),1), [], 'true');
    Solution(ii).resourceSol = solution;
    clear MultiGA_Distribution;
    strcat('complete: ', num2str(ii))
end

%% Control Policy
for ii = 1:length(MCFN_solution(1,:))
    clear customerNodeSet depotNodeSet TransportationSet EdgeSet tf1 commodity_set

    % Build Customer Set
    numCustomers = length(customerSet(:,1));
    customerNodeSet(numCustomers) = Customer;
    for j = 1:numCustomers
        customerNodeSet(j).Node_ID = customerSet(j,1);
        customerNodeSet(j).Node_Name = strcat('Customer_', num2str(customerSet(j,1)));
        customerNodeSet(j).Echelon = 1;
        customerNodeSet(j).X = customerSet(j,2);
        customerNodeSet(j).Y = customerSet(j,3);
        customerNodeSet(j).Type = 'Customer';
    end

    % Build Depots
    numDepot = length(depotSet(:,1));
    depotNodeSet(numDepot) = Depot;
    for j = 1:numDepot
        depotNodeSet(j).Node_ID = depotSet(j,1);
        depotNodeSet(j).Node_Name = strcat('Depot_', num2str(depotSet(j,1)));
        depotNodeSet(j).Echelon = 3;
        depotNodeSet(j).X = depotSet(j,2);
        depotNodeSet(j).Y = depotSet(j,3);
        depotNodeSet(j).Type = 'Depot';
    end
    
    solution = MCFN_solution(:,ii);
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

  
    Solution(ii).depotSet = depotSet(selectedDepotSet-numCustomers,:);
    Solution(ii).customerSet = customerSet;
    Solution(ii).transportation_channel_sol = transportation_channel_sol;
    Solution(ii).commoditySet = commoditySet;
    Solution(ii).depotNodeSet = depotNodeSet(selectedDepotSet-numCustomers);
    Solution(ii).customerNodeSet = customerNodeSet;
    Solution(ii).transportationNodeSet = TransportationSet;
    Solution(ii).edgeSet = EdgeSet;
end 

%% Build and Run High-Fidelity Simulations
for ii = 1:length(Solution)
    model = 'Distribution';
    library = 'Distribution_Library';
    open(model);
    warning('off','all');
    delete_model(model);

    buildSimulation(model, library, ...
        Solution(ii).customerNodeSet, Solution(ii).depotNodeSet, Solution(ii).transportationNodeSet, Solution(ii).edgeSet, Solution(ii).commoditySet);
    se_randomizeseeds(model, 'Mode', 'All', 'Verbose', 'off');
    save_system(model);
    close_system(model,1);

    Solution(ii).policySol = Distribution_Pareto(model, Solution(ii).customerNodeSet, Solution(ii).depotNodeSet, Solution(ii).transportationNodeSet, Solution(ii).resourceSol, 1000*ones(length(Solution(ii).resourceSol(1,:)),1));
    save GenerateFamily.mat;
    strcat('complete: ', num2str(ii))
end

%% Pareto Analysis

TravelDist = [reshape(Solution(1).policySol(:,:,1), [],1); reshape(Solution(2).policySol(:,:,1), [],1); reshape(Solution(3).policySol(:,:,1), [],1); reshape(Solution(4).policySol(:,:,1), [],1); reshape(Solution(5).policySol(:,:,1), [],1)];
ResourceInvestment =  [reshape(Solution(1).policySol(:,:,3), [],1); reshape(Solution(2).policySol(:,:,3), [],1); reshape(Solution(3).policySol(:,:,3), [],1); reshape(Solution(4).policySol(:,:,3), [],1); reshape(Solution(5).policySol(:,:,3), [],1)];
ServiceLevel =  1.-[reshape(Solution(1).policySol(:,:,2), [],1); reshape(Solution(2).policySol(:,:,2), [],1); reshape(Solution(3).policySol(:,:,2), [],1); reshape(Solution(4).policySol(:,:,2), [],1); reshape(Solution(5).policySol(:,:,2), [],1)];
paretoI = paretoGroup([TravelDist, ResourceInvestment, ServiceLevel]);

scatter3( TravelDist(paretoI), ResourceInvestment(paretoI), 1.-ServiceLevel(paretoI));

warning('on','all');
