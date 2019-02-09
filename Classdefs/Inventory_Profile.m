classdef Inventory_Profile < handle
    %INVENTORY_PROFILE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Inventory_List= {}
        ComponentSet@Component_Inventory
    end
    
    methods
        function add_component(self, type)
            %naive implementation of initiating the inventory profile
            self.Inventory_List = [self.Inventory_List; type];
            self.ComponentSet(end+1) = Component_Inventory;
            self.ComponentSet(end).Type = type;
            self.ComponentSet(end).Quantity = 3;
        end %add_component
        
        function consumption_arrival(self, type, qty)
            index = find(strcmp(self.Inventory_List, type));
            self.ComponentSet(index).decrement_inventory(qty);
        end
        
        function replenishment_arrival(self, type, qty)
            index = find(strcmp(self.Inventory_List, type));
            self.ComponentSet(index).increment_inventory(qty);
        end
        
        function [Component] = find(self, type)
            index = find(strcmp(self.Inventory_List, type));
            Component = self.ComponentSet(index);
        end
    end
    
end

