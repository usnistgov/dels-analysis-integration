function solution = MultiCommodityFlow_v0(arc_comm_data, arc_data, supply_data)
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
	%Build Model
    MCF = Cplex('MCF');
    MCF.Model.sense = 'minimize';
    
    nbflowVar = length(arc_comm_data); %flow var
    nbfixedVar = length(arc_data);
    nbVar = nbflowVar+nbfixedVar;
    nbArc = length(arc_data);
    nbNodes = max(arc_comm_data(:,2));
    nbComm = max(arc_comm_data(:,1));
    flowUB = max(supply_data(:,3));
    
    % Add flow variables
    for i = 1:nbflowVar
        MCF.addCols(arc_comm_data(i,4), [], 0, flowUB , 'I', strcat('x_',num2str(arc_comm_data(i,2)), num2str(arc_comm_data(i,3)), '^', num2str(arc_comm_data(i,1))));
    end
    
    %Add fixed variables
    for i = 1:nbfixedVar
        MCF.addCols(arc_data(i, 4), [], 0, 1, 'B', strcat('y_', num2str(arc_data(i,1)), num2str(arc_data(i,2)))); 
    end

    % Add Capacity Constraints
    for i = 1:nbArc
       A = zeros(1, nbVar);
       for j = 1:nbflowVar
           if arc_data(i,1:2) == arc_comm_data(j, 2:3);
               A(j) = 1;
           end
       end
       
       A(nbflowVar+i) = -1*arc_data(i,3);
              
       MCF.addRows(-inf,A, 0, strcat('cc_', num2str(arc_data(i,1)), num2str(arc_data(i,2))));
    end
    
    % Add Flow Conservation Constraints
    for i = 1:nbComm
        for j = 1:nbNodes
            A = zeros(1, nbVar);
            for k = 1:nbflowVar
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
    
    solution = zeros(nbVar,1);
    %disp (' - Solution:');
    %for j = 1:nbVar
    %    solution(j) = MCF.Solution.x(j);
    %end
    
    
    fprintf('\n   Cost = %f\n', MCF.Solution.objval);
    
    %[arc_comm_data(solution(1:length(arc_comm_data))>0,2:4), solution(solution(1:length(arc_comm_data))>0)]
    %[solution(length(arc_comm_data)+1: end), arc_data]
    
    
catch m
    throw (m);      
end
