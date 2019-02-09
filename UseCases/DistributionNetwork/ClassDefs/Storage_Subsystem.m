classdef Storage_Subsystem < FlowNetwork
    %STORAGE_SUBSYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function buildResourceAllocation(SS)
            resource_destination = findobj(SS.OUTEdgeSet, 'EdgeType', 'Resource');
            for i = 1:length(resource_destination)
                status_block = add_block('simulink/Signal Routing/From', strcat(SS.SimEventsPath, '/Status_', num2str(i)));
                set_param(status_block, 'Position',  [950 (i-1)*50 + 150 1000 (i-1)*50 + 175]);
                add_line(SS.SimEventsPath, strcat('Status_', num2str(i), '/1'), strcat('Control: Resource Allocation/', num2str(i)));
                set_param(status_block, 'GotoTag', strcat(resource_destination(i).Destination_Node.Node_Name, '_Status'));
            end
        end
    end
    
end

