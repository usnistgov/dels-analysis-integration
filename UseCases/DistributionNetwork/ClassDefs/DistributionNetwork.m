classdef DistributionNetwork < FlowNetwork
    %DISTRIBUTIONNETWORK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        depotList
        depotSet@Depot
        customerList
        customerSet@Customer
        transportationChannelSet@TransportationChannel
        transportationChannelSolution
        resourceSolution
        policySolution
    end
    
    methods
        function self = DistributionNetwork(input)
          %Input variable may be a DistributionNetwork
          %If so, constructor should clone the input instead
          if nargin==0
            % default constructor
            
          elseif isa(input, 'DistributionNetwork')
            % copy constructor
            fns = properties(input);
            for i=1:length(fns)
              self.(fns{i}) = input.(fns{i});
            end
          end
        end
        
        function mapFlowNetwork2DistributionNetwork(self)
            %FlowEdge_Solution = Binary FlowEdgeID Origin Destination grossCapacity flowFixedCost
            FlowEdge_Solution = self.FlowEdge_Solution(self.FlowEdge_Solution(:,1) ==1,:);

            %commodityFlowSolution := FlowEdgeID origin destination commodity flowUnitCost flowQuantity
            commodityFlow_Solution = self.commodityFlow_Solution; 

            %Map Commodity Flow Solution to Commodities -- Eventually Map to a
            %Product with a Process Plan / Route
            self.commodityList = self.mapFlowCommodity2Commodity;

            %Map commodity flow solution to Probabilistic Commodity Flow.
            for jj = 1:length(FlowEdge_Solution) %For each FlowEdge selected in the solution
                FlowEdge_Solution(jj,7) = sum(commodityFlow_Solution(commodityFlow_Solution(:,1) == FlowEdge_Solution(jj,2), 6));
                FlowEdge_Solution(jj,8) = FlowEdge_Solution(jj,7) / sum(commodityFlow_Solution(commodityFlow_Solution(:,2) == FlowEdge_Solution(jj,3), 6));
            end
            clear commodityFlow_Solution;

            %map FlowNode to Customer Node (Probabilistic Flow)
            [self.customerSet] = self.mapFlowNode2CustomerProbFlow(self.customerList, FlowEdge_Solution);

            %Map FlowNode to Depot Node (Probabilistic Flow)
            [ self.depotSet, selecteddepotList, FlowEdge_Solution ] = self.mapFlowNode2DepotProbFlow( self.depotList, FlowEdge_Solution, self.nodeMapping);

            % Add Transportation Channels for Flow Edges
            [ self.transportationChannelSet, self.FlowEdgeSet] = self.mapFlowEdge2TransportationChannel([self.customerList; self.depotList], selecteddepotList, FlowEdge_Solution );
            self.FlowEdge_Solution = FlowEdge_Solution;
         end
    
    end

    methods(Access = private)
        function [ commodityList ] = mapFlowCommodity2Commodity(DN)
        %mapFlowCommodity2Commodity maps the Flow Network Commodity to Distribution Network Commodity
        %Eventually should transition to mapping to Product with Route being the proces plan

            %Initialize the struct (ie specify the classdef)
            commodityList = struct('instanceID', [], 'OriginID', [], 'DestinationID', [], 'Quantity', [], 'Route', []);
            FlowNode_CommoditySet = DN.FlowNode_ConsumptionProduction;
            commodityFlow_Solution = DN.commodityFlow_Solution;

            %commodityFlowSolution %FlowEdgeID origin destination commodity flowUnitCost flowQuantity

            for ii = 1:max(FlowNode_CommoditySet(:,2))
               commodityList(ii).instanceID = ii;
               commodityList(ii).OriginID = FlowNode_CommoditySet(FlowNode_CommoditySet(:,2) == ii & FlowNode_CommoditySet(:,3)>0,1);
               commodityList(ii).DestinationID = FlowNode_CommoditySet(FlowNode_CommoditySet(:,2) == ii & FlowNode_CommoditySet(:,3)<0,1);
               commodityList(ii).Quantity =  FlowNode_CommoditySet(FlowNode_CommoditySet(:,2) == ii & FlowNode_CommoditySet(:,3)>0,3);
               commodityList(ii).Route = DN.buildCommodityRoute(commodityFlow_Solution(commodityFlow_Solution(:,4) == ii,2:6));
               %Should return later to generalize to support production/consumption of
               %each commodity at each node.
               % TO DO: This is overwriting the original commoditySET!!
               
               commodity = findobj(DN.commoditySet, 'instanceID', ii);
               commodity.Quantity = commodityList(ii).Quantity;
               commodity.Route = commodityList(ii).Route;
            end
            
            DN.commodityList = commodityList;
            %Return to call commodity constructor prior to MCNF
            %then call buildCommodityRoute after MCNF
        end

        function route = buildCommodityRoute(DN, commodityFlowSolution)
        %Commodity_Route is a set of arcs that the commodity flows on
        %need to assemble the arcs into a route or path

            ii = 1;
            route = commodityFlowSolution(ii,1:2);
            while sum(commodityFlowSolution(:,1) == commodityFlowSolution(ii,2))>0
                ii = find(commodityFlowSolution(:,1) == commodityFlowSolution(ii,2));
                if eq(commodityFlowSolution(ii,4),0)==0
                    route = [route, commodityFlowSolution(ii,2)];
                end
            end
            %NOTE: Need a better solution to '10', it should be 2+numDepot
            while length(route)<6
                route = [route, 0];
            end
        end

        function [ TransportationChannelSet, FlowEdgeSet ] = mapFlowEdge2TransportationChannel(DN, nodeSet, selecteddepotList, FlowEdge_Solution )
        %UNTITLED4 Summary of this function goes here
        %   Detailed explanation goes here

        %FlowEdge_Solution = Binary FlowEdgeID Origin Destination grossCapacity flowFixedCost
    
            TransportationChannelSet(length(FlowEdge_Solution(1:end-length(selecteddepotList),1))) = TransportationChannel;
            for ii = 1:length(TransportationChannelSet)
                if FlowEdge_Solution(ii,1) == 1
                        TransportationChannelSet(ii).instanceID = ii+length(nodeSet);
                        TransportationChannelSet(ii).typeID = 'TransportationChannel_noInfo';
                        TransportationChannelSet(ii).name = strcat('TransportationChannel_', num2str(ii+length(nodeSet)));
                        TransportationChannelSet(ii).Echelon = 2;
                        TransportationChannelSet(ii).TravelRate = 30;
                        TransportationChannelSet(ii).TravelDistance = sqrt(sum((nodeSet(FlowEdge_Solution(ii,3),2:3)-nodeSet(FlowEdge_Solution(ii,4),2:3)).^2));
                        %Set Depot as Source; Depots always have higher Node IDs
                        if nodeSet(FlowEdge_Solution(ii,3),1)>nodeSet(FlowEdge_Solution(ii,4),1)
                            TransportationChannelSet(ii).Source = nodeSet(FlowEdge_Solution(ii,3),1);
                            TransportationChannelSet(ii).Target = nodeSet(FlowEdge_Solution(ii,4),1);
                        else
                            TransportationChannelSet(ii).Source = nodeSet(FlowEdge_Solution(ii,4),1);
                            TransportationChannelSet(ii).Target = nodeSet(FlowEdge_Solution(ii,3),1);
                        end

                        %Clean-up transportation_channel; set flow edges to 0;
                        match = (FlowEdge_Solution(:,3) == FlowEdge_Solution(ii,4) & FlowEdge_Solution(:,4) == FlowEdge_Solution(ii,3));
                        FlowEdge_Solution(ii,:)= zeros(1,8);
                        if any(match)
                            FlowEdge_Solution(match==1,:)= zeros(1,8);
                        end
                end
            end

            %Remove extra TransportationChannels from the Set
            %[TransportationChannelSet.Node_ID] only returns properties with value
            TransportationChannelSet = TransportationChannelSet(1:length([TransportationChannelSet.instanceID]));
            for jj = 1:length(TransportationChannelSet)
                %renumber transportation channel nodes
                TransportationChannelSet(jj).instanceID = length(nodeSet)+ TransportationChannelSet(jj).instanceID;
            end


            FlowEdgeSet(8*length(TransportationChannelSet)) = FlowEdge;
            jj = 1;
            for ii = 1:length(TransportationChannelSet)
                e2 = TransportationChannelSet(ii).createEdgeSet(selecteddepotList);
                FlowEdgeSet(jj:jj+length(e2)-1) = e2;
                jj = jj+length(e2);
            end

            FlowEdgeSet = FlowEdgeSet(1:jj-1);
        end

        function [ customerSet, commoditySet ] = mapFlowNode2CustomerProbFlow(DN, flowNodeSet, FlowEdge_Solution )
        %MAPFLOWNODE2CUSTOMERPROBFLOW Summary of this function goes here
        %   Detailed explanation goes here

            numCustomers = length(flowNodeSet(:,1));
            customerSet(numCustomers) = Customer;
            %commoditySet = struct('instanceID', [], 'Origin', [], 'Destination', [], 'Quantity', [], 'Route', []);
            for jj = 1:numCustomers
                customerSet(jj).instanceID = flowNodeSet(jj,1);
                customerSet(jj).name = strcat('Customer_', num2str(flowNodeSet(jj,1)));
                customerSet(jj).Echelon = 1;
                customerSet(jj).X = flowNodeSet(jj,2);
                customerSet(jj).Y = flowNodeSet(jj,3);
                customerSet(jj).typeID = 'Customer_probflow';
                customerSet(jj).routingProbability = FlowEdge_Solution(FlowEdge_Solution(:,3) == customerSet(jj).instanceID,8);

                %Aggregate the Commodities Into 1 Commodity for Each Customer
                commoditySet(jj) = Commodity;
                commoditySet(jj).instanceID = jj;
                commoditySet(jj).OriginID = jj;
                commoditySet(jj).DestinationID = 0;
                commoditySet(jj).Route = 0;
                commoditySet(jj).Quantity = sum(FlowEdge_Solution(FlowEdge_Solution(:,3) == customerSet(jj).instanceID, 7));
                customerSet(jj).setCommoditySet(commoditySet(jj));
            end

        end
        
        function [ depotSet, selecteddepotList, FlowEdge_Solution ] = mapFlowNode2DepotProbFlow(DN, FlowNodeSet, FlowEdge_Solution, depotMapping )
        %UNTITLED2 Summary of this function goes here
        %   Detailed explanation goes here

            % Isolate the Depots Selected by the Optimization
            %depotMapping = distributionNetworkSet(ii).depotMapping;
            %2/13/19 -- changed depotMapping to all capacitated nodes
            [LIA, LOCB] = ismember(depotMapping, FlowEdge_Solution(:, 3:4), 'rows');
            selecteddepotList = FlowEdge_Solution(LOCB(LIA), 3);
            FlowNodeSet = FlowNodeSet(ismember(FlowNodeSet(:,1), selecteddepotList),:);
            clear LIA LOCB;


            for jj = 1:length(depotMapping(:,1))
                FlowEdge_Solution(FlowEdge_Solution(:,3) == depotMapping(jj,2),3) = depotMapping(jj,1);
            end

            numDepot = length(FlowNodeSet(:,1));
            depotSet(numDepot) = Depot;
            for jj = 1:numDepot
                depotSet(jj).instanceID = FlowNodeSet(jj,1);
                depotSet(jj).name = strcat('Depot_', num2str(FlowNodeSet(jj,1)));
                depotSet(jj).Echelon = 3;
                depotSet(jj).X = FlowNodeSet(jj,2);
                depotSet(jj).Y = FlowNodeSet(jj,3);
                depotSet(jj).typeID = 'Depot_probflow';
                mappedFlowNode = depotMapping(depotMapping(:,1) == depotSet(jj).instanceID,2);
                depotSet(jj).routingProbability = FlowEdge_Solution(FlowEdge_Solution(:,3) == FlowNodeSet(jj,1) ...
                                                                & FlowEdge_Solution(:,4) ~= mappedFlowNode,8);
            end

            depotSet = depotSet(ismember([depotSet.instanceID], selecteddepotList));
        end

    end

end