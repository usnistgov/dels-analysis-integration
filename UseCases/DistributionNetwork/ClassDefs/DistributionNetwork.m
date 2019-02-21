classdef DistributionNetwork < FlowNetwork
    %DISTRIBUTIONNETWORK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        depotList
        depotSet@Depot
        customerList
        customerSet@Customer
        transportationChannelSet@TransportationChannel
        resourceSolution
        policySolution
    end
    
    methods
        function self = DistributionNetwork()
          %Input variable may be a DistributionNetwork
          %If so, constructor should clone the input instead
          %TO DO: move deep copying here
        end
        
        function mapFlowNetwork2DistributionNetwork(self)
            % 1) Transform flow edges into transportation channels
            self.mapFlowEdge2TransportationChannel;
            
            % 2) Remove unselected depots
            ii = 1;
            while ii <= length(self.depotSet)
               if ~any(self.FlowNodeList(:,1) == self.depotSet(ii).instanceID)
                   self.depotSet(ii) = [];
               else
                   ii = ii + 1;
               end
            end
            
            % 3) Remove unselected customers
            ii = 1;
            while ii <= length(self.customerSet)
               if ~any(self.FlowNodeList(:,1) == self.customerSet(ii).instanceID)
                   self.customerSet(ii) = [];
               else
                   ii = ii + 1;
               end
            end
            
            % 3.1) Add flow edges to customers & depots
            for ii = 1:length(self.customerSet)
                self.customerSet(ii).addEdge(self.FlowEdgeSet);
            end
            for ii = 1:length(self.depotSet)
                self.depotSet(ii).addEdge(self.FlowEdgeSet);
            end
            
        end
    end

    methods(Access = private)

        function mapFlowEdge2TransportationChannel(self)
            % Create one bi-directional transportation channel for flows between two flow nodes
            % Find the two Flow Edges that have reciprocal source/targets
            % Note: there may not be a reciprocal edge
            % Make a new transportation channel from them (using the properties of the first indexed flow edge)
            % TO DO: how to combine asymmetric flow edge capacity / flow time / etc.
            
            
            % 1) Create transportation Channel container
            transportationChannelSet = TransportationChannel.empty(0);
            flowEdgeList = self.FlowEdgeList;
           
            % 2) Make a new transportation channel from them (using the properties of the first indexed flow edge)
            ii = 1;
            while ~isempty(flowEdgeList)
                flowEdge = findobj(self.FlowEdgeSet, 'instanceID', flowEdgeList(1,1));
                transportationChannelSet(ii) = TransportationChannel;
                transportationChannelSet(ii).instanceID = ii+max(self.FlowNodeList(:,1));
                transportationChannelSet(ii).typeID = 'TransportationChannel';
                transportationChannelSet(ii).name = strcat('TransportationChannel_', num2str(transportationChannelSet(ii).instanceID));
                transportationChannelSet(ii).travelRate = 30;
                transportationChannelSet(ii).travelDistance = flowEdge.calculateEdgeLength;
                transportationChannelSet(ii).commodityList = flowEdge.flowTypeAllowed;
                transportationChannelSet(ii).flowAmount = flowEdge.flowAmount;
                transportationChannelSet(ii).flowCapacity = flowEdge.flowCapacity;
                transportationChannelSet(ii).grossCapacity = flowEdge.grossCapacity;
                transportationChannelSet(ii).flowUnitCost = flowEdge.flowUnitCost;
                transportationChannelSet(ii).flowFixedCost = flowEdge.flowFixedCost;
               
                %2.1 Set Depot as Source;
                if isa(self.FlowEdgeSet(ii).sourceFlowNetwork, 'Depot')
                    transportationChannelSet(ii).source = flowEdge.sourceFlowNetwork;
                    transportationChannelSet(ii).target = flowEdge.targetFlowNetwork;
                else
                    transportationChannelSet(ii).target = flowEdge.sourceFlowNetwork;
                    transportationChannelSet(ii).source = flowEdge.targetFlowNetwork;
                end
                
                %2.2 Find the two edges that are reciprocals of each other
                transportationChannelSet(ii).FlowEdgeSet = findobj(self.FlowEdgeSet,...
                              'sourceFlowNetworkID', transportationChannelSet(ii).source.instanceID, '-and', 'targetFlowNetworkID', transportationChannelSet(ii).target.instanceID, ...
                              '-or',...
                              'sourceFlowNetworkID', transportationChannelSet(ii).target.instanceID, '-and', 'targetFlowNetworkID', transportationChannelSet(ii).source.instanceID);
                
                % 2.3 Clean-up: delete the flow edge and reciprocal edge from the look-up list
                flowEdgeList(flowEdgeList(:,2) == flowEdgeList(1,3) & flowEdgeList(:,3) == flowEdgeList(1,2),:) = [];
                flowEdgeList(1,:) = [];
                
                ii = ii + 1;
            end
            
            %3) Create Edges from Transportation Channel
            % TO DO: Move method to mapping class
            
            % Add 8 flow edges: {resource, commodity} x {inbound, outbound} x {toDepot, toCustomer}
            flowEdgeSet(8*length(transportationChannelSet)) = FlowEdge;
            jj = 1;
            % Call createEdgeSet method of transportation channel
            for ii = 1:length(transportationChannelSet)
                e2 = transportationChannelSet(ii).createEdgeSet;
                flowEdgeSet(jj:jj+length(e2)-1) = e2;
                jj = jj+length(e2);
            end
            %Clean-up extra allocated flowEdges
            flowEdgeSet(jj:end) = [];
            
            %3.1) Create flowEdgeList from flowEdgeSet 
            flowEdgeList = zeros(length(flowEdgeSet),5);
            for ii = 1:length(flowEdgeSet)
                flowEdgeList(ii,:) = [0, flowEdgeSet(ii).sourceFlowNetworkID,flowEdgeSet(ii).targetFlowNetworkID,...
                                        flowEdgeSet(ii).grossCapacity,flowEdgeSet(ii).flowUnitCost];
            end
            
            %3.2) Assign instanceIDs to flowEdges
            flowEdgeList(:,1) = [1:length(flowEdgeList(:,1))]';
            for ii = 1:length(flowEdgeSet) 
                flowEdgeSet(ii).instanceID = ii;
            end
            
            
            self.transportationChannelSet = transportationChannelSet;
            self.FlowNodeSet{end+1} = transportationChannelSet;
            self.FlowEdgeSet = flowEdgeSet;
            self.FlowEdgeList = flowEdgeList;
        end

    end

end