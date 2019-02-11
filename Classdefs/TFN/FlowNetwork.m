classdef FlowNetwork < Network
    %FLOWNETWORK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    %name
    %instanceID
    %X
    %Y
    %Z
    FlowNodeList % [instanceID, X, Y]
    FlowNodeSet  %NodeSet@FlowNetwork %Use set method to "override" and type check for Flow Network
    %TO DO: 2/7 -- replaced FlowEdgeSet with FlowEdgeList -- propagate to code
    FlowEdgeList %[instanceID sourceFlowNode targetFlowNode grossCapacity flowFixedCost]
    FlowEdgeSet % flow edges within the flow network
    
    commoditySet@Commodity
    commodityList
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
    numCommodity
    builder %lightweight delegate to builderClass for constructing simulation 
    
    %2/8/19 -- to be deprecated or made private
    FlowNode_ConsumptionProduction %FlowNode Commodity Production/Consumption
    FlowEdge_flowTypeAllowed %FlowEdgeID sourceFlowNode targetFlowNode commodity flowUnitCost
    FlowEdge_Solution %Binary FlowEdgeID sourceFlowNode targetFlowNode grossCapacity flowFixedCost
    commodityFlow_Solution %FlowEdgeID origin destination commodity flowUnitCost flowQuantity
    end
    
    methods
        function self=FlowNetwork(rhs)
          if nargin==0
            % default constructor
            
          elseif isa(rhs, 'FlowNetwork')
            % copy constructor
            fns = properties(rhs);
            for i=1:length(fns)
                %Try statement covers cases where you're copying something
                %that is a specialization of flowNetwork
                try
                    self.(fns{i}) = rhs.(fns{i});
                end
            end
          end
        end
        
        function addEdge(self, edgeSet)
            e = findobj(edgeSet, 'isa', 'FlowEdge', 'targetFlowNetworkID', self.instanceID, '-or', 'sourceFlowNetworkID', self.instanceID);
            self.INFlowEdgeSet = findobj(e, 'targetFlowNetworkID', self.instanceID);
            self.OUTFlowEdgeSet = findobj(e, 'sourceFlowNetworkID', self.instanceID);
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
                        N.PortSet(end).name = strcat('IN_', N.EdgeTypeSet{kk},'_', num2str(TypeCount(kk)));
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
                        N.PortSet(end).name = strcat('OUT_', N.EdgeTypeSet{kk},'_', num2str(TypeCount(kk)));
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
                            Port.SimEventsPath = strcat(N.SimEventsPath, '/', Port.name);
                            add_block('simeventslib/SimEvents Ports and Subsystems/Conn', Port.SimEventsPath);
                            set_param(Port.SimEventsPath, 'Port', num2str(Port.Number));
                            set_param(Port.SimEventsPath, 'Side', Port.Side);
                            Port.setPosition
                            add_line(strcat(N.Model, '/', N.name), strcat(Port.Direction, '_', Port.Type, '/LConn', num2str(jj)), ...
                            strcat(Port.name,'/RConn1'), 'autorouting', 'on');
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
                            Port.SimEventsPath = strcat(N.SimEventsPath, '/', Port.name);
                            add_block('simeventslib/SimEvents Ports and Subsystems/Conn', Port.SimEventsPath);
                            set_param(Port.SimEventsPath, 'Port', num2str(Port.Number));
                            set_param(Port.SimEventsPath, 'Side', Port.Side);
                            Port.setPosition
                            add_line(strcat(N.Model, '/', N.name), strcat(Port.Direction, '_', Port.Type, '/RConn', num2str(jj)), ...
                            strcat(Port.name,'/RConn1'), 'autorouting', 'on');
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
        
        function transformCapacitatedNodes(self)
            
        end
        
        function [FlowNode_ConsumptionProduction] = mapFlowNodes2ProductionConsumptionList(self)
            
            FlowNode_ConsumptionProduction = zeros(length(self.FlowNodeList)*self.numCommodity,3);
            
            for kk = 1:self.numCommodity
                FlowNode_ConsumptionProduction((kk-1)*length(self.FlowNodeList(:,1))+ 1: kk*length(self.FlowNodeList(:,1)),:) ...
                                = [self.FlowNodeList(:,1), kk*ones(length(self.FlowNodeList(:,1)),1), ...
                                  zeros(length(self.FlowNodeList(:,1)),1)];
            end
            
            
            for ii = 1:length(self.FlowNodeSet)
                %FlowNodeSet is type cell with each cell containing a set
                %of Flow Nodes (of a particular type)
                for jj = 1:length(self.FlowNodeSet{ii})
                    for kk = 1:length(self.FlowNodeSet{ii}(jj).produces)
                        index = FlowNode_ConsumptionProduction(:,1) == self.FlowNodeSet{ii}(jj).instanceID & FlowNode_ConsumptionProduction(:,2) == self.FlowNodeSet{ii}(jj).produces(kk).instanceID;
                        FlowNode_ConsumptionProduction(index,3) = self.FlowNodeSet{ii}(jj).productionRate(kk);
                    end %for each commodity that flowNode 'produces'
                    
                    for kk = 1:length(self.FlowNodeSet{ii}(jj).consumes)
                        index = FlowNode_ConsumptionProduction(:,1) == self.FlowNodeSet{ii}(jj).instanceID & FlowNode_ConsumptionProduction(:,2) == self.FlowNodeSet{ii}(jj).consumes(kk).instanceID;
                        FlowNode_ConsumptionProduction(index,3) = -1*self.FlowNodeSet{ii}(jj).consumptionRate(kk);
                    end %for each commodity that flowNode 'consumes'
                end % for each Flow Node
            end % for each Flow Node
            
            self.FlowNode_ConsumptionProduction = FlowNode_ConsumptionProduction;
        end
        
        function [FlowEdge_flowTypeAllowed] = mapFlowEdges2FlowTypeAllowed(self)
            %FlowEdge_flowTypeAllowed: FlowEdgeID origin destination commodityKind flowUnitCost
            
            FlowEdge_flowTypeAllowed = zeros(self.numArc*self.numCommodity, 5);
            
            for ee = 1:length(self.FlowEdgeSet)
                ID = [self.FlowEdgeSet(ee).instanceID, self.FlowEdgeSet(ee).sourceFlowNetworkID, self.FlowEdgeSet(ee).targetFlowNetworkID];
                FlowEdge_flowTypeAllowed((ee-1)*self.numCommodity+1:(ee)*self.numCommodity,:) = ...
                            [repmat(ID, [self.numCommodity,1]), self.FlowEdgeSet(ee).flowTypeAllowed', self.FlowEdgeSet(ee).flowUnitCost'];
            end
            
            self.FlowEdge_flowTypeAllowed = FlowEdge_flowTypeAllowed;
        end
    end
    
end

