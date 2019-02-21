classdef DepotSimEventsBuilder < FlowNetworkSimEventsBuilder
    %IDEPOTBUILDER Defines the interface or abstract Builder associated
    %with the Depot class. Contains methods for creating depot simulation
    %objects
    
    properties
    end
    
    methods
        function construct(self)
            construct@FlowNetworkSimEventsBuilder(self);
            self.buildShipmentRouting;
            self.buildResourceAllocation;
        end
        
    end
        
    methods (Access = private)
        function buildResourceAllocation(self)
            try find_system(strcat(self.simEventsPath, '/Control: Resource Allocation'));
                %If Depot requires Resource Assignment actuator
                %Other Depot variants use round-robin assignment (no logic block)
                resource_destination = findobj(Depot.OUTEdgeSet, 'EdgeType', 'Resource');
                for i = 1:length(resource_destination)
                    status_block = add_block('simulink/Signal Routing/From', strcat(Depot.SimEventsPath, '/Status_', num2str(i)));
                    set_param(status_block, 'Position',  [950 (i-1)*50 + 150 1000 (i-1)*50 + 175]);
                    add_line(Depot.SimEventsPath, strcat('Status_', num2str(i), '/1'), strcat('Control: Resource Allocation/', num2str(i)));
                    set_param(status_block, 'GotoTag', strcat(resource_destination(i).Destination_Node.Node_Name, '_Status'));
                end
            end
        end
        
        function buildShipmentRouting(self)
            %Need to move the routing into a strategy class
            if strcmp(self.analysisTypeID, 'Depot_probflow') ==1
               probability = round(self.systemElement.routingProbability*10000);
               error = 10000 - sum(probability);
               [Y, I] = max(probability);
               probability(I) = Y + error;
               probability = probability/10000;

               ValueVector = '[0';
               ProbabilityVector = '[0';
               for j = 1:length(probability)
                   ValueVector = strcat(ValueVector, ',' , num2str(j));
                   ProbabilityVector = strcat(ProbabilityVector, ',', num2str(probability(j)));
               end
                   ValueVector = strcat(ValueVector, ']');
                   ProbabilityVector = strcat(ProbabilityVector, ']');

                   %Note to Self: must set values simultaneously to avoid 'equal length' error
                   set_param(strcat(self.simEventsPath, '/Routing'), 'probVecDisc', ProbabilityVector, 'valueVecDisc', ValueVector);
                
            else
                shipment_destination = findobj(self.systemElement.outFlowEdgeSet, 'typeID', 'Shipment');
                lookup_table = '[';

                for ii = 1:length(shipment_destination)
                    %shipment_destination(ii).targetFlowNetwork is a transportation channel
                    if eq(shipment_destination(ii).targetFlowNetwork.source.instanceID, self.systemElement.instanceID)
                        lookup_table = strcat(lookup_table,',', num2str(shipment_destination(ii).targetFlowNetwork.target));
                    else
                        lookup_table = strcat(lookup_table,',', num2str(shipment_destination(ii).targetFlowNetwork.source));
                    end
                end
                lookup_table = strcat('[',lookup_table(3:end), ']');

                set_param(strcat(self.simEventsPath, '/Lookup'), 'Value', lookup_table);
                set_param(strcat(self.simEventsPath, '/Node_ID'), 'Value', num2str(self.systemElement.instanceID));
            end
            
        end
    end
    
end

