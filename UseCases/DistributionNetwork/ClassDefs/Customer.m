classdef Customer < FlowNetwork
    %CUSTOMER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        routingProbability %Placeholder for value until move routing to stategy class
    end
    
    methods (Access = public)
        function self = Customer(input)
            %Input := instanceID X Y
           if nargin == 0
               % default constructor
           else
               self.instanceID = input(1);
               self.X = input(2);
               self.Y = input(3);
           end
        end
        
        
        function setCommoditySet(C, commoditySet)
            C.commoditySet = commoditySet([commoditySet.OriginID] == C.instanceID);
        end
        
        function decorateNode(C)
            decorateNode@FlowNetwork(C);
            C.buildCommoditySet;
            C.setMetrics;
            C.buildShipmentRouting;
        end
        

    end
    
    methods (Access = private)
        function setMetrics(C)
            set_param(strcat(C.SimEventsPath, '/Shipment_Metrics'), 'VariableName', C.name);
        end
        
        function buildShipmentRouting(C)
            
            if strcmp(C.Type, 'Customer_probflow') ==1
                %Check that the probabilities, when converted to 5 sig fig by num2str,
                %add up to one
               probability = round(C.routingProbability*10000);
               error = 10000 - sum(probability);
               [Y, I] = max(probability);
               probability(I) = Y + error;
               probability = probability/10000;


               ValueVector = '[0';
               ProbabilityVector = '[0';
               for jj = 1:length(probability)
                   ValueVector = strcat(ValueVector, ',' , num2str(jj));
                   ProbabilityVector = strcat(ProbabilityVector, ',', num2str(probability(jj)));
               end
               
               ValueVector = strcat(ValueVector, ']');
               ProbabilityVector = strcat(ProbabilityVector, ']');

               set_param(strcat(C.SimEventsPath, '/Routing'), 'probVecDisc', ProbabilityVector, 'valueVecDisc', ValueVector);
            else
                shipmentDestination = findobj(C.OUTFlowEdgeSet, 'EdgeType', 'Shipment');
                lookup_table = '[';

                for ii = 1:length(shipmentDestination)
                    if eq(shipmentDestination(ii).Destination_Node.SourceID, C.instanceID) == 1
                        lookup_table = strcat(lookup_table,',', num2str(shipmentDestination(ii).Destination.Target));
                    else
                        lookup_table = strcat(lookup_table,',', num2str(shipmentDestination(ii).Destination.Source));
                    end
                end
                lookup_table = strcat('[',lookup_table(3:end), ']');

                set_param(strcat(C.SimEventsPath, '/Lookup'), 'Value', lookup_table);
                set_param(strcat(C.SimEventsPath, '/Node_ID'), 'Value', num2str(C.instanceID));
            end
        end
        
        function buildCommoditySet(C)
           set_param(strcat(C.SimEventsPath, '/IN_Commodity'), 'NumberInputPorts', num2str(length(C.commoditySet)));


            for ii = 1:length(C.commoditySet)
                position = get_param(strcat(C.SimEventsPath, '/IN_Commodity'), 'Position') - [400 0 400 0] + [0 (ii-1)*100 0 (ii-1)*100];
                %add the block
                block = add_block(strcat('Distribution_Library/CommoditySource'), strcat(C.SimEventsPath,'/Commodity_',...
                    num2str(C.commoditySet(ii).instanceID)), 'Position', position);
                set_param(block, 'LinkStatus', 'none');

                set_param(block, 'Mean', strcat('2000/', num2str(C.commoditySet(ii).Quantity)))
                %AttributeValue = '[Route]|Origin|Destination|Start'
                set_param(block, 'AttributeValue', strcat('[',num2str(C.commoditySet(ii).Route),']|', num2str(C.commoditySet(ii).OriginID), '|', num2str(C.commoditySet(ii).DestinationID), '|1'));

                add_line(C.SimEventsPath, strcat('Commodity_', num2str(C.commoditySet(ii).instanceID), '/RConn1'), strcat('IN_Commodity/LConn', num2str(ii)));
            end
        end
    end
    
end

