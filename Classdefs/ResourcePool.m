classdef ResourcePool < handle
    %RESOURCEPOOL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Workstation_ID
        Workstation
        Name
        Type
        Subtype
        Quantity
    end
    
    methods
        function set_name(RP)
            RP.Name = strcat('Resource_Pool_Type_', RP.Type);
        end % set name
    end
    
end

