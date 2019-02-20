classdef TransportationChannel < FlowNetwork
    %TRANSPORTATION_CHANNEL Summary of this class goes here
    %   Detailed explanation goes here
    %Note: Older versions of the instance data have the class name as
    %Transportation_Channel
    
    properties
        travelDistance = 0 %{redefines: Weight}
        travelRate
        source
        target
    end
    
    methods
        function decorateNode(TC)
            decorateNode@FlowNetwork(TC);
            for jj = 1:length(TC.PortSet)
                TC.PortSet(jj).setPortNum;
            end
            TC.setTravelTime;
            TC.buildStatusMetric; 
        end
        
        function buildPorts(TC)
            %Override Node's method to buildPorts; in this use case, the
            %Transportation Channel comes pre-built with its ports complete
        end
        
        function flowEdgeSet = createEdgeSet(self)
            %Maps a set of Flow Edges to a single Flow/Process Node and
            %creates the required new flow edges.
            %Future Work: How does mapping multiple flow edges to a TC
            
            flowEdgeSet(8) = FlowEdge;
            kk=1;
            
            %Add Edges for flows from source to self
            flowEdgeSet(kk).instanceID = kk;
            flowEdgeSet(kk).sourceFlowNetwork = self.source;
            flowEdgeSet(kk).sourceFlowNetworkID = self.source.instanceID;
            flowEdgeSet(kk).targetFlowNetwork = self;
            flowEdgeSet(kk).targetFlowNetworkID = self.instanceID;
            flowEdgeSet(kk).typeID = 'Shipment';
            kk= kk+1;

            flowEdgeSet(kk).instanceID = kk;
            flowEdgeSet(kk).sourceFlowNetwork = self;
            flowEdgeSet(kk).sourceFlowNetworkID = self.instanceID;
            flowEdgeSet(kk).targetFlowNetwork = self.target;
            flowEdgeSet(kk).targetFlowNetworkID = self.target.instanceID;
            flowEdgeSet(kk).typeID = 'Shipment';
            kk=kk+1;
            
            if isa(self.source, 'Depot')
                flowEdgeSet(kk).instanceID = kk;
                flowEdgeSet(kk).sourceFlowNetwork = self.source;
                flowEdgeSet(kk).sourceFlowNetworkID = self.source.instanceID;
                flowEdgeSet(kk).targetFlowNetwork = self;
                flowEdgeSet(kk).targetFlowNetworkID = self.instanceID;
                flowEdgeSet(kk).typeID = 'Resource';
                kk=kk+1;

                flowEdgeSet(kk).instanceID = kk;
                flowEdgeSet(kk).sourceFlowNetwork = self;
                flowEdgeSet(kk).sourceFlowNetworkID = self.instanceID;
                flowEdgeSet(kk).targetFlowNetwork = self.source;
                flowEdgeSet(kk).targetFlowNetworkID = self.source.instanceID;
                flowEdgeSet(kk).typeID = 'Resource';
                kk=kk+1;
            end
            
            %Add Edges for flows from target To source
            flowEdgeSet(kk).instanceID = kk;
            flowEdgeSet(kk).sourceFlowNetwork = self.target;
            flowEdgeSet(kk).sourceFlowNetworkID = self.target.instanceID;
            flowEdgeSet(kk).targetFlowNetwork = self;
            flowEdgeSet(kk).targetFlowNetworkID = self.instanceID;
            flowEdgeSet(kk).typeID = 'Shipment';
            kk=kk+1;

            flowEdgeSet(kk).instanceID = kk;
            flowEdgeSet(kk).sourceFlowNetwork = self;
            flowEdgeSet(kk).sourceFlowNetworkID = self.instanceID;
            flowEdgeSet(kk).targetFlowNetwork = self.source;
            flowEdgeSet(kk).targetFlowNetworkID = self.source.instanceID;
            flowEdgeSet(kk).typeID = 'Shipment';
            kk=kk+1;

           if isa(self.target, 'Depot')
                flowEdgeSet(kk).instanceID = kk;
                flowEdgeSet(kk).sourceFlowNetwork = self.target;
                flowEdgeSet(kk).sourceFlowNetworkID = self.target.instanceID;
                flowEdgeSet(kk).targetFlowNetwork = self;
                flowEdgeSet(kk).targetFlowNetworkID = self.instanceID;
                flowEdgeSet(kk).typeID = 'Resource';
                kk=kk+1;

                flowEdgeSet(kk).instanceID = kk;
                flowEdgeSet(kk).sourceFlowNetwork = self;
                flowEdgeSet(kk).sourceFlowNetworkID = self.instanceID;
                flowEdgeSet(kk).targetFlowNetwork = self.target;
                flowEdgeSet(kk).targetFlowNetworkID = self.target.instanceID;
                flowEdgeSet(kk).typeID = 'Resource';
                kk=kk+1;
            end
            
            flowEdgeSet = flowEdgeSet(1:kk-1);
            
            self.INFlowEdgeSet = findobj(flowEdgeSet, 'targetFlowNetworkID', self.instanceID);
            self.OUTFlowEdgeSet = findobj(flowEdgeSet, 'sourceFlowNetworkID', self.instanceID);
        end
    end
    
    methods (Access = private)
       function setTravelTime(TC)
            set_param(strcat(TC.SimEventsPath, '/TravelTime'), 'Value', strcat(num2str(TC.TravelDistance),'/', num2str(TC.TravelRate)));
        end
        
       function buildStatusMetric(TC)
            try
                set_param(strcat(TC.SimEventsPath, '/TC_Status'), 'VariableName', strcat(TC.Name,'_Status'));
                set_param(strcat(TC.SimEventsPath, '/Goto'), 'GotoTag', strcat(TC.Name,'_Status'));
            end
        end 
    end
    
end

