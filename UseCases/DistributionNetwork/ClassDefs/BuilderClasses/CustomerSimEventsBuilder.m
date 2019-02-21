classdef CustomerSimEventsBuilder < FlowNetworkSimEventsBuilder
    %CUSTOMERSIMULATIONBUILDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods (Access = public)
       function construct(self)
            construct@FlowNetworkSimEventsBuilder(self);
            self.buildCommoditySet;
            self.buildShipmentRouting;
            self.setMetrics;
       end
    end
    
    methods (Access = private)
        function setMetrics(self)
            set_param(strcat(self.simEventsPath, '/Shipment_Metrics'), 'VariableName', self.systemElement.name);
        end
        
        function buildShipmentRouting(self)
            
            if strcmp(self.analysisTypeID, 'Customer_probflow') ==1
                %Check that the probabilities, when converted to 5 sig fig by num2str,
                %add up to one
               probability = round(self.systemElement.routingProbability*10000);
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

               set_param(strcat(self.simEventsPath, '/Routing'), 'probVecDisc', ProbabilityVector, 'valueVecDisc', ValueVector);
            else
                shipmentDestination = findobj(self.systemElement.outFlowEdgeSet, 'typeID', 'Shipment');
                lookup_table = '[';

                for ii = 1:length(shipmentDestination)
                    %shipmentDestination(ii).targetFlowNetwork is a transportation channel
                    if eq(shipmentDestination(ii).targetFlowNetwork.source.instanceID, self.systemElement.instanceID)
                        lookup_table = strcat(lookup_table,',', num2str(shipmentDestination(ii).targetFlowNetwork.target.instanceID));
                    else
                        lookup_table = strcat(lookup_table,',', num2str(shipmentDestination(ii).targetFlowNetwork.source.instanceID));
                    end
                end
                lookup_table = strcat('[',lookup_table(3:end), ']');

                set_param(strcat(self.simEventsPath, '/Lookup'), 'Value', lookup_table);
                set_param(strcat(self.simEventsPath, '/Node_ID'), 'Value', num2str(self.systemElement.instanceID));
            end
        end
        
        function buildCommoditySet(self)
           
            if strcmp(self.analysisTypeID, 'Customer_probflow') %aggregate into one commodity
                set_param(strcat(self.simEventsPath, '/IN_Commodity'), 'NumberInputPorts', num2str(1));
                position = get_param(strcat(self.simEventsPath, '/IN_Commodity'), 'Position') - [400 0 400 0];
                block = add_block(strcat('Distribution_Library/CommoditySource'), strcat(self.simEventsPath,'/AggregateCommodity'), 'Position', position);
                set_param(block, 'LinkStatus', 'none');
                
                set_param(block, 'Mean', strcat('2000/', num2str(sum(self.systemElement.productionRate))));
                set_param(block, 'AttributeValue', strcat('[1 0 1]|1|1|1'));
                
                add_line(self.simEventsPath, 'AggregateCommodity/RConn1', 'IN_Commodity/LConn1');
                
            else % build complete commodity set
                set_param(strcat(self.simEventsPath, '/IN_Commodity'), 'NumberInputPorts', num2str(length(self.systemElement.produces)));
                %for each commodity, add a commodity source
                for ii = 1:length(self.systemElement.produces)
                    position = get_param(strcat(self.simEventsPath, '/IN_Commodity'), 'Position') - [400 0 400 0] + [0 (ii-1)*100 0 (ii-1)*100];
                    %add the block
                    block = add_block(strcat('Distribution_Library/CommoditySource'), strcat(self.simEventsPath,'/Commodity_',...
                        num2str(self.systemElement.produces(ii).instanceID)), 'Position', position);
                    set_param(block, 'LinkStatus', 'none');

                    set_param(block, 'Mean', strcat('2000/', num2str(self.systemElement.produces(ii).Quantity)))
                    %AttributeValue = '[Route]|Origin|Destination|Start'
                    set_param(block, 'AttributeValue', strcat('[',num2str(self.systemElement.produces(ii).Route),']|', num2str(self.systemElement.produces(ii).OriginID), '|', num2str(self.systemElement.produces(ii).DestinationID), '|1'));

                    add_line(self.simEventsPath, strcat('Commodity_', num2str(self.systemElement.produces(ii).instanceID), '/RConn1'), strcat('IN_Commodity/LConn', num2str(ii)));
                end
            end
        end
    end
    
end

