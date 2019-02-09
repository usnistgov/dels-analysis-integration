function solution = MultiCommodityFlow_v1(arc_comm_data, arc_data, supply_data)
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
    
    %Declare Cplex Input Variables
    f = zeros(nbVar,1);
    lb = zeros(nbVar,1);
    ub = ones(nbVar,1);
    ctype = char(nbVar,1);
    
    % Add flow variables
    f(1:nbflowVar,:) = arc_comm_data(:,4);
    ub(1:nbflowVar,:) = flowUB*ones(nbflowVar,1);
    ctype = 'I';
    for i = 2:nbflowVar
        ctype = strcat(ctype,'I');
    end
    
    %Add fixed variables
    f(nbflowVar+1: nbflowVar+nbfixedVar,:) = arc_data(:, 4);
    ub(nbflowVar+1: nbflowVar+nbfixedVar,:) = ones(nbfixedVar,1);
    for i = 1:nbfixedVar
        ctype = strcat(ctype,'B');
    end
    
    %Allocate Sparse Matrix
    %nzmax = 
    %A = spalloc(nbArc+nbComm*nbNodes,nbVar,nzmax)
    Aineq = zeros(2*nbArc,nbVar);
    bineq = zeros(2*nbArc,1);
    

    % Add Capacity Constraints
    for i = 1:nbArc
       S = zeros(1, nbVar);
       for j = 1:nbflowVar
           if arc_data(i,1:2) == arc_comm_data(j, 2:3);
               S(j) = 1;
           end
       end
       
       Aineq(i*2-1,:) = -S;
       bineq(i*2-1) = 0;
       S(nbflowVar+i) = -1*arc_data(i,3);
       Aineq(i*2,:) = S;
       bineq(i*2) = 0;
    end
    
    Aeq = zeros(nbComm*nbNodes,nbVar);
    beq = zeros(nbComm*nbNodes,1);
    
    % Add Flow Conservation Constraints
    for i = 1:nbComm
        for j = 1:nbNodes
            S = zeros(1, nbVar);
            for k = 1:nbflowVar
                if arc_comm_data(k, 1)==i && arc_comm_data(k,2) ==j
                    S(k) =1;
                end
                if arc_comm_data(k, 1)==i && arc_comm_data(k,3) ==j
                    S(k) =-1;
                end
            end
            
            Aeq((i-1)*nbNodes+j,:) = S;
            beq((i-1)*nbNodes+j) = supply_data((i-1)*nbNodes+j, 3);
        end
    end
    
    %disp(MCF.Model.A);
    %sense, obj,lb, ub, A, lhs, rhs, name, ctype, colname, rowname
    
   options = cplexoptimset;
   options.Diagnostics = 'on';
   
   [x, fval, exitflag, output] = cplexmilp (f, Aineq, bineq, Aeq, beq,...
      [ ], [ ], [ ], lb, ub, ctype, [ ], options);
   
   %fprintf ('\nSolution status = %s \n', output.cplexstatusstring);
   fprintf ('Solution value = %f \n', fval);
   %disp ('Values =');
   %disp (x');
   solution = x;
    
    [arc_comm_data(solution(1:length(arc_comm_data))>0,2:4), solution(solution(1:length(arc_comm_data))>0)]
    [solution(length(arc_comm_data)+1: end), arc_data]
    
    
catch m
    throw (m);      
end
