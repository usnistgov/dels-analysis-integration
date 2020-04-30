classdef ProductY001 < Product
    %PRODUCTY001 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %processPlan@MakeProductY001
    end
    
    methods
        function obj = ProductY001(serialNumber)
            if nargin>0
            	obj.serialNumber = serialNumber;
            end
            
            obj.instanceID = string(java.rmi.server.UID().toString());
            obj.typeID = 'ProductY001';
            obj.processPlan = MakeProductY001;
            obj.processPlan.creates = obj.instanceID;
        end
        

    end
end
