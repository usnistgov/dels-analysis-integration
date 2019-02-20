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
            
            flowEdgeSet(8) = FlowEdge;
            kk=1;
            
            %Add Edges for flows from source to self
            flowEdgeSet(kk).sourceFlowNetwork = self.source;
            flowEdgeSet(kk).sourceFlowNetworkID = self.source.instanceID;
            flowEdgeSet(kk).targetFlowNetwork = self;
            flowEdgeSet(kk).targetFlowNetworkID = self.instanceID;
            flowEdgeSet(kk).typeID = 'Shipment';
            kk= kk+1;

            flowEdgeSet(kk).sourceFlowNetwork = self;
            flowEdgeSet(kk).sourceFlowNetworkID = self.instanceID;
            flowEdgeSet(kk).targetFlowNetwork = self.target;
            flowEdgeSet(kk).targetFlowNetworkID = self.target.instanceID;
            flowEdgeSet(kk).typeID = 'Shipment';
            kk=kk+1;
            
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
            
            %Add Edges for flows from target To source
            flowEdgeSet(kk).sourceFlowNetwork = self.target;
            flowEdgeSet(kk).sourceFlowNetworkID = self.target.instanceID;
            flowEdgeSet(kk).targetFlowNetwork = self;
            flowEdgeSet(kk).targetFlowNetworkID = self.instanceID;
            flowEdgeSet(kk).typeID = 'Shipment';
            kk=kk+1;

            flowEdgeSet(kk).sourceFlowNetwork = self;
            flowEdgeSet(kk).sourceFlowNetworkID = self.instanceID;
            flowEdgeSet(kk).targetFlowNetwork = self.source;
            flowEdgeSet(kk).targetFlowNetworkID = self.source.instanceID;
            flowEdgeSet(kk).typeID = 'Shipment';
            kk=kk+1;

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
               flowEdgeSet(ii).flowUnitCost = 0;
               flowEdgeSet(ii).grossCapacity = inf;
            end
            
            self.inFlowEdgeSet = findobj(flowEdgeSet, 'targetFlowNetworkID', self.instanceID);
            self.outFlowEdgeSet = findobj(flowEdgeSet, 'sourceFlowNetworkID', self.instanceID);
        end 
    end
 
end

