classdef FlowNetwork < Network
    %FLOWNETWORK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    %Name
    %ID
    %X
    %Y
    %Z
    FlowNodeList % [ID, X, Y]
    FlowNodeSet  %NodeSet@FlowNetwork %Use set method to "override" and type check for Flow Network
    %TO DO: 2/7 -- replaced FlowEdgeSet with FlowEdgeList -- propogate to code
    FlowEdgeList %[ID sourceFlowNode targetFlowNode grossCapacity flowFixedCost]
    FlowEdgeSet % flow edges within the flow network
    
    commoditySet@Commodity
    produces@Commodity
    consumes@Commodity
    productionRate
    consumptionRate
    consumptionProductionRatio %default is eye(numCommodity)
    
    capacity
    fixedCost
    
    %2/23/18: Can't redefine property type in subclass
    INFlowEdgeSet@FlowEdge %A set of flow edges incoming to the flow network
    OUTFlowEdgeSet@FlowEdge %A set of flow edges outgoing to the flow network
    numArc
    numNodes
    builder %lightweight delegate to builderClass for constructing simulation 
    
    %2/8/19 -- to be deprecated or made private
    FlowNode_ConsumptionProduction %FlowNode Commodity Production/Consumption
    FlowEdge_flowTypeAllowed %FlowEdgeID sourceFlowNode targetFlowNode commodity flowUnitCost
    FlowEdge_Solution %Binary FlowEdgeID sourceFlowNode targetFlowNode grossCapacity flowFixedCost
    commodityFlow_Solution %FlowEdgeID origin destination commodity flowUnitCost flowQuantity
    end
    
    methods
        function F=FlowNetwork(rhs)
          if nargin==0
            % default constructor
            
          elseif isa(rhs, 'FlowNetwork')
            % copy constructor
            fns = properties(rhs);
            for i=1:length(fns)
                %Try statement covers cases where you're copying something
                %that is a specialization of flowNetwork
                try
                    F.(fns{i}) = rhs.(fns{i});
                end
            end
          end
        end
        
        function addEdge(FN, e)
            if isa(e, 'FlowEdge')
                %Add edges incident to the Flow Network to one of the two sets
                %7/5/16: Switched from If/Elseif to if/if to accomodate self-edges
                if eq(e.DestinationID, FN.ID) == 1
                %if e.Destination == N.Node_ID
                    FN.INFlowEdgeSet(end+1) = e;
                    e.Destination = FN;
                    FN.EdgeTypeSet{end+1} = e.EdgeType;
                end
                if eq(e.OriginID, FN.ID) == 1
                %if e.Origin == N.Node_ID
                    FN.OUTFlowEdgeSet(end+1) = e;
                    e.Origin = FN;
                    FN.EdgeTypeSet{end+1} = e.EdgeType;
                end
                FN.EdgeTypeSet = unique(FN.EdgeTypeSet);
            end
        end
        
        function setNodeSet(FN, nodes)
            if isa(nodes, 'FlowNetwork')
                FN.NodeSet = nodes;
            else
                error('NodesSet for FlowNetwork must be of type Flow Network');
            end
        end
        
        function setBuilder(FN, builder)
            %assert(isa(builder, 'IFlowNetworkBuilder') == 1, 'Invalid Builder Object')
            FN.builder = builder;
        end
        
        function assignPorts(N)
            %Assigns LConn and RConn port numbers to incoming/outgoing
            %edges respectively
            TypeCount = zeros(1,length(N.EdgeTypeSet));
            
            for ii = 1:length(N.INFlowEdgeSet)
                N.PortSet(end+1) = Port;
                N.PortSet(end).Owner = N;
                N.PortSet(end).IncidentEdge = N.INFlowEdgeSet(ii);
                N.PortSet(end).Type = N.INFlowEdgeSet(ii).EdgeType;
                N.PortSet(end).Direction = 'IN';
                N.PortSet(end).setSide;
                N.PortSet(end).Number = ii;
                N.PortSet(end).Conn = strcat('LConn', num2str(ii));
                N.INFlowEdgeSet(ii).DestinationPort = N.PortSet(end);
                
                
                for kk = 1:length(N.EdgeTypeSet)
                    if strcmp(N.PortSet(end).Type, N.EdgeTypeSet{kk}) ==1
                        TypeCount(kk) = TypeCount(kk) +1;
                        N.PortSet(end).Name = strcat('IN_', N.EdgeTypeSet{kk},'_', num2str(TypeCount(kk)));
                    end
                end
            end
            
            %if there are no incoming edges, the i needs to be 0 instead of
            %an empty double, which f's up the indexing
            if isempty(N.INFlowEdgeSet) ==1
                ii = 0;
            end
            
            TypeCount = zeros(1,length(N.EdgeTypeSet));
            for jj = 1:length(N.OUTFlowEdgeSet)
                N.PortSet(end+1) = Port;
                N.PortSet(end).Owner = N;
                N.PortSet(end).IncidentEdge = N.OUTFlowEdgeSet(jj);
                N.PortSet(end).Type = N.OUTFlowEdgeSet(jj).EdgeType;
                N.PortSet(end).Direction = 'OUT';
                N.PortSet(end).setSide;
                N.PortSet(end).Number = ii + jj;
                N.PortSet(end).Conn = strcat('RConn', num2str(jj));
                N.OUTFlowEdgeSet(jj).OriginPort = N.PortSet(end);
                
                
                for kk = 1:length(N.EdgeTypeSet)
                    if strcmp(N.PortSet(end).Type, N.EdgeTypeSet{kk}) ==1
                        TypeCount(kk) = TypeCount(kk) +1;
                        N.PortSet(end).Name = strcat('OUT_', N.EdgeTypeSet{kk},'_', num2str(TypeCount(kk)));
                    end
                end
            end
        end %assignPorts function
        
        function buildPorts(N)
            % 7/8/16 -- Fix bug to handle nodes with zero ports in or out,
            % e.g. source or sink nodes.
            
            for ii = 1:length(N.EdgeTypeSet)
                %IN
                INset = findobj(N.INFlowEdgeSet, 'EdgeType', N.EdgeTypeSet{ii});
                if isempty(INset) == 0
                        %INset = findobj(N.INEdgeSet, 'EdgeType', N.EdgeTypeSet{i});
                        set_param(strcat(N.SimEventsPath, '/IN_', N.PortSet(ii).Type), 'NumberInputPorts', num2str(length(INset)));
 
                    for jj = 1:length(INset) %For Each edge in INset build port
                        try
                            Port = INset(jj).DestinationPort;
                            Port.SimEventsPath = strcat(N.SimEventsPath, '/', Port.Name);
                            add_block('simeventslib/SimEvents Ports and Subsystems/Conn', Port.SimEventsPath);
                            set_param(Port.SimEventsPath, 'Port', num2str(Port.Number));
                            set_param(Port.SimEventsPath, 'Side', Port.Side);
                            Port.setPosition
                            add_line(strcat(N.Model, '/', N.Name), strcat(Port.Direction, '_', Port.Type, '/LConn', num2str(jj)), ...
                            strcat(Port.Name,'/RConn1'), 'autorouting', 'on');
                        catch err
                            continue
                        end
                    end
                end
                
                
                %OUT
                OUTset = findobj(N.OUTFlowEdgeSet, 'EdgeType', N.EdgeTypeSet{ii});
                if isempty(OUTset) == 0
                    set_param(strcat(N.SimEventsPath, '/OUT_', N.PortSet(ii).Type), 'NumberOutputPorts', num2str(length(OUTset)));
               
                    for jj = 1:length(OUTset) %For Each edge in OUTset build port
                        try
                            Port = OUTset(jj).OriginPort;
                            Port.SimEventsPath = strcat(N.SimEventsPath, '/', Port.Name);
                            add_block('simeventslib/SimEvents Ports and Subsystems/Conn', Port.SimEventsPath);
                            set_param(Port.SimEventsPath, 'Port', num2str(Port.Number));
                            set_param(Port.SimEventsPath, 'Side', Port.Side);
                            Port.setPosition
                            add_line(strcat(N.Model, '/', N.Name), strcat(Port.Direction, '_', Port.Type, '/RConn', num2str(jj)), ...
                            strcat(Port.Name,'/RConn1'), 'autorouting', 'on');
                        catch err
                            rethrow(err)
                            %continue
                        end
                    end 
                end %End: Check if OUTset is empty
            end %End: For each type of Edge

        end %Role: ConcreteBuilder of Ports
        
        function decorateNode(N)
            assignPorts(N);
            buildPorts(N);
        end
        
        function plotMFNSolution(FN,varargin)
            import AnalysisLibraries/matlog.*
            
            gplot(list2adj(FN.commodityFlowPath(:,1:2)), FN.FlowNodeSet(:,2:3))
            hold on;
            if length(varargin) == 2
                customerSet = varargin{1};
                depotSet = varargin{2};
                scatter(customerSet(:,2),customerSet(:,3))
                scatter(depotSet(:,2),depotSet(:,3), 'filled')
            else
                scatter(FN.FlowNodeSet(:,2),FN.FlowNodeSet(:,3), 'filled')
            end
            hold off;
        end
        
        function list2Class(FN)
            %This function should convert the list based flow network into
            %a class based representation; more or less a constructor for a
            %flow network from instance data set
            %TO DO: 
        end
    end
    
end

