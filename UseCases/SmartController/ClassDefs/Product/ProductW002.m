classdef ProductW002 < Product
    %PRODUCTX001 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %processPlan@MakeProductW002
    end
    
    methods
        function obj = ProductW002(serialNumber)
            if nargin>0
            	obj.serialNumber = serialNumber;
            end
            obj.instanceID = string(java.rmi.server.UID().toString());
            obj.typeID = 'ProductW002';
            obj.processPlan = MakeProductW002;
            obj.processPlan.creates = obj.instanceID;
        end

    end
end

