classdef TransportationChannel < FlowNetwork
    %TRANSPORTATION_CHANNEL Summary of this class goes here
    %   Detailed explanation goes here
    %Note: Older versions of the instance data have the class name as
    %Transportation_Channel
    
    properties
        TravelDistance = 0 %{redefines: Weight}
        TravelRate
        Source
        Target
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
        
        function FlowEdgeSet = createEdgeSet(TC, DepotSet)
            %Maps a set of Flow Edges to a single Flow/Process Node and
            %creates the required new flow edges.
            %Future Work: How does mapping multiple flow edges to a TC
            
            FlowEdgeSet(8) = FlowEdge;
            kk=1;
            
            %Add Edges for flows from Source to Target
            FlowEdgeSet(kk).instanceID = kk;
            FlowEdgeSet(kk).OriginID = TC.Source;
            FlowEdgeSet(kk).DestinationID = TC.instanceID;
            FlowEdgeSet(kk).typeID = 'Shipment';
            kk= kk+1;

            FlowEdgeSet(kk).instanceID = kk;
            FlowEdgeSet(kk).OriginID = TC.instanceID;
            FlowEdgeSet(kk).DestinationID = TC.Target;
            FlowEdgeSet(kk).typeID = 'Shipment';
            kk=kk+1;
            
            if any(TC.Source == DepotSet(:))
                FlowEdgeSet(kk).instanceID = kk;
                FlowEdgeSet(kk).OriginID = TC.Source;
                FlowEdgeSet(kk).DestinationID = TC.instanceID;
                FlowEdgeSet(kk).typeID = 'Resource';
                kk=kk+1;

                FlowEdgeSet(kk).instanceID = kk;
                FlowEdgeSet(kk).OriginID = TC.instanceID;
                FlowEdgeSet(kk).DestinationID = TC.Source;
                FlowEdgeSet(kk).typeID = 'Resource';
                kk=kk+1;
            end
            
            %Add Edges for flows from Target To Source
            FlowEdgeSet(kk).instanceID = kk;
            FlowEdgeSet(kk).OriginID = TC.Target;
            FlowEdgeSet(kk).DestinationID = TC.instanceID;
            FlowEdgeSet(kk).typeID = 'Shipment';
            kk=kk+1;

            FlowEdgeSet(kk).instanceID = kk;
            FlowEdgeSet(kk).OriginID = TC.instanceID;
            FlowEdgeSet(kk).DestinationID = TC.Source;
            FlowEdgeSet(kk).typeID = 'Shipment';
            kk=kk+1;

           if any(TC.Target == DepotSet(:))
                FlowEdgeSet(kk).instanceID = kk;
                FlowEdgeSet(kk).OriginID = TC.Target;
                FlowEdgeSet(kk).DestinationID = TC.instanceID;
                FlowEdgeSet(kk).typeID = 'Resource';
                kk=kk+1;

                FlowEdgeSet(kk).instanceID = kk;
                FlowEdgeSet(kk).OriginID = TC.instanceID;
                FlowEdgeSet(kk).DestinationID = TC.Target;
                FlowEdgeSet(kk).typeID = 'Resource';
                kk=kk+1;
            end
            
            FlowEdgeSet = FlowEdgeSet(1:kk-1);
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

