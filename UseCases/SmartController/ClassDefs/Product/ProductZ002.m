classdef ProductZ002 < Product
    %PRODUCTX001 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %processPlan@MakeProductX001
    end
    
    methods
        function obj = ProductZ002(serialNumber)
            if nargin>0
            	obj.serialNumber = serialNumber;
            end
            obj.instanceID = string(java.rmi.server.UID().toString());
            obj.typeID = 'ProductZ002';
            obj.processPlan = MakeProductZ002;
            obj.processPlan.creates = obj.instanceID;
        end

    end
end

