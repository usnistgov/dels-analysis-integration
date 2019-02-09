function [ customerNodeSet, commoditySet ] = mapFlowNode2CustomerProbFlow( flowNodeSet, FlowEdge_Solution )
%MAPFLOWNODE2CUSTOMERPROBFLOW Summary of this function goes here
%   Detailed explanation goes here

    numCustomers = length(flowNodeSet(:,1));
    customerNodeSet(numCustomers) = Customer;
    commoditySet = struct('ID', [], 'Origin', [], 'Destination', [], 'Quantity', [], 'Route', []);
    for jj = 1:numCustomers
        customerNodeSet(jj).ID = flowNodeSet(jj,1);
        customerNodeSet(jj).Name = strcat('Customer_', num2str(flowNodeSet(jj,1)));
        customerNodeSet(jj).Echelon = 1;
        customerNodeSet(jj).X = flowNodeSet(jj,2);
        customerNodeSet(jj).Y = flowNodeSet(jj,3);
        customerNodeSet(jj).Type = 'Customer_probflow';
        customerNodeSet(jj).routingProbability = FlowEdge_Solution(FlowEdge_Solution(:,3) == customerNodeSet(jj).ID,8);
    
        %Aggregate the Commodities Into 1 Commodity for Each Customer
        commoditySet(jj).ID = jj;
        commoditySet(jj).OriginID = jj;
        commoditySet(jj).DestinationID = 0;
        commoditySet(jj).Route = 0;
        commoditySet(jj).Quantity = sum(FlowEdge_Solution(FlowEdge_Solution(:,3) == customerNodeSet(jj).ID, 7));
        customerNodeSet(jj).setCommoditySet(commoditySet(jj));
    end

end

