classdef IFlowNetworkBuilder < handle
    %IFLOWNETWORKBUILDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        systemElement
        model
        analysisTypeID
    end
    
    methods
        function construct(self)
            
        end
        
        function decorateNode(self)
            
        end
        
        function setSystemElement(self, input)
           if isa(input, 'FlowNetwork')
              self.systemElement = input;
              self.systemElement.builder = self;
           end
        end
        

    end
    
    
end

