%solution = MultiCommodityFlow_v2(arc_comm_data, arc_data, supply_data);
solution=round(solution);
arc_solution = [solution(length(arc_comm_data)+1: end), arc_data];
transportation_channel_sol = arc_solution(arc_solution(:,1) ==1,:);
clear depotNodeSet customerNodeSet TransportationSet EdgeSet df1 cf1 tf1

%% Build Customer Set
customerNodeSet(numCustomers) = Customer;
for i = 1:numCustomers
    customerNodeSet(i).Node_ID = customerSet(i,1);
    customerNodeSet(i).Node_Name = strcat('Customer_', num2str(customerSet(i,1)));
    customerNodeSet(i).Echelon = 1;
    customerNodeSet(i).X = customerSet(i,2);
    customerNodeSet(i).Y = customerSet(i,3);
    customerNodeSet(i).Type = 'Customer';
end

%% Build Depots
depotNodeSet(numDepot) = Depot;
for i = 1:numDepot
    depotNodeSet(i).Node_ID = depotSet(i,1);
    depotNodeSet(i).Node_Name = strcat('Depot_', num2str(depotSet(i,1)));
    depotNodeSet(i).Echelon = 3;
    depotNodeSet(i).X = depotSet(i,2);
    depotNodeSet(i).Y = depotSet(i,3);
    depotNodeSet(i).Type = 'Depot';
end
selectedDepotSet = transportation_channel_sol(transportation_channel_sol(:,5)>1000, 2);
depotMapping = transportation_channel_sol(transportation_channel_sol(:,5)>1000, 2:3);

for i = 1:length(depotMapping)
    transportation_channel_sol(transportation_channel_sol(:,2)==depotMapping(i,2),2) = depotMapping(i,1);
end

%% Add Transportation Channels for Flow Edges
j = numCustomers + numDepot+1;
TransportationSet(length(transportation_channel_sol(1:end-length(selectedDepotSet),1))) = Transportation_Channel;
for i = 1:length(TransportationSet)
    if transportation_channel_sol(i,1) == 1
            TransportationSet(j-numCustomers - numDepot).Node_ID = j;
            TransportationSet(j-numCustomers - numDepot).Type = 'Transportation_Channel';
            TransportationSet(j-numCustomers - numDepot).Node_Name = strcat('Transportation_Channel_', num2str(j));
            TransportationSet(j-numCustomers - numDepot).Echelon = 2;
            TransportationSet(j-numCustomers - numDepot).TravelRate = 30;
            TransportationSet(j-numCustomers - numDepot).TravelDistance = sqrt(sum((nodeSet(transportation_channel_sol(i,2),2:3)-nodeSet(transportation_channel_sol(i,3),2:3)).^2));
            %Set Depot as Source; Depots always have higher Node IDs
            if nodeSet(transportation_channel_sol(i,2),1)>nodeSet(transportation_channel_sol(i,3),1)
                TransportationSet(j-numCustomers - numDepot).Source = nodeSet(transportation_channel_sol(i,2),1);
                TransportationSet(j-numCustomers - numDepot).Target = nodeSet(transportation_channel_sol(i,3),1);
            else
                TransportationSet(j-numCustomers - numDepot).Source = nodeSet(transportation_channel_sol(i,3),1);
                TransportationSet(j-numCustomers - numDepot).Target = nodeSet(transportation_channel_sol(i,2),1);
            end

            %Clean-up transportation_channel; set flow edges to 0;
            match = (transportation_channel_sol(:,2) == transportation_channel_sol(i,3) & transportation_channel_sol(:,3) == transportation_channel_sol(i,2));
            transportation_channel_sol(i,:)= zeros(1,5);
            if any(match)
                transportation_channel_sol(match==1,:)= zeros(1,5);
            end
        j = j+1;
    end
end


TransportationSet = TransportationSet(1:j-numCustomers - numDepot-1);
EdgeSet(8*length(TransportationSet)) = Edge;
k = 1;
for i = 1:length(TransportationSet)
    e2 = TransportationSet(i).createEdgeSet(selectedDepotSet);
    EdgeSet(k:k+length(e2)-1) = e2;
    k = k+length(e2);
end
            
EdgeSet = EdgeSet(1:k-1);

%% Build Simulation
tf1 = NodeFactory('Transportation_Channel');
tf1.NodeSet = TransportationSet;
tf1.allocate_edges(EdgeSet);

df1 = NodeFactory('Depot');
df1.NodeSet = depotNodeSet(selectedDepotSet-numCustomers);
df1.allocate_edges(EdgeSet);

cf1 = NodeFactory('Customer');
cf1.NodeSet = customerNodeSet;
cf1.allocate_edges(EdgeSet);

tf1.Model = 'Distribution_v2';
tf1.Library = 'Distribution_Library';
df1.Model = 'Distribution_v2';
df1.Library = 'Distribution_Library';
cf1.Model = 'Distribution_v2';
cf1.Library = 'Distribution_Library';

tf1.CreateNodes;
for i = 1:length(tf1.NodeSet)
   for j = 1:length(tf1.NodeSet(i).PortSet)
       tf1.NodeSet(i).PortSet(j).Set_PortNum;
       tf1.NodeSet(i).setTravelTime;
       tf1.NodeSet(i).buildStatusMetric;
   end
end

df1.CreateNodes;
for i = 1:length(df1.NodeSet)
    df1.NodeSet(i).buildResourceAllocation;
    df1.NodeSet(i).buildShipmentRouting;
end

cf1.CreateNodes;

commodity_set = buildCommoditySet(arc_comm_data,supply_data,solution);
for i = 1:length(customerNodeSet)
    customerNodeSet(i).setCommoditySet(commodity_set);
    customerNodeSet(i).buildCommoditySet;
    customerNodeSet(i).setMetrics;
end

ef1=EdgeFactory;
ef1.Model = 'Distribution_v2';
ef1.EdgeSet = EdgeSet;
ef1.CreateEdges;