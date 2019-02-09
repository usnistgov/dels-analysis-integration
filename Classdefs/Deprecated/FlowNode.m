classdef FlowNode < Node
    %FLOWNODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Production@Token
        Consumption@Token
        %2/23/18: Can't redefine property type in subclass
        INFlowEdgeSet@FlowEdge %A set of flow edges incoming to the flow node
        OUTFlowEdgeSet@FlowEdge %A set of flow edges outgoing to the flow node
    end
    
    methods
        function addEdge(FN, e)
            if isa(e, 'FlowEdge')
                %Add edges incident to the Node to one of the two sets
                %7/5/16: Switched from If/Elseif to if/if to accomodate self-edges
                if eq(e.Destination, FN.Node_ID) == 1
                %if e.Destination == N.Node_ID
                    FN.INFlowEdgeSet(end+1) = e;
                    e.Destination_Node = FN;
                    FN.EdgeTypeSet{end+1} = e.EdgeType;
                end
                if eq(e.Origin, FN.Node_ID) == 1
                %if e.Origin == N.Node_ID
                    FN.OUTFlowEdgeSet(end+1) = e;
                    e.Origin_Node = FN;
                    FN.EdgeTypeSet{end+1} = e.EdgeType;
                end
                FN.EdgeTypeSet = unique(FN.EdgeTypeSet);
            end
        end
        
        function decorateNode(N)
            buildPorts(N);
        end
        
        function assignPorts(N)
            %Assigns LConn and RConn port numbers to incoming/outgoing
            %edges respectively
            Type_Count = zeros(1,length(N.EdgeTypeSet));
            
            for i = 1:length(N.INFlowEdgeSet)
                N.PortSet(end+1) = Port;
                N.PortSet(end).Owner = N;
                N.PortSet(end).Incident_Edge = N.INFlowEdgeSet(i);
                N.PortSet(end).Type = N.INFlowEdgeSet(i).EdgeType;
                N.PortSet(end).Direction = 'IN';
                N.PortSet(end).Set_Side;
                N.PortSet(end).Number = i;
                N.PortSet(end).Conn = strcat('LConn', num2str(i));
                N.INFlowEdgeSet(i).Destination_Port = N.PortSet(end);
                
                
                for k = 1:length(N.EdgeTypeSet)
                    if strcmp(N.PortSet(end).Type, N.EdgeTypeSet{k}) ==1
                        Type_Count(k) = Type_Count(k) +1;
                        N.PortSet(end).Port_Name = strcat('IN_', N.EdgeTypeSet{k},'_', num2str(Type_Count(k)));
                    end
                end
            end
            
            %if there are no incoming edges, the i needs to be 0 instead of
            %an empty double, which f's up the indexing
            if isempty(N.INFlowEdgeSet) ==1
                i = 0;
            end
            
            Type_Count = zeros(1,length(N.EdgeTypeSet));
            for j = 1:length(N.OUTFlowEdgeSet)
                N.PortSet(end+1) = Port;
                N.PortSet(end).Owner = N;
                N.PortSet(end).Incident_Edge = N.OUTFlowEdgeSet(j);
                N.PortSet(end).Type = N.OUTFlowEdgeSet(j).EdgeType;
                N.PortSet(end).Direction = 'OUT';
                N.PortSet(end).Set_Side;
                N.PortSet(end).Number = i + j;
                N.PortSet(end).Conn = strcat('RConn', num2str(j));
                N.OUTFlowEdgeSet(j).Origin_Port = N.PortSet(end);
                
                
                for k = 1:length(N.EdgeTypeSet)
                    if strcmp(N.PortSet(end).Type, N.EdgeTypeSet{k}) ==1
                        Type_Count(k) = Type_Count(k) +1;
                        N.PortSet(end).Port_Name = strcat('OUT_', N.EdgeTypeSet{k},'_', num2str(Type_Count(k)));
                    end
                end
            end
        end %assignPorts function

        function buildPorts(N)
            % 7/8/16 -- Fix bug to handle nodes with zero ports in or out,
            % e.g. source or sink nodes.
            
            for i = 1:length(N.EdgeTypeSet)
                %IN
                INset = findobj(N.INFlowEdgeSet, 'EdgeType', N.EdgeTypeSet{i});
                if isempty(INset) == 0
                        %INset = findobj(N.INFlowEdgeSet, 'EdgeType', N.EdgeTypeSet{i});
                        set_param(strcat(N.SimEventsPath, '/IN_', N.PortSet(i).Type), 'NumberInputPorts', num2str(length(INset)));
 
                    for j = 1:length(INset) %For Each edge in INset build port
                        try
                            Port = INset(j).Destination_Port;
                            Port.SimEventsPath = strcat(N.SimEventsPath, '/', Port.Port_Name);
                            add_block('simeventslib/SimEvents Ports and Subsystems/Conn', Port.SimEventsPath);
                            set_param(Port.SimEventsPath, 'Port', num2str(Port.Number));
                            set_param(Port.SimEventsPath, 'Side', Port.Side);
                            Port.Set_Position
                            add_line(strcat(N.Model, '/', N.Node_Name), strcat(Port.Direction, '_', Port.Type, '/LConn', num2str(j)), ...
                            strcat(Port.Port_Name,'/RConn1'), 'autorouting', 'on');
                        catch err
                            continue
                        end
                    end
                end
                
                
                %OUT
                OUTset = findobj(N.OUTFlowEdgeSet, 'EdgeType', N.EdgeTypeSet{i});
                if isempty(OUTset) == 0
                    set_param(strcat(N.SimEventsPath, '/OUT_', N.PortSet(i).Type), 'NumberOutputPorts', num2str(length(OUTset)));
               
                    for j = 1:length(OUTset) %For Each edge in OUTset build port
                        try
                            Port = OUTset(j).Origin_Port;
                            Port.SimEventsPath = strcat(N.SimEventsPath, '/', Port.Port_Name);
                            add_block('simeventslib/SimEvents Ports and Subsystems/Conn', Port.SimEventsPath);
                            set_param(Port.SimEventsPath, 'Port', num2str(Port.Number));
                            set_param(Port.SimEventsPath, 'Side', Port.Side);
                            Port.Set_Position
                            add_line(strcat(N.Model, '/', N.Node_Name), strcat(Port.Direction, '_', Port.Type, '/RConn', num2str(j)), ...
                            strcat(Port.Port_Name,'/RConn1'), 'autorouting', 'on');
                        catch err
                            rethrow(err)
                            %continue
                        end
                    end 
                end %End: Check if OUTset is empty
            end %End: For each type of Edge

        end %Role: ConcreteBuilder of Ports
    end
    
end

