classdef Product < Commodity
    %PRODUCT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %^name
        %^instanceID
        %^typeID
        %producedBy@Process %should redefine to processPlan,where processPlan is a subset of processes that touch a part
        processPlanList
        
        demand
        stdevDemand
        arrivalRate %is this the same as demand?
        BillOfMaterial@Resource
        
    end
    
    methods
        function setCreatedBy(self, process)
           if isa(process, 'Process')
              self.createdBy = process;
              self.producedBy = process;
           end
        end
    end
    
end

