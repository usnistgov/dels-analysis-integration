classdef ProcessFactory < FlowNodeFactory
    %PROCESSFACTORY: ConcreteFactory object subclassed from NodeFactory
    
    properties
        %NodeSet@Process {redefines Node}
    end
    
    methods (Access = public)
      
        function construct(PF, P)
            %Director Role: ProcessFactory switches from ConcreteFactory to Director pattern; 
            %Process class is configured as ConcreteBuilder. This ConcreteBuilder is responsible for
            %finishing the instantiation and customization of each process node
            Construct@NodeFactory(PF, P); 
            P.setProcessTime;
            P.setServerCount;
            P.setTimer;
            P.setStorageCapacity;
        end %redefines{NodeFactory.Construct}
        
        function buildAnalysisModel(self, varargin)

        end %end buildAnalysisModel
        
    end
    
end

