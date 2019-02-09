classdef Workstation < FlowNetwork
    %WORKSTATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ProcessSet@Process
        ResourcePoolSet@ResourcePool
    end
    
    methods
        function addProcess(W, p)
            if eq(W.ID, p.Workstation_ID) ==1
                W.ProcessSet(end+1) = p;
                p.Workstation = W;
            end
            
        end
        
        function addResourcePool(W, rp)
            if eq(W.ID, rp.Workstation_ID) ==1
                W.ResourcePoolSet(end+1) = rp;
                rp.Workstation = W;
                rp.set_name;
            end
        end
        
        function EdgeSet = build_ProcessNetwork(W)
            %There may be a more robust way to do this in the future, when
            %we allow for an arbitrary process network, but for now we only
            %consider processes in series.
            
            W.ProcessSet(1).Echelon = 2;
            e = FlowEdge;
            e.Origin = Node;
            e.Origin.Name = 'Entity_Combiner';
            e.Origin_Port = Port;
            e.Origin_Port.Conn = 'RConn1';
            e.Type = 'Job';
            e.Destination = W.ProcessSet(1).ID;
            W.ProcessSet(1).addFlowEdge(e);
            EdgeSet = e;
            

            if eq(length(W.ProcessSet),1)==0
                for i = 2:length(W.ProcessSet)
                   W.ProcessSet(i).Echelon = 2;
                   e = FlowEdge;  
                   e.Type = 'Job';
                   e.Origin = W.ProcessSet(i-1).ID;
                   e.Destination = W.ProcessSet(i).ID;
                   W.ProcessSet(i-1).addFlowEdge(e);
                   W.ProcessSet(i).addFlowEdge(e);
                   W.ProcessSet(i-1).assignPorts;
                   EdgeSet(end+1) = e;
                end %for each process in process set

            end %if only one process
            
            e = FlowEdge;
            e.Destination = Node;
            e.Destination.Name = 'Entity_Splitter';
            e.Destination_Port = Port;
            e.Destination_Port.Conn = 'LConn1';
            e.Type = 'Job';
            e.Origin = W.ProcessSet(end).ID;
            W.ProcessSet(end).addFlowEdge(e);
            EdgeSet(end+1) = e;
            W.ProcessSet(end).assignPorts;
            

        end %build process network
           
        function CreateProcesses(W)
            %need to change all process nodes' echelon to 2
            %create a new node factory
            %add processSet to nf.NodeSet
            %somehow get the edges out of the processes
            
            EdgeSet = W.build_ProcessNetwork;  
            
            pf = ProcessFactory;
            pf.Model = strcat(W.Location, '/Workstation');
            pf.set_NodeSet(W.ProcessSet);
            pf.CreateNodes;
            
            ef = EdgeFactory;
            ef.Model = strcat(W.Location, '/Workstation');
            ef.EdgeSet = EdgeSet;
            ef.CreateEdges;
            
            
           end %end constructProcess
        
        function BuildResourcePools(W)
            position = [125 225 300 300];
            
            for i = 1:length(W.ResourcePoolSet)
                add_block(strcat('DELS_Library/Resource_Pool'), strcat(W.Location,'/Workstation/', W.ResourcePoolSet(i).Name), ...
                'Position', position + [0 100*(i-1) 0 100*(i-1)]);
                set_param(strcat(W.Location,'/Workstation/', W.ResourcePoolSet(i).Name), 'Quantity', num2str(W.ResourcePoolSet(i).Quantity));
                
                set_param(strcat(W.Location,'/Workstation/Entity_Combiner'), 'NumberInputPorts', num2str(i+1)); 
                set_param(strcat(W.Location,'/Workstation/Entity_Splitter'), 'NumberOutputPorts', num2str(i+1)); 
                
                add_line(strcat(W.Location,'/Workstation'), strcat(W.ResourcePoolSet(i).Name, '/LConn1'), strcat('Entity_Combiner/LConn', num2str(i+1)), ...
                     'autorouting', 'on');
                add_line(strcat(W.Location,'/Workstation'), strcat('Entity_Splitter/RConn', num2str(i+1)),strcat(W.ResourcePoolSet(i).Name, '/RConn1'), ...
                    'autorouting', 'on');
                
            end %for each resource pool
            
        end %end constructResourcePools
        
        function setProcessTime(W)
            
        end
    end
    
end

