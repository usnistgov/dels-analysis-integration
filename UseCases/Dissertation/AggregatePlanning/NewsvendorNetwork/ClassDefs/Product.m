classdef Product < handle
    %PRODUCT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID
        meanDemand
        stdevDemand
        BillOfMaterial@Resource
        canBeCreatedBy@Process
    end
    
    methods
    end
    
end

