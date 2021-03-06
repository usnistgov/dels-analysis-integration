classdef Process < ProcessNetwork
    %PROCESS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %^instanceID
        %^typeID
        %^name
        
        %^produces@Product
        %^consumes
        processStep %@Process {redefines processNode}
        processPlan %@Process {redefines parentProcessNetwork}
        
        %CONSUMPTION
        RenewableResourceSet@Resource
        RenewableResourceCapReq
        %BillofMaterial
        ConsumableResourceSet@Resource
        ConsumableResourceCapReq
        
        Revenue
    end
    
    methods
        function setProcessStep(self, input)
            if isa(input, 'Process')
               % processStep are a subset of processNodes; we have enforce subsetting via set methods.
               setSuccessFlag = 0;
               for ii = 1:length(self.processStep)
                    if strcmp(class(self.processStep{ii}), class(input))
                        self.processStep{ii}(end+1) = input;
                        setSuccessFlag = 1;
                        break;
                    end
               end
               if setSuccessFlag ==0
                   self.processStep{end+1} = input;
               end
               
               self.setProcessNodeSet(input)
            end
        end
        
        function setProduces(self, input)
           %Redefine produces property from FlowNetwork -- setter must type check restriction.
           if isa(input, 'Product')
              self.produces = input;
           else
               warning('Process produces Products -- input to produces property of Process must be a Product')
           end
        end
        
    end
    
end

