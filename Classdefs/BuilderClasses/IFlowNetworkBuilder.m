classdef IFlowNetworkBuilder
    %IFLOWNETWORKBUILDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function Construct(self, FlowNetwork)
            self.assignPorts(FlowNetwork);
            self.buildPorts(FlowNetwork); 
        end
        
        function assignPorts(self,FlowNetwork)
            %Assigns LConn and RConn port numbers to incoming/outgoing
            %edges respectively
            TypeCount = zeros(1,length(FlowNetwork.EdgeTypeSet));
            
            for ii = 1:length(FlowNetwork.INFlowEdgeSet)
                FlowNetwork.PortSet(end+1) = Port;
                FlowNetwork.PortSet(end).Owner = FlowNetwork;
                FlowNetwork.PortSet(end).IncidentEdge = FlowNetwork.INFlowEdgeSet(ii);
                FlowNetwork.PortSet(end).Type = FlowNetwork.INFlowEdgeSet(ii).EdgeType;
                FlowNetwork.PortSet(end).Direction = 'IN';
                FlowNetwork.PortSet(end).setSide;
                FlowNetwork.PortSet(end).Number = ii;
                FlowNetwork.PortSet(end).Conn = strcat('LConn', num2str(ii));
                FlowNetwork.INFlowEdgeSet(ii).DestinationPort = FlowNetwork.PortSet(end);
                
                
                for kk = 1:length(FlowNetwork.EdgeTypeSet)
                    if strcmp(FlowNetwork.PortSet(end).Type, FlowNetwork.EdgeTypeSet{kk}) ==1
                        TypeCount(kk) = TypeCount(kk) +1;
                        FlowNetwork.PortSet(end).Name = strcat('IN_', FlowNetwork.EdgeTypeSet{kk},'_', num2str(TypeCount(kk)));
                    end
                end
            end
            
            %if there are no incoming edges, the i needs to be 0 instead of
            %an empty double, which f's up the indexing
            if isempty(FlowNetwork.INFlowEdgeSet) ==1
                ii = 0;
            end
            
            TypeCount = zeros(1,length(FlowNetwork.EdgeTypeSet));
            for jj = 1:length(FlowNetwork.OUTFlowEdgeSet)
                FlowNetwork.PortSet(end+1) = Port;
                FlowNetwork.PortSet(end).Owner = FlowNetwork;
                FlowNetwork.PortSet(end).IncidentEdge = FlowNetwork.OUTFlowEdgeSet(jj);
                FlowNetwork.PortSet(end).Type = FlowNetwork.OUTFlowEdgeSet(jj).EdgeType;
                FlowNetwork.PortSet(end).Direction = 'OUT';
                FlowNetwork.PortSet(end).setSide;
                FlowNetwork.PortSet(end).Number = ii + jj;
                FlowNetwork.PortSet(end).Conn = strcat('RConn', num2str(jj));
                FlowNetwork.OUTFlowEdgeSet(jj).OriginPort = FlowNetwork.PortSet(end);
                
                
                for kk = 1:length(FlowNetwork.EdgeTypeSet)
                    if strcmp(FlowNetwork.PortSet(end).Type, FlowNetwork.EdgeTypeSet{kk}) ==1
                        TypeCount(kk) = TypeCount(kk) +1;
                        FlowNetwork.PortSet(end).Name = strcat('OUT_', FlowNetwork.EdgeTypeSet{kk},'_', num2str(TypeCount(kk)));
                    end
                end
            end
        end %assignPorts function
        
        function buildPorts(self, FlowNetwork)
            % 7/8/16 -- Fix bug to handle nodes with zero ports in or out,
            % e.g. source or sink nodes.
            
            for ii = 1:length(FlowNetwork.EdgeTypeSet)
                %IN
                INset = findobj(FlowNetwork.INFlowEdgeSet, 'EdgeType', FlowNetwork.EdgeTypeSet{ii});
                if isempty(INset) == 0
                        %INset = findobj(N.INEdgeSet, 'EdgeType', N.EdgeTypeSet{i});
                        set_param(strcat(FlowNetwork.SimEventsPath, '/IN_', FlowNetwork.PortSet(ii).Type), 'NumberInputPorts', num2str(length(INset)));
 
                    for jj = 1:length(INset) %For Each edge in INset build port
                        try
                            Port = INset(jj).DestinationPort;
                            Port.SimEventsPath = strcat(FlowNetwork.SimEventsPath, '/', Port.Name);
                            add_block('simeventslib/SimEvents Ports and Subsystems/Conn', Port.SimEventsPath);
                            set_param(Port.SimEventsPath, 'Port', num2str(Port.Number));
                            set_param(Port.SimEventsPath, 'Side', Port.Side);
                            Port.setPosition
                            add_line(strcat(FlowNetwork.Model, '/', FlowNetwork.Name), strcat(Port.Direction, '_', Port.Type, '/LConn', num2str(jj)), ...
                            strcat(Port.Name,'/RConn1'), 'autorouting', 'on');
                        catch err
                            continue
                        end
                    end
                end
                
                
                %OUT
                OUTset = findobj(FlowNetwork.OUTFlowEdgeSet, 'EdgeType', FlowNetwork.EdgeTypeSet{ii});
                if isempty(OUTset) == 0
                    set_param(strcat(FlowNetwork.SimEventsPath, '/OUT_', FlowNetwork.PortSet(ii).Type), 'NumberOutputPorts', num2str(length(OUTset)));
               
                    for jj = 1:length(OUTset) %For Each edge in OUTset build port
                        try
                            Port = OUTset(jj).OriginPort;
                            Port.SimEventsPath = strcat(FlowNetwork.SimEventsPath, '/', Port.Name);
                            add_block('simeventslib/SimEvents Ports and Subsystems/Conn', Port.SimEventsPath);
                            set_param(Port.SimEventsPath, 'Port', num2str(Port.Number));
                            set_param(Port.SimEventsPath, 'Side', Port.Side);
                            Port.setPosition
                            add_line(strcat(FlowNetwork.Model, '/', FlowNetwork.Name), strcat(Port.Direction, '_', Port.Type, '/RConn', num2str(jj)), ...
                            strcat(Port.Name,'/RConn1'), 'autorouting', 'on');
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

