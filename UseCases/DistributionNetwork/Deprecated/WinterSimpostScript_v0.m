FlowEdge_solution = [solution(length(FlowEdge_CommoditySet)+1: end), FlowEdgeSet];
commodity_route = [FlowEdge_CommoditySet(solution(1:length(FlowEdge_CommoditySet))>0,1:4), solution(solution(1:length(FlowEdge_CommoditySet))>0)];
%save('MCFNsol_v2_10x10', 'solution', 'arc_solution', 'commodity_route')



gplot(list2adj(commodity_route(:,1:2)), [customerSet(:,2:3); depotSet(:,2:3)])
hold on;
scatter(customerSet(:,2),customerSet(:,3))
scatter(depotSet(:,2),depotSet(:,3), 'filled')
hold off;