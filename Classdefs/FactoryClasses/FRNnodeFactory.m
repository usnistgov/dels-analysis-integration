classdef FRNnodeFactory < NodeFactory
    %FRNNODEFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %NodeSet@Warehouse_Fcn {redefines Node}
    end
    
    methods (Access = public)
        function obj = FRNnodeFactory
            obj.Type = 'Warehouse_Fcn';
        end
        
        function setNodeSet(NF)
            sqlstring = 'SELECT * FROM FRNnodeTable ORDER BY FRNnodeTable.Node_ID;';
            NF.NodeSet = NF.parse_nodes(sqlstring);
        end
        
    end
    
end

