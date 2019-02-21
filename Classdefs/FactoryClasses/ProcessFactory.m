classdef ProcessFactory < NodeFactory
    %PROCESSFACTORY: ConcreteFactory object subclassed from NodeFactory
    
    properties
        %NodeSet@Process {redefines Node}
    end
    
    methods (Access = public)
        function obj = ProcessFactory(processSet)
           obj@NodeFactory(processSet);

           
        end %Constructor
        
      
        function Construct(PF, P)
            %Director Role: ProcessFactory switches from ConcreteFactory to Director pattern; 
            %Process class is configured as ConcreteBuilder. This ConcreteBuilder is responsible for
            %finishing the instantiation and customization of each process node
            Construct@NodeFactory(PF, P); 
            P.setProcessTime;
            P.setServerCount;
            P.setTimer;
            P.setStorageCapacity;
        end %redefines{NodeFactory.Construct}
        
    end
    
end

