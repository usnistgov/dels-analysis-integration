classdef IDepotBuilder < IFlowNetworkBuilder
    %IDEPOTBUILDER Defines the interface or abstract Builder associated
    %with the Depot class. Contains methods for creating depot simulation
    %objects
    
    properties
    end
    
    methods
        function Construct(self, FlowNetwork)
            Construct@IFlowNetworkBuilder(self, FlowNetwork);
            self.buildShipmentRouting(FlowNetwork);
            self.buildResourceAllocation(FlowNetwork);
        end
        
    end
        
    methods (Access = private)
        function buildResourceAllocation(self, Depot)
            try find_system(strcat(Depot.SimEventsPath, '/Control: Resource Allocation'));
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
        
        function buildShipmentRouting(self, Depot)
            %Need to move the routing into a strategy class
            if strcmp(Depot.Type, 'Depot_probflow') ==1
               probability = round(Depot.routingProbability*10000);
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
                   set_param(strcat(Depot.SimEventsPath, '/Routing'), 'probVecDisc', ProbabilityVector, 'valueVecDisc', ValueVector);
                
            else
                shipment_destination = findobj(Depot.OUTEdgeSet, 'EdgeType', 'Shipment');
                lookup_table = '[';

                for i = 1:length(shipment_destination)
                    if eq(shipment_destination(i).Destination_Node.Source, Depot.Node_ID) == 1
                        lookup_table = strcat(lookup_table,',', num2str(shipment_destination(i).Destination_Node.Target));
                    else
                        lookup_table = strcat(lookup_table,',', num2str(shipment_destination(i).Destination_Node.Source));
                    end
                end
                lookup_table = strcat('[',lookup_table(3:end), ']');

                set_param(strcat(Depot.SimEventsPath, '/Lookup'), 'Value', lookup_table);
                set_param(strcat(Depot.SimEventsPath, '/Node_ID'), 'Value', num2str(Depot.Node_ID));
            end
            
        end
    end
    
end

