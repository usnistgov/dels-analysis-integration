function [ TransportationChannelSet, FlowEdgeSet ] = mapFlowEdge2TransportationChannel(nodeSet, selectedDepotSet, FlowEdge_Solution )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    %FlowEdge_Solution = Binary FlowEdgeID Origin Destination grossCapacity flowFixedCost
    
    TransportationChannelSet(length(FlowEdge_Solution(1:end-length(selectedDepotSet),1))) = TransportationChannel;
    for ii = 1:length(TransportationChannelSet)
        if FlowEdge_Solution(ii,1) == 1
                TransportationChannelSet(ii).ID = ii+length(nodeSet);
                TransportationChannelSet(ii).Type = 'TransportationChannel_noInfo';
                TransportationChannelSet(ii).Name = strcat('TransportationChannel_', num2str(ii+length(nodeSet)));
                TransportationChannelSet(ii).Echelon = 2;
                TransportationChannelSet(ii).TravelRate = 30;
                TransportationChannelSet(ii).TravelDistance = sqrt(sum((nodeSet(FlowEdge_Solution(ii,3),2:3)-nodeSet(FlowEdge_Solution(ii,4),2:3)).^2));
                %Set Depot as Source; Depots always have higher Node IDs
                if nodeSet(FlowEdge_Solution(ii,3),1)>nodeSet(FlowEdge_Solution(ii,4),1)
                    TransportationChannelSet(ii).Source = nodeSet(FlowEdge_Solution(ii,3),1);
                    TransportationChannelSet(ii).Target = nodeSet(FlowEdge_Solution(ii,4),1);
                else
                    TransportationChannelSet(ii).Source = nodeSet(FlowEdge_Solution(ii,4),1);
                    TransportationChannelSet(ii).Target = nodeSet(FlowEdge_Solution(ii,3),1);
                end

                %Clean-up transportation_channel; set flow edges to 0;
                match = (FlowEdge_Solution(:,3) == FlowEdge_Solution(ii,4) & FlowEdge_Solution(:,4) == FlowEdge_Solution(ii,3));
                FlowEdge_Solution(ii,:)= zeros(1,8);
                if any(match)
                    FlowEdge_Solution(match==1,:)= zeros(1,8);
                end
        end
    end
    
    %Remove extra TransportationChannels from the Set
    %[TransportationChannelSet.Node_ID] only returns properties with value
    TransportationChannelSet = TransportationChannelSet(1:length([TransportationChannelSet.ID]));
    for jj = 1:length(TransportationChannelSet)
        %renumber transportation channel nodes
        TransportationChannelSet(jj).ID = length(nodeSet)+ TransportationChannelSet(jj).ID;
    end

    
    FlowEdgeSet(8*length(TransportationChannelSet)) = FlowEdge;
    jj = 1;
    for ii = 1:length(TransportationChannelSet)
        e2 = TransportationChannelSet(ii).createEdgeSet(selectedDepotSet);
        FlowEdgeSet(jj:jj+length(e2)-1) = e2;
        jj = jj+length(e2);
    end

    FlowEdgeSet = FlowEdgeSet(1:jj-1);
end

