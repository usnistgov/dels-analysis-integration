transportation_channel_sol = FlowEdge_solution(FlowEdge_solution(:,1) ==1,:);
commodity_route = [FlowEdge_CommoditySet(solution(1:length(FlowEdge_CommoditySet))>0,1:4), solution(solution(1:length(FlowEdge_CommoditySet))>0)];

for i = 1:length(transportation_channel_sol)
    transportation_channel_sol(i,6) = sum(commodity_route(commodity_route(:,1) == transportation_channel_sol(i,2) & commodity_route(:,2) == transportation_channel_sol(i,3), 5));
    transportation_channel_sol(i,7) = transportation_channel_sol(i,6) / sum(commodity_route(commodity_route(:,1) == transportation_channel_sol(i,2), 5));
end

selectedDepotSet = transportation_channel_sol(transportation_channel_sol(:,5)>1000, 2);
depotMapping = transportation_channel_sol(transportation_channel_sol(:,5)>1000, 2:3);

depotNodeSet = depotNodeSet(selectedDepotSet-numCustomers);

for j = 1:length(depotMapping(:,1))
    transportation_channel_sol(transportation_channel_sol(:,2)==depotMapping(j,2),2) = depotMapping(j,1);
end



