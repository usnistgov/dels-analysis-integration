classdef TransportationChannelSimEventsBuilder < FlowNetworkSimEventsBuilder
    %TRANSPORTATIONCHANNELSIMULATIONBUILDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties

    end
    
    methods (Access = public)
        function construct(self)
            self.assignPorts;
            for jj = 1:length(self.portSet)
                self.portSet(jj).setPortNum;
            end
            self.buildPorts;
            self.setTravelTime;
            self.buildStatusMetric; 
        end
        
       function buildPorts(self)
            %Override Node's method to buildPorts; in this use case, the
            %Transportation Channel comes pre-built with its ports complete
       end
    end
    
    methods (Access = private)
       function setTravelTime(self)
            set_param(strcat(self.simEventsPath, '/TravelTime'), 'Value', strcat(num2str(self.systemElement.travelDistance),'/', num2str(self.systemElement.travelRate)));
        end
        
       function buildStatusMetric(self)
            try
                set_param(strcat(self.simEventsPath, '/TC_Status'), 'VariableName', strcat(self.systemElement.name,'_Status'));
                set_param(strcat(self.simEventsPath, '/Goto'), 'GotoTag', strcat(self.systemElement.name,'_Status'));
            end
        end 
    end
end

