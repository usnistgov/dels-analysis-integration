classdef PackShipClose < Process
    %COMPLETECLOSEPROCESS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = PackShipClose()
            obj@Process
            obj.targetResource = 5;
            obj.typeID = 'PackShipClose';
        end
    end
end

