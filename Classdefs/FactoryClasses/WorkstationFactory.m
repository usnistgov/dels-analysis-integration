classdef WorkstationFactory < NodeFactory
    %WORKSTATIONFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %NodeSet@Workstation
    end
    
    methods
        function obj = WorkstationFactory
            obj.Type = 'Workstation';
        end %Constructor
        
        function CreateNodes(WF) %CreateWorkstations {redefines CreateNodes}
           CreateNodes@NodeFactory(WF); 
        end
        
        function setNodeSet(WF) %setWorkstationSet {redefines setNodeSet}
            setNodeSet@NodeFactory(WF);
        end 
        
        function Construct(WF, W) %{redefines Construct(NF, N) }
            Construct@NodeFactory(WF, W); 
            %W.CreateProcesses;
            %W.BuildResourcePools;
            %W.setProcessTime;
        end

        
    end % end methods
    
end

