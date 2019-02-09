classdef Component_Inventory < handle
    %COMPONENT_INVENTORY Summary of this class goes here
    %for now, we'll track inventory position; if a request comes in for
    %more than is available the inventory position will be negative and the
    %success_flag will be 0; we can track naive service levels
    
    properties
    Type %Name of the component; Eventually to be typed @Component
    Quantity %Qty in inventory
    Service = [0 0]%Temp property to hold successful decrement [success total]
    Service_Level %A naive calculation of service level of this component
    end
    
    methods
        function increment_inventory(self, qty)
            self.Quantity = self.Quantity + qty;
            
        end %increment_inventory
        function [success_flag] = decrement_inventory(self, qty)
            if qty > self.Quantity
               self.Quantity = self.Quantity-qty;
               self.Service(2) = self.Service(2) + 1;
            else
               self.Quantity = self.Quantity-qty;
               self.Service(1) = self.Service(1) + 1;
               self.Service(2) = self.Service(2) + 1;
            end
            
            self.calc_service_level;
        end %decrement_inventory
        
        function calc_service_level(self)
            self.Service_Level = self.Service(1)/self.Service(2);
        end %calc service level
    end
    
end

