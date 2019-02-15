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
          
          
          elseif isa(input, 'FlowNetwork')
            % downcast to distribution network
            % potentially unsafe!
            fns = properties(input);
            for i=1:length(fns)
              self.(fns{i}) = input.(fns{i});
            end
          end
        end
        
        function mapFlowNetwork2DistributionNetworkProbabilisticFlow(self)
            %FlowEdge_Solution = Binary FlowEdgeID Origin Destination grossCapacity flowFixedCost
            FlowEdge_Solution = self.FlowEdge_Solution(self.FlowEdge_Solution(:,1) ==1,:);

            %Map commodity flow solution to Probabilistic Commodity Flow.
            FlowEdge_ProbabilisticFlowSolution = mapCommodityFlow2ProbabilisticFlow(FlowEdge_Solution);

            %map FlowNode to Customer Node (Probabilistic Flow)
            [self.customerSet] = self.mapFlowNode2CustomerProbFlow(self.customerList, FlowEdge_ProbabilisticFlowSolution);

            %Map FlowNode to Depot Node (Probabilistic Flow)
            [self.depotSet, selecteddepotList, FlowEdge_ProbabilisticFlowSolution] = self.mapFlowNode2DepotProbFlow( self.depotList, FlowEdge_ProbabilisticFlowSolution, self.nodeMapping);

            % Add Transportation Channels for Flow Edges
            [ self.transportationChannelSet, self.FlowEdgeSet] = self.mapFlowEdge2TransportationChannel([self.customerList; self.depotList], selecteddepotList, FlowEdge_ProbabilisticFlowSolution );
            self.FlowEdge_Solution = FlowEdge_ProbabilisticFlowSolution;
        end
        
        function mapFlowNetwork2DistributionNetwork(self)
            
            % 1) Remove unselected depots
            ii = 1;
            while ii <= length(self.depotSet)
               if ~any(self.FlowNodeList(:,1) == self.depotSet(ii).instanceID)
                   self.depotSet(ii) = [];
               else
                   ii = ii + 1;
               end
            end
            
            % 2) Remove unselected customers
            ii = 1;
            while ii <= length(self.customerSet)
               if ~any(self.FlowNodeList(:,1) == self.customerSet(ii).instanceID)
                   self.customerSet(ii) = [];
               else
                   ii = ii + 1;
               end
            end
            
            % 3) Transform flow edges into transportation channels
            % self.mapFlowEdge2TransportationChannel
        end
    end

    methods(Access = private)

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
        
        function [ FlowEdge_Solution ] = mapCommodityFlow2ProbabilisticFlow(DN, FlowEdge_Solution)
            % Flow Network implements a method to find probabilistic flow of commodities
            % This should simply implement a method that consolidates all commodities into one with 
            % total flow sum of individual flows
            
        end

    end

end