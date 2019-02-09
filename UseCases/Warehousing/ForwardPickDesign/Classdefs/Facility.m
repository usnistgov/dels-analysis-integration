classdef Facility < handle
    %FACILITY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
       aisles
       slot_width
       aisle_width
       slots
       PD_Node@Node
       PD_aisle
    end
    
    properties (Access = private)
        layout@Network
        storage@Network
        
    end
    
    methods (Access = public)
        function d = TravelDistance(F, Origin, Destination)
            d = dijk(F.layout.EdgeSetAdjList, Origin, Destination);
        end

    end
    
    methods (Access = private)
        function generateLayout(F)
        end
    end
    
end

