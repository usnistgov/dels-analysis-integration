classdef Process < handle
    %PROCESS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID
        Revenue
        %PRODUCTION
        Produces@Product
        %BillOfProcess
        
        %CONSUMPTION
        RenewableResourceSet@Resource
        RenewableResourceCapReq
        %BillofMaterial
        ConsumableResourceSet@Resource
        ConsumableResourceCapReq
    end
    
    methods
    end
    
end

