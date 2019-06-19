classdef Machine < handle
    %MACHINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetObservable)
        instanceID
        typeID
        serialNumber
        machineHealth = 0
    end
    
    methods
        function obj = Machine(serialNumber)
            if nargin>0
                obj.serialNumber = serialNumber;
                obj.instanceID = serialNumber;
                obj.typeID = 'Machine';
            end
        end
    end
end

