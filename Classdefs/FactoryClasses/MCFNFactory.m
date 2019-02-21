classdef MCFNFactory < FlowNetworkFactory
    %MCFNFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %^model %where the network factory will operate
        %^modelLibrary % Source of analysis objects to clone from
        %^inputFlowNetwork@FlowNetwork
    end
    
    properties (Access = protected)
        FlowNode_ConsumptionProduction %FlowNode Commodity Production/Consumption
        FlowEdge_flowTypeAllowed %FlowEdgeID sourceFlowNode targetFlowNode commodity flowUnitCost
        FlowEdge_Solution %Binary FlowEdgeID sourceFlowNode targetFlowNode grossCapacity flowFixedCost
        commodityFlow_Solution %FlowEdgeID origin destination commodity flowUnitCost flowQuantity
        nodeMapping 
    end
    
    methods
      
        function buildAnalysisModel(self, varargin)

        end %end buildAnalysisModel
        
        function mapFlowNetwork2MCFNOPT(self)
            self.mapFlowNodes2ProductionConsumptionList(self.inputFlowNetwork);
            self.mapFlowEdges2FlowTypeAllowed(self.inputFlowNetwork);
            self.transformCapacitatedFlowNodes(self.inputFlowNetwork);
        end
    end
    
    methods (Access = private)
       function mapFlowNodes2ProductionConsumptionList(self, inputFlowNetwork)
            numCommodity = length(inputFlowNetwork.commoditySet);
            FlowNode_ConsumptionProduction = zeros(length(inputFlowNetwork.FlowNodeList)*numCommodity,3);
            
            for kk = 1:numCommodity
                FlowNode_ConsumptionProduction((kk-1)*length(inputFlowNetwork.FlowNodeList(:,1))+ 1: kk*length(inputFlowNetwork.FlowNodeList(:,1)),:) ...
                                = [inputFlowNetwork.FlowNodeList(:,1), kk*ones(length(inputFlowNetwork.FlowNodeList(:,1)),1), ...
                                  zeros(length(inputFlowNetwork.FlowNodeList(:,1)),1)];
            end
            
            
            for ii = 1:length(inputFlowNetwork.FlowNodeSet)
                %FlowNodeSet is type cell with each cell containing a set
                %of Flow Nodes (of a particular type)
                for jj = 1:length(inputFlowNetwork.FlowNodeSet{ii})
                    for kk = 1:length(inputFlowNetwork.FlowNodeSet{ii}(jj).produces)
                        index = FlowNode_ConsumptionProduction(:,1) == inputFlowNetwork.FlowNodeSet{ii}(jj).instanceID & FlowNode_ConsumptionProduction(:,2) == inputFlowNetwork.FlowNodeSet{ii}(jj).produces(kk).instanceID;
                        FlowNode_ConsumptionProduction(index,3) = inputFlowNetwork.FlowNodeSet{ii}(jj).productionRate(kk);
                    end %for each commodity that flowNode 'produces'
                    
                    for kk = 1:length(inputFlowNetwork.FlowNodeSet{ii}(jj).consumes)
                        index = FlowNode_ConsumptionProduction(:,1) == inputFlowNetwork.FlowNodeSet{ii}(jj).instanceID & FlowNode_ConsumptionProduction(:,2) == inputFlowNetwork.FlowNodeSet{ii}(jj).consumes(kk).instanceID;
                        FlowNode_ConsumptionProduction(index,3) = -1*inputFlowNetwork.FlowNodeSet{ii}(jj).consumptionRate(kk);
                    end %for each commodity that flowNode 'consumes'
                end % for each Flow Node
            end % for each Flow Node
            
            self.FlowNode_ConsumptionProduction = FlowNode_ConsumptionProduction;
       end
        
       function mapFlowEdges2FlowTypeAllowed(self, inputFlowNetwork)
            %FlowEdge_flowTypeAllowed: FlowEdgeID origin destination commodityKind flowUnitCost
            
            numArc = length(inputFlowNetwork.FlowEdgeSet);
            numCommodity = length(inputFlowNetwork.commoditySet);
            FlowEdge_flowTypeAllowed = zeros(numArc*numCommodity, 5);
            
            for ee = 1:length(inputFlowNetwork.FlowEdgeSet)
                numCommodity = length(inputFlowNetwork.FlowEdgeSet(ee).flowTypeAllowed);
                ID = [inputFlowNetwork.FlowEdgeSet(ee).instanceID, inputFlowNetwork.FlowEdgeSet(ee).sourceFlowNetworkID, inputFlowNetwork.FlowEdgeSet(ee).targetFlowNetworkID];
                FlowEdge_flowTypeAllowed((ee-1)*numCommodity+1:(ee)*numCommodity,:) = ...
                            [repmat(ID, [numCommodity,1]), inputFlowNetwork.FlowEdgeSet(ee).flowTypeAllowed', inputFlowNetwork.FlowEdgeSet(ee).flowUnitCost'];
            end
            
            self.FlowEdge_flowTypeAllowed = FlowEdge_flowTypeAllowed(FlowEdge_flowTypeAllowed(:,1) > 0,:);
       end
        
       function transformCapacitatedFlowNodes(self, inputFlowNetwork)
           % a) Transform capacitated flow nodes
            numCommodity = length(inputFlowNetwork.commoditySet);
            flowEdgeList = inputFlowNetwork.FlowEdgeList;
            flowNodeList = inputFlowNetwork.FlowNodeList;
            FlowEdge_flowTypeAllowed = inputFlowNetwork.FlowEdge_flowTypeAllowed;
            FlowNode_ConsumptionProduction = inputFlowNetwork.FlowNode_ConsumptionProduction;
            gg = max(flowEdgeList(:,1))+1;

            % Split capacitated node, add capacity and 'cost of opening' to edge
            for jj = 1:length(inputFlowNetwork.FlowNodeSet)
                capacitatedNodeSet = findobj(inputFlowNetwork.FlowNodeSet{jj}, '-not', 'grossCapacity', inf);
                for ii =1:length(capacitatedNodeSet)
                    nodeInstanceID = capacitatedNodeSet(ii).instanceID;
                    newInstanceID = max(flowNodeList(:,1))+1;
                    flowNodeList(end+1,:) = [newInstanceID, capacitatedNodeSet(ii).X, capacitatedNodeSet(ii).Y];
                    nodeMapping(ii,:) = [nodeInstanceID, newInstanceID];

                    %Replace all origin nodes with newly created node
                    flowEdgeList(flowEdgeList(:,2) == nodeInstanceID, 2) = newInstanceID;
                    FlowEdge_flowTypeAllowed(FlowEdge_flowTypeAllowed(:,2) == nodeInstanceID,2) = newInstanceID;


                    %2/9/19 assume all commodities can flow through all depots
                    %TO DO: only add edge/commodity flow variable for commodities
                    %that can flow (and allow for productionCode for flowUnitCost
                    %FlowEdge_flowTypeAllowed: FlowEdgeID origin destination commodityKind flowUnitCost

                    flowEdgeList(end+1,:) = [gg, nodeInstanceID, newInstanceID, capacitatedNodeSet(ii).grossCapacity, capacitatedNodeSet(ii).fixedCost];
                    FlowEdge_flowTypeAllowed(end+1:end+numCommodity, :) = [repmat(flowEdgeList(end,1:3), numCommodity,1), [1:numCommodity]', zeros(numCommodity,1)];
                    FlowNode_ConsumptionProduction(end+1:end+numCommodity,:) = [newInstanceID*ones(numCommodity,1), [1:numCommodity]', zeros(numCommodity,1)];

                    %Add split capacitated flow node to flowTypeAllowed list
                    %FlowEdge_flowTypeAllowed(end+1:end+numCommodity,:) = [repmat(flowEdgeList(end,1:3), numCommodity,1),kk*ones(numCommodity,1), zeros(numCommodity,1)];

                    gg = gg +1;
                end
            end

            
            
            %2/9/19 -- The optimization algorithm is going to add flow balance
            %constraints based on consumption/production, where the flow nodes are
            %the variables. So the ConsumptionProduction data needs to be sequenced
            %by commodityKind first then NodeID.
            % -- Alternatively, could inject the new consumption/production rows
            % (associated with the split node) into the array where they belong
            % (contiguous with the other rows associated with that commodityKind)
            %FlowNode_ConsumptionProduction = FlowNode_ConsumptionProduction(any(FlowNode_ConsumptionProduction,2),:);
            [~,I] = sort(FlowNode_ConsumptionProduction(:,2));
            FlowNode_ConsumptionProduction = FlowNode_ConsumptionProduction(I,:);
            self.FlowNode_ConsumptionProduction = FlowNode_ConsumptionProduction;
            self.FlowEdge_flowTypeAllowed = FlowEdge_flowTypeAllowed;
            inputFlowNetwork.FlowNodeList = flowNodeList;
            inputFlowNetwork.FlowEdgeList = flowEdgeList;
            self.nodeMapping = nodeMapping;
        end
    end
end

