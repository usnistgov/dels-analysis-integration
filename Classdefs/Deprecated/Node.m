classdef Node < handle
    %NODE is the abstract class for generating simulation nodes
    %   The NODE class is responsible for maintaining the instance data in
    %   the class object and the corresponding SimEvents object as if they
    %   were the same object. 
    
    %This is because the SimEvents object is unable to maintain or execute
    %procedural methods that aren't predefined in SimEvents
    
    properties
        Model %What Model does the Node live in
        Node_Name
        Node_ID 
        Type %Designation of type of node to be instantiated in simulation
        Parent@Node %
        Parent_ID %From the instance data
        INEdgeSet@Edge %A set of edge classes incoming to the node
        OUTEdgeSet@Edge %A set of edge classes outgoing to the node
        NestedNetwork@Network
        EdgeTypeSet = {} %Collection of types of edges incident to the node (should be private)
        PortSet@Port %A set of port classes that define the node interface
        SimEventsPath %The associated SimEvents block identifier >> CHANGED ON 1/22/15; expect errors
        Echelon = 1 %A parameter currently used for aesthetic organization purposes
        
        %Spacial Properties
        X
        Y
        Z
    end %properties
    
    methods
        function obj = Node(Node_ID, X, Y, Z, Type)
            if nargin>0
                obj.Node_ID = Node_ID;
                obj.X = X;
                obj.Y = Y;
                obj.Z = Z;
                obj.Type = Type;
            end
            
        end
        function addEdge(N, e)
            %Add edges incident to the Node to one of the two sets
            %7/5/16: Switched from If/Elseif to if/if to accomodate self-edges
            if eq(e.Destination, N.Node_ID) == 1
            %if e.Destination == N.Node_ID
                N.INEdgeSet(end+1) = e;
                e.Destination_Node = N;
                N.EdgeTypeSet{end+1} = e.EdgeType;
            end
            if eq(e.Origin, N.Node_ID) == 1
            %if e.Origin == N.Node_ID
                N.OUTEdgeSet(end+1) = e;
                e.Origin_Node = N;
                N.EdgeTypeSet{end+1} = e.EdgeType;
            end
            N.EdgeTypeSet = unique(N.EdgeTypeSet);
        end %addedge function
        
        function assignPorts(N)
            %Assigns LConn and RConn port numbers to incoming/outgoing
            %edges respectively
            Type_Count = zeros(1,length(N.EdgeTypeSet));
            
            for i = 1:length(N.INEdgeSet)
                N.PortSet(end+1) = Port;
                N.PortSet(end).Owner = N;
                N.PortSet(end).Incident_Edge = N.INEdgeSet(i);
                N.PortSet(end).Type = N.INEdgeSet(i).EdgeType;
                N.PortSet(end).Direction = 'IN';
                N.PortSet(end).Set_Side;
                N.PortSet(end).Number = i;
                N.PortSet(end).Conn = strcat('LConn', num2str(i));
                N.INEdgeSet(i).Destination_Port = N.PortSet(end);
                
                
                for k = 1:length(N.EdgeTypeSet)
                    if strcmp(N.PortSet(end).Type, N.EdgeTypeSet{k}) ==1
                        Type_Count(k) = Type_Count(k) +1;
                        N.PortSet(end).Port_Name = strcat('IN_', N.EdgeTypeSet{k},'_', num2str(Type_Count(k)));
                    end
                end
            end
            
            %if there are no incoming edges, the i needs to be 0 instead of
            %an empty double, which f's up the indexing
            if isempty(N.INEdgeSet) ==1
                i = 0;
            end
            
            Type_Count = zeros(1,length(N.EdgeTypeSet));
            for j = 1:length(N.OUTEdgeSet)
                N.PortSet(end+1) = Port;
                N.PortSet(end).Owner = N;
                N.PortSet(end).Incident_Edge = N.OUTEdgeSet(j);
                N.PortSet(end).Type = N.OUTEdgeSet(j).EdgeType;
                N.PortSet(end).Direction = 'OUT';
                N.PortSet(end).Set_Side;
                N.PortSet(end).Number = i + j;
                N.PortSet(end).Conn = strcat('RConn', num2str(j));
                N.OUTEdgeSet(j).Origin_Port = N.PortSet(end);
                
                
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
                INset = findobj(N.INEdgeSet, 'EdgeType', N.EdgeTypeSet{i});
                if isempty(INset) == 0
                        %INset = findobj(N.INEdgeSet, 'EdgeType', N.EdgeTypeSet{i});
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
                OUTset = findobj(N.OUTEdgeSet, 'EdgeType', N.EdgeTypeSet{i});
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
        
    end %methods
    
    methods (Abstract = true)
        decorateNode(N) %Add additional functionality based on the specific subclass
            %e.g. make a normal node a customer node
            %Can be re-called to change the decoration of a simulation node
        
    end
    
end %classdef

