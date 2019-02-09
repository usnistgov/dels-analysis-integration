function WinterSimScript_v00(varargin)
% Solve Multi-Commodity Flow problem using CPLEX

% Indices:
% i,j \in V := nodes on the graph
% (i,j) \in E := directed arcs on the graph
% k \in K := commodities

% Data:
% c^k_{ij} := cost of sending a unit of commodity k along arc (i,j)
% u_{ij} := capacity of arc (i,j)
% b_i^k := supply (demand) for each node and each commodity

% Variables:
% x^k_{ij} := amount of commodity k to flow along arc (i,j)

% Input Data is in the form of:
% arc_comm_data: k i j cost
% arc_data: i j capacity
% supply_data: k i supply

try
    %Read the data
    arc_comm_data = [1,1,2,124.648714643791;1,1,3,198.802689341820;1,2,1,124.648714643791;1,2,3,152.380868166918;1,3,1,198.802689341820;1,3,2,152.380868166918;2,1,2,124.648714643791;2,1,3,198.802689341820;2,2,1,124.648714643791;2,2,3,152.380868166918;2,3,1,198.802689341820;2,3,2,152.380868166918];
                
	arc_data = [1,2,Inf;1,3,Inf;2,1,Inf;2,3,Inf;3,1,Inf;3,2,Inf];
            
	supply_data = [1,1,682;1,2,-682;1,3,0;2,1,-464;2,2,464;2,3,0];
                
	%Build Model
    MCF = Cplex('MCF');
    MCF.Model.sense = 'minimize';
    
    nbVar = length (arc_comm_data);
    nbArc = length(arc_data);
    nbNodes = 3;
    nbComm = 2;
    
    % Add variables
    for i = 1:nbVar
        MCF.addCols(arc_comm_data(i,4), [], 0, 30, 'I', strcat('x_',num2str(arc_comm_data(i,2)), num2str(arc_comm_data(i,3)), '^', num2str(arc_comm_data(i,1))));
    end

    % Add Capacity Constraints
    for i = 1:nbArc
       A = zeros(1, nbVar);
       for j = 1:nbVar
           if arc_data(i,1:2) == arc_comm_data(j, 2:3);
               A(j) = 1;
           end
       end
       MCF.addRows(0,A, arc_data(i,3), strcat('cc_', num2str(arc_data(i,1)), num2str(arc_data(i,2))));
    end
    
    % Add Flow Conservation Constraints
    for i = 1:nbComm
        for j = 1:nbNodes
            A = zeros(1, nbVar);
            for k = 1:nbVar
                if arc_comm_data(k, 1)==i && arc_comm_data(k,2) ==j
                    A(k) =1;
                end
                if arc_comm_data(k, 1)==i && arc_comm_data(k,3) ==j
                    A(k) =-1;
                end
            end
            MCF.addRows(supply_data((i-1)*nbNodes+j, 3), A, supply_data((i-1)*nbNodes+j, 3), strcat('FC_', num2str(j), '^', num2str(i)));
        end
    end
    
    %disp(MCF.Model.A);
    %sense, obj,lb, ub, A, lhs, rhs, name, ctype, colname, rowname
    
    MCF.solve();
    MCF.writeModel('MCF.mps');
    
    disp (' - Solution:');
    for j = 1:nbVar
        fprintf('%d\t', MCF.Solution.x(j));
    end
    
    fprintf('\n   Cost = %f\n', MCF.Solution.objval);
    
    
catch m
    throw (m);      
end
