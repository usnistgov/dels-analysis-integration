function [ commoditySet ] = mapFlowCommodity2Commodity(flowNetwork)
%mapFlowCommodity2Commodity maps the Flow Network Commodity to Distribution Network Commodity
%Eventually should transition to mapping to Product with Route being the proces plan

%Initialize the struct (ie specify the classdef)
commoditySet = struct('ID', [], 'OriginID', [], 'DestinationID', [], 'Quantity', [], 'Route', []);
FlowNode_CommoditySet = flowNetwork.FlowNode_ConsumptionProduction;
commodityFlow_Solution = flowNetwork.commodityFlow_Solution;

%commodityFlowSolution %FlowEdgeID origin destination commodity flowUnitCost flowQuantity

for ii = 1:max(FlowNode_CommoditySet(:,2))
   commoditySet(ii).ID = ii;
   commoditySet(ii).OriginID = FlowNode_CommoditySet(FlowNode_CommoditySet(:,2) == ii & FlowNode_CommoditySet(:,3)>0,1);
   commoditySet(ii).DestinationID = FlowNode_CommoditySet(FlowNode_CommoditySet(:,2) == ii & FlowNode_CommoditySet(:,3)<0,1);
   commoditySet(ii).Quantity =  FlowNode_CommoditySet(FlowNode_CommoditySet(:,2) == ii & FlowNode_CommoditySet(:,3)>0,3);
   commoditySet(ii).Route = buildCommodityRoute(commodityFlow_Solution(commodityFlow_Solution(:,4) == ii,2:6));
   %Should return later to generalize to support production/consumption of
   %each commodity at each node.
end

%Return to call commodity constructor prior to MCNF
%then call buildCommodityRoute after MCNF


end

function route = buildCommodityRoute(commodityFlowSolution)
%Commodity_Route is a set of arcs that the commodity flows on
%need to assemble the arcs into a route or path

i = 1;
route = commodityFlowSolution(i,1:2);
while sum(commodityFlowSolution(:,1) == commodityFlowSolution(i,2))>0
    i = find(commodityFlowSolution(:,1) == commodityFlowSolution(i,2));
    if eq(commodityFlowSolution(i,4),0)==0
        route = [route, commodityFlowSolution(i,2)];
    end
end
%NOTE: Need a better solution to '10', it should be 2+numDepot
while length(route)<6
    route = [route, 0];
end

end

