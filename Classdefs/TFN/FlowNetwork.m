classdef FlowNetwork < Network
    %FLOWNETWORK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    %^name
    %^instanceID
    %^X
    %^Y
    %^Z
    flowNodeList % [instanceID, X, Y]
    flowNodeSet  %NodeSet@flowNetwork %Use set method to "override" and type check for flow Network
    flowEdgeList %[instanceID sourceflowNode targetflowNode grossCapacity flowFixedCost]
    flowEdgeSet % flow edges within the flow network
    sourceFlowNetwork@FlowNetwork
    targetFlowNetwork@FlowNetwork
    
    %Commodity flow in/outbound to flow Network
    produces@Commodity %{ordered}
    consumes@Commodity %{ordered}
    productionRate %{ordered} by produces
    consumptionRate %{ordered} by consumes
    consumptionProductionRatio %default is eye(numCommodity)
    
    %Commodity flow within Network
    commoditySet%@Commodity %{ordered}
    commodityList
    flowAmount %{ordered} by commoditySet
    flowCapacity %{ordered} by commoditySet
    grossCapacity
    flowFixedCost
    flowUnitCost %{ordered} by commoditySet
    
    %2/23/18: Can't redefine property type in subclass
    inFlowEdgeSet@FlowNetworkLink %A set of flow edges incoming to the flow network
    outFlowEdgeSet@FlowNetworkLink %A set of flow edges outgoing to the flow network
    
    
    %2/8/19 -- to be deprecated or made private
    flowNode_ConsumptionProduction %flowNode Commodity Production/Consumption
    flowEdge_flowTypeAllowed %flowEdgeID sourceflowNode targetflowNode commodity flowUnitCost
    flowEdge_Solution %Binary flowEdgeID sourceflowNode targetflowNode grossCapacity flowFixedCost
    commodityFlow_Solution %flowEdgeID origin destination commodity flowUnitCost flowQuantity
    nodeMapping
    %builder %lightweight delegate to builderClass for constructing simulation 
    end
    
    methods
        function self=flowNetwork(varargin)
          if nargin==0
            % default constructor
          end
        end
        
        function addEdge(self, edgeSet)
            self.inFlowEdgeSet = findobj(edgeSet, 'targetFlowNetworkID', self.instanceID);
            self.outFlowEdgeSet = findobj(edgeSet, 'sourceFlowNetworkID', self.instanceID);
        end
        
        function setNodeSet(self, nodes)
            if isa(nodes, 'FlowNetwork')
                self.flowNodeSet = nodes;
            else
                error('NodesSet for flowNetwork must be of type flow Network');
            end
        end
        
        function setFlowNodeSet(self, input)
            if isa(input, 'FlowNetwork')
               % processNodes are a subset of flowNodes; we have enforce subsetting 
               % via set methods.
               successFlag = 0;
               for ii = 1:length(self.flowNodeSet)
                    if strcmp(class(self.flowNodeSet{ii}), class(input))
                        self.flowNodeSet{ii}(end+1) = input;
                        successFlag = 1;
                        break;
                    end
               end
               if successFlag ==0
                   self.flowNodeSet{end+1} = input;
               end
               
               self.nodeSet{end+1} = input;
            end
            
        end
        
        function setBuilder(self, builder)
            %assert(isa(builder, 'IflowNetworkBuilder') == 1, 'Invalid Builder Object')
            self.builder = builder;
            self.builder.systemElement = self;
        end
        
        function plotMCFNSolution(self,varargin)
            addpath dels-analysis-integration\AnalysisLibraries\matlog
            
            gplot(list2adj(self.flowEdgeList(:,2:3)), self.flowNodeList(:,2:3))
            hold on;
            if length(varargin) == 2
                customerList = varargin{1};
                depotList = varargin{2};
                scatter(customerList(:,2),customerList(:,3))
                scatter(depotList(:,2),depotList(:,3), 'filled')
            else
                scatter(self.flowNodeList(:,2),self.flowNodeList(:,3), 'filled')
            end
            hold off;
        end
      
        function mapFlowNodes2ProductionConsumptionList(self)
            
            numCommodity = length(self.commoditySet);
            flowNode_ConsumptionProduction = zeros(length(self.flowNodeList)*numCommodity,3);
            
            for kk = 1:numCommodity
                flowNode_ConsumptionProduction((kk-1)*length(self.flowNodeList(:,1))+ 1: kk*length(self.flowNodeList(:,1)),:) ...
                                = [self.flowNodeList(:,1), kk*ones(length(self.flowNodeList(:,1)),1), ...
                                  zeros(length(self.flowNodeList(:,1)),1)];
            end
            
            
            for ii = 1:length(self.flowNodeSet)
                %flowNodeSet is type cell with each cell containing a set
                %of flow Nodes (of a particular type)
                for jj = 1:length(self.flowNodeSet{ii})
                    for kk = 1:length(self.flowNodeSet{ii}(jj).produces)
                        index = flowNode_ConsumptionProduction(:,1) == self.flowNodeSet{ii}(jj).instanceID & flowNode_ConsumptionProduction(:,2) == self.flowNodeSet{ii}(jj).produces(kk).instanceID;
                        flowNode_ConsumptionProduction(index,3) = self.flowNodeSet{ii}(jj).productionRate(kk);
                    end %for each commodity that flowNode 'produces'
                    
                    for kk = 1:length(self.flowNodeSet{ii}(jj).consumes)
                        index = flowNode_ConsumptionProduction(:,1) == self.flowNodeSet{ii}(jj).instanceID & flowNode_ConsumptionProduction(:,2) == self.flowNodeSet{ii}(jj).consumes(kk).instanceID;
                        flowNode_ConsumptionProduction(index,3) = -1*self.flowNodeSet{ii}(jj).consumptionRate(kk);
                    end %for each commodity that flowNode 'consumes'
                end % for each flow Node
            end % for each flow Node
            
            self.flowNode_ConsumptionProduction = flowNode_ConsumptionProduction;
        end
        
        function mapFlowEdges2FlowTypeAllowed(self)
            %flowEdge_flowTypeAllowed: flowEdgeID origin destination commodityKind flowUnitCost
            
            numArc = length(self.flowEdgeSet);
            numCommodity = length(self.commoditySet);
            flowEdge_flowTypeAllowed = zeros(numArc*numCommodity, 5);
            
            for ee = 1:length(self.flowEdgeSet)
                numCommodity = length(self.flowEdgeSet(ee).flowTypeAllowed);
                ID = [self.flowEdgeSet(ee).instanceID, self.flowEdgeSet(ee).sourceFlowNetworkID, self.flowEdgeSet(ee).targetFlowNetworkID];
                flowEdge_flowTypeAllowed((ee-1)*numCommodity+1:(ee)*numCommodity,:) = ...
                            [repmat(ID, [numCommodity,1]), self.flowEdgeSet(ee).flowTypeAllowed', self.flowEdgeSet(ee).flowUnitCost'];
            end
            
            self.flowEdge_flowTypeAllowed = flowEdge_flowTypeAllowed(flowEdge_flowTypeAllowed(:,1) > 0,:);
        end
        
        function transformCapacitatedFlowNodes(self)
           % a) Transform capacitated flow nodes
            numCommodity = length(self.commoditySet);
            flowEdgeList = self.flowEdgeList;
            flowNodeList = self.flowNodeList;
            flowEdge_flowTypeAllowed = self.flowEdge_flowTypeAllowed;
            flowNode_ConsumptionProduction = self.flowNode_ConsumptionProduction;
            gg = max(flowEdgeList(:,1))+1;

            % Split capacitated node, add capacity and 'cost of opening' to edge
            for jj = 1:length(self.flowNodeSet)
                capacitatedNodeSet = findobj(self.flowNodeSet{jj}, '-not', 'grossCapacity', inf);
                for ii =1:length(capacitatedNodeSet)
                    nodeInstanceID = capacitatedNodeSet(ii).instanceID;
                    newInstanceID = max(flowNodeList(:,1))+1;
                    flowNodeList(end+1,:) = [newInstanceID, capacitatedNodeSet(ii).X, capacitatedNodeSet(ii).Y];
                    nodeMapping(ii,:) = [nodeInstanceID, newInstanceID];

                    %Replace all origin nodes with newly created node
                    flowEdgeList(flowEdgeList(:,2) == nodeInstanceID, 2) = newInstanceID;
                    flowEdge_flowTypeAllowed(flowEdge_flowTypeAllowed(:,2) == nodeInstanceID,2) = newInstanceID;


                    %2/9/19 assume all commodities can flow through all depots
                    %TO DO: only add edge/commodity flow variable for commodities
                    %that can flow (and allow for productionCode for flowUnitCost
                    %flowEdge_flowTypeAllowed: flowEdgeID origin destination commodityKind flowUnitCost

                    flowEdgeList(end+1,:) = [gg, nodeInstanceID, newInstanceID, capacitatedNodeSet(ii).grossCapacity, capacitatedNodeSet(ii).flowFixedCost];
                    flowEdge_flowTypeAllowed(end+1:end+numCommodity, :) = [repmat(flowEdgeList(end,1:3), numCommodity,1), [1:numCommodity]', zeros(numCommodity,1)];
                    flowNode_ConsumptionProduction(end+1:end+numCommodity,:) = [newInstanceID*ones(numCommodity,1), [1:numCommodity]', zeros(numCommodity,1)];

                    %Add split capacitated flow node to flowTypeAllowed list
                    %flowEdge_flowTypeAllowed(end+1:end+numCommodity,:) = [repmat(flowEdgeList(end,1:3), numCommodity,1),kk*ones(numCommodity,1), zeros(numCommodity,1)];

                    gg = gg +1;
                end
            end

            self.flowEdge_flowTypeAllowed = flowEdge_flowTypeAllowed;
            self.flowEdgeList = flowEdgeList;
            %2/9/19 -- The optimization algorithm is going to add flow balance
            %constraints based on consumption/production, where the flow nodes are
            %the variables. So the ConsumptionProduction data needs to be sequenced
            %by commodityKind first then NodeID.
            % -- Alternatively, could inject the new consumption/production rows
            % (associated with the split node) into the array where they belong
            % (contiguous with the other rows associated with that commodityKind)
            %flowNode_ConsumptionProduction = flowNode_ConsumptionProduction(any(flowNode_ConsumptionProduction,2),:);
            [~,I] = sort(flowNode_ConsumptionProduction(:,2));
            flowNode_ConsumptionProduction = flowNode_ConsumptionProduction(I,:);
            self.flowNode_ConsumptionProduction = flowNode_ConsumptionProduction;
            self.flowNodeList = flowNodeList;
            self.nodeMapping = nodeMapping;
        end
        
        function mapFlowNetwork2MCFNOPT(self)
            self.mapFlowNodes2ProductionConsumptionList;
            self.mapFlowEdges2FlowTypeAllowed;
            self.transformCapacitatedFlowNodes;
        end
        
        function mapMCFNSolution2FlowNetwork(self)
            
            %% Transform Capacitated Nodes
            % 1) Find capacitated nodes that were selected
            capacitatedNodeSelection = self.flowEdge_Solution(ismember(self.flowEdge_Solution(:, 3:4), self.nodeMapping,'rows'),:);
            
            % 2) Remove split nodes from flowNodeList
            self.flowNodeList(ismember(self.flowNodeList(:,1), self.nodeMapping(:,2)),:) = [];
            
            % 3) Find and replace InstanceIDs of split nodes
            for ii = 1:length(self.nodeMapping)
                self.flowEdgeList(self.flowEdgeList(:,2) ==  self.nodeMapping(ii,2),2) = self.nodeMapping(ii,1);
            end
            
            % 4) Remove the 
            self.flowEdgeList(ismember(self.flowEdgeList(:, 2:3), self.nodeMapping,'rows'),:) = [];
            
            %% Remove unselected flow Nodes
            % 1) Remove not selected from flowNodeList
            for ii = 1:length(capacitatedNodeSelection(:,1))
                if capacitatedNodeSelection(ii,1) == 0
                   self.flowNodeList(self.flowNodeList(:,1) == capacitatedNodeSelection(ii,3),:) = [];
                end
            end
            
            % 2) Remove not selected from flowNodeSet
            for ii = 1:length(self.flowNodeSet)
                jj = 1;
                while jj <= length(self.flowNodeSet{ii})
                    instanceID = self.flowNodeSet{ii}(jj).instanceID;
                    isSelected = capacitatedNodeSelection(capacitatedNodeSelection(:,3)==instanceID,1);
                    if ~isSelected
                        self.flowNodeSet{ii}(jj) = [];
                    else
                        jj = jj +1;
                    end
                end
            end
            
            %% Remove Unselected flowEdges
            selectedEdges = logical(self.flowEdge_Solution(1:length(self.flowEdgeList),1));
            self.flowEdgeList = self.flowEdgeList(selectedEdges,:);
            self.flowEdgeSet = self.flowEdgeSet(selectedEdges); 
            
            % Add flow edge sets to each flow node
            for ii = 1:length(self.flowNodeSet)
                for jj = 1:length(self.flowNodeSet{ii})
                    self.flowNodeSet{ii}(jj).inFlowEdgeSet = findobj(self.flowEdgeSet, 'targetFlowNetworkID', self.flowNodeSet{ii}(jj).instanceID);
                    self.flowNodeSet{ii}(jj).outFlowEdgeSet = findobj(self.flowEdgeSet, 'sourceFlowNetworkID', self.flowNodeSet{ii}(jj).instanceID);
                end
            end
            
            %% Add selected commodities
            % 1) Add to flow edges
            commodityFlow_Solution = self.commodityFlow_Solution;
            commoditySet = self.commoditySet;
            for ii = 1:length(self.flowEdgeSet)
                %filter to commodity on specified edge
                edgeXCommodity = commodityFlow_Solution(commodityFlow_Solution(:,1) == self.flowEdgeSet(ii).instanceID,:);
                self.flowEdgeSet(ii).flowTypeAllowed = edgeXCommodity(:,4)'; %should flow type allowed be commodities?
                self.flowEdgeSet(ii).flowUnitCost = edgeXCommodity(:,5)';
                self.flowEdgeSet(ii).flowAmount = edgeXCommodity(:,6)';
                %May add later to add the flow solution as the flow capacity per commodity kind
            end % for each flow edge in flowEdgeSet
            
            % 2) Add to flow nodes
            for ii = 1:length(self.flowNodeSet)
                for jj = 1:length(self.flowNodeSet{ii})
                    sourceXCommodity = commodityFlow_Solution(commodityFlow_Solution(:,2) == self.flowNodeSet{ii}(jj).instanceID,:);
                    targetXCommodity = commodityFlow_Solution(commodityFlow_Solution(:,3) == self.flowNodeSet{ii}(jj).instanceID,:);
                    
                    self.flowNodeSet{ii}(jj).productionRate = sourceXCommodity(:, 6);
                    self.flowNodeSet{ii}(jj).consumptionRate = targetXCommodity(:, 6);
                    
                    produces = Commodity.empty;
                    for kk = 1:length(sourceXCommodity(:,1))
                        produces(end+1) = findobj(commoditySet, 'instanceID', sourceXCommodity(kk,4));
                    end
                    self.flowNodeSet{ii}(jj).produces = produces;
                    
                    %We're going to repurpose the produces variable now to fill out the commoditySet
                    consumes = Commodity.empty;
                    for kk = 1:length(targetXCommodity(:,1))
                        consumes(end+1) = findobj(commoditySet, 'instanceID', targetXCommodity(kk,4));
                        
                        %Check to see if the commodity is in the commodity set (repurposed produces variable)
                        if isempty(findobj(produces, 'instanceID', targetXCommodity(kk,4)))
                            produces(end+1) = consumes(end);
                        end
                    end
                    self.flowNodeSet{ii}(jj).consumes = consumes;
                    self.flowNodeSet{ii}(jj).commoditySet = produces;
                end %for each node in flow node set (inner)
            end %for each node in flow node set (outer)
            
            % 3) Build commodity routes
            %TO DO: consider the case with BOM where the same input part is sourced from two different suppliers
            % It has to be represented with the same commodity, but has different route.
            for ii = 1:length(self.commoditySet)
                instanceID = self.commoditySet(ii).instanceID;
                self.commoditySet(ii).route = self.buildCommodityRoute(commodityFlow_Solution(commodityFlow_Solution(:,4) == instanceID,2:6));
            end
            
            % 4) Build probabilistic routing
            %for ii = 1:length(self.flowNodeSet)
            %    for jj = 1:length(self.flowNodeSet{ii})
            %        totalOutflow = 0;
            %        edgeflowAmount = [];
            %        for kk = 1:length(self.flowNodeSet{ii}(jj).outFlowEdgeSet)
            %            edgeflowAmount(end+1) = sum(self.flowNodeSet{ii}(jj).outFlowEdgeSet(kk).flowAmount);
            %            totalOutflow = totalOutflow + edgeflowAmount(end);
            %        end
            %        self.flowNodeSet{ii}(jj).routingProbability = edgeflowAmount./totalOutflow;
            %    end
            %end
            
            
        end %mapMCFNSolution2flowNetwork
        
        function route = buildCommodityRoute(self, commodityflowSolution)
        %Commodity_Route is a set of arcs that the commodity flows on
        %need to assemble the arcs into a route or path
            ii = 1;
            route = commodityflowSolution(ii,1:2);
            while sum(commodityflowSolution(:,1) == commodityflowSolution(ii,2))>0
                ii = find(commodityflowSolution(:,1) == commodityflowSolution(ii,2));
                if eq(commodityflowSolution(ii,4),0)==0
                    route = [route, commodityflowSolution(ii,2)];
                end
            end
            %NOTE: Need a better solution to '10', it should be 2+numDepot
            while length(route)<6
                route = [route, 0];
            end
       end  %end build commodity route
    
    end
end
