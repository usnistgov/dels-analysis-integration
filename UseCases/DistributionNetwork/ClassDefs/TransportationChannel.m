classdef TransportationChannel < FlowNetwork
    %TRANSPORTATION_CHANNEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        travelDistance = 0 %{redefines: Weight}
        travelRate
        source
        sourceID
        target
        targetID
    end
    
    methods (Access = public)
       function flowEdgeSet = createEdgeSet(self)
            %Maps a set of Flow Edges to a single Flow/Process Node and
            %creates the required new flow edges.
            %Future Work: How does mapping multiple flow edges to a TC
            
            flowEdgeSet(8) = FlowNetworkLink;
            kk=1;
            
            % 1) Add two edges to replace edge from source to target
            referenceFlowEdge = findobj(self.flowEdgeSet,...
                              'sourceFlowNetworkID', self.source.instanceID,...
                              '-and', ...
                              'targetFlowNetworkID', self.target.instanceID);                     
            
            % 1a) Create edge from source to self
            flowEdgeSet(kk).sourceFlowNetwork = self.source;
            flowEdgeSet(kk).sourceFlowNetworkID = self.source.instanceID;
            flowEdgeSet(kk).targetFlowNetwork = self;
            flowEdgeSet(kk).targetFlowNetworkID = self.instanceID;
            flowEdgeSet(kk).typeID = 'Shipment';
            % 1b) Copy the flow properties of the original edge
            flowEdgeSet(kk).flowTypeAllowed = referenceFlowEdge.flowTypeAllowed;
            flowEdgeSet(kk).flowAmount = referenceFlowEdge.flowAmount;            
            kk= kk+1;
            
            % 1c) Create edge from self to target
            flowEdgeSet(kk).sourceFlowNetwork = self;
            flowEdgeSet(kk).sourceFlowNetworkID = self.instanceID;
            flowEdgeSet(kk).targetFlowNetwork = self.target;
            flowEdgeSet(kk).targetFlowNetworkID = self.target.instanceID;
            flowEdgeSet(kk).typeID = 'Shipment';
            % 1d) Copy the flow properties of the original edge
            flowEdgeSet(kk).flowTypeAllowed = referenceFlowEdge.flowTypeAllowed;
            flowEdgeSet(kk).flowAmount = referenceFlowEdge.flowAmount;
            kk=kk+1;
            
            % 1e) If the source is a depot, add resource edges
            if isa(self.source, 'Depot')
                flowEdgeSet(kk).sourceFlowNetwork = self.source;
                flowEdgeSet(kk).sourceFlowNetworkID = self.source.instanceID;
                flowEdgeSet(kk).targetFlowNetwork = self;
                flowEdgeSet(kk).targetFlowNetworkID = self.instanceID;
                flowEdgeSet(kk).typeID = 'Resource';
                kk=kk+1;

                flowEdgeSet(kk).sourceFlowNetwork = self;
                flowEdgeSet(kk).sourceFlowNetworkID = self.instanceID;
                flowEdgeSet(kk).targetFlowNetwork = self.source;
                flowEdgeSet(kk).targetFlowNetworkID = self.source.instanceID;
                flowEdgeSet(kk).typeID = 'Resource';
                kk=kk+1;
            end
            
            % 2) Add two edges to replace edge from target to source
            referenceFlowEdge = findobj(self.flowEdgeSet,...
                              'sourceFlowNetworkID', self.target.instanceID, ...
                              '-and', ...
                              'targetFlowNetworkID', self.source.instanceID);
                          
            % 2a) Create edge from target to self 
            flowEdgeSet(kk).sourceFlowNetwork = self.target;
            flowEdgeSet(kk).sourceFlowNetworkID = self.target.instanceID;
            flowEdgeSet(kk).targetFlowNetwork = self;
            flowEdgeSet(kk).targetFlowNetworkID = self.instanceID;
            flowEdgeSet(kk).typeID = 'Shipment';
            
            % 2b) Copy the flow properties of the original edge
            flowEdgeSet(kk).flowTypeAllowed = referenceFlowEdge.flowTypeAllowed;
            flowEdgeSet(kk).flowAmount = referenceFlowEdge.flowAmount;
            kk=kk+1;
            
            % 2c) Create edge from self to source
            flowEdgeSet(kk).sourceFlowNetwork = self;
            flowEdgeSet(kk).sourceFlowNetworkID = self.instanceID;
            flowEdgeSet(kk).targetFlowNetwork = self.source;
            flowEdgeSet(kk).targetFlowNetworkID = self.source.instanceID;
            flowEdgeSet(kk).typeID = 'Shipment';
            
            % 2d) Copy the flow properties of the original edge
            flowEdgeSet(kk).flowTypeAllowed = referenceFlowEdge.flowTypeAllowed;
            flowEdgeSet(kk).flowAmount = referenceFlowEdge.flowAmount;
            kk=kk+1;
            
            % 1e) If the source is a depot, add resource edges
           if isa(self.target, 'Depot')
                flowEdgeSet(kk).sourceFlowNetwork = self.target;
                flowEdgeSet(kk).sourceFlowNetworkID = self.target.instanceID;
                flowEdgeSet(kk).targetFlowNetwork = self;
                flowEdgeSet(kk).targetFlowNetworkID = self.instanceID;
                flowEdgeSet(kk).typeID = 'Resource';
                kk=kk+1;

                flowEdgeSet(kk).sourceFlowNetwork = self;
                flowEdgeSet(kk).sourceFlowNetworkID = self.instanceID;
                flowEdgeSet(kk).targetFlowNetwork = self.target;
                flowEdgeSet(kk).targetFlowNetworkID = self.target.instanceID;
                flowEdgeSet(kk).typeID = 'Resource';
                kk=kk+1;
            end
            
            flowEdgeSet = flowEdgeSet(1:kk-1);
            
            %Make flow edges free and uncapacitated -- transportation channels will handle cost/capacity constraints
            for ii = 1:length(flowEdgeSet)
               flowEdgeSet(ii).flowFixedCost = 0;
               flowEdgeSet(ii).grossCapacity = inf;
               flowEdgeSet(ii).flowUnitCost = 0;
               flowEdgeSet(ii).flowCapacity = inf(length(flowEdgeSet(ii).flowAmount),1);
            end
            
            self.inFlowEdgeSet = findobj(flowEdgeSet, 'targetFlowNetworkID', self.instanceID);
            self.outFlowEdgeSet = findobj(flowEdgeSet, 'sourceFlowNetworkID', self.instanceID);
        end 
    end
 
end

