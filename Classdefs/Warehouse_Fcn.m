classdef Warehouse_Fcn < Node
    %FRNNODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Subtype
        FlowProbability
    end
    
    methods (Access = public)
        function InitializeSubtype(WF)
            
            block = add_block(strcat('FRN_Library/', WF.Subtype), strcat(WF.Location, '/', WF.Subtype));
            set_param(block, 'Position', [1155, 507, 1455, 658])
            %in this position, the lines will automatically connect
            %should not rely on this, but it works for now
        end %initialize subtype {protected method}
        
        function BuildFlowMetric(WF)
            %Add the Discrete Event Signal to Workspace Block
            
            %Rename the blocks
            
            set_param(strcat(WF.Location, '/FlowRecord/OUTFlow_Metric'), 'VariableName', strcat('OUTFlow_Metric_', WF.Node_Name));
            set_param(strcat(WF.Location, '/FlowRecord/INFlow_Metric'), 'VariableName', strcat('INFlow_Metric_', WF.Node_Name));
            
            
        end %
        
    end %protected methods
    
end

