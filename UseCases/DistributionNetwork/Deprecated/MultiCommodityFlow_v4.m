function solution = MultiCommodityFlow_v4(arc_comm_data, arc_data, FlowNode_CommoditySet)
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

% Add the CPLEX solver and APIs to the MATLAB working directory
addpath(genpath('C:\ILOG\CPLEX_Enterprise_Server1262\CPLEX_Studio\cplex\matlab')) %ISYE2015 Vlab

try
  
    nbflowVar = length(arc_comm_data); %flow var
    nbfixedVar = length(arc_data);
    nbVar = nbflowVar+nbfixedVar;
    nbArc = length(arc_data);
    nbNodes = max(arc_comm_data(:,1));
    nbComm = max(arc_comm_data(:,3));
    flowUB = max(FlowNode_CommoditySet(:,3));
    
    %Declare Cplex Input Variables
    f = zeros(nbVar,1);
    lb = zeros(nbVar,1);
    ub = ones(nbVar,1);
    
    % Add flow variables
    f(1:nbflowVar,:) = arc_comm_data(:,4);
    ub(1:nbflowVar,:) = flowUB*ones(nbflowVar,1);
    ctype{nbflowVar+nbfixedVar} = [];
    for i = 1:nbflowVar
        ctype{i} = 'I';
    end
    
    
    %Add fixed variables
    f(nbflowVar+1: nbflowVar+nbfixedVar,:) = arc_data(:, 4);
    ub(nbflowVar+1: nbflowVar+nbfixedVar,:) = ones(nbfixedVar,1);
    for i = nbflowVar+1:nbflowVar+nbfixedVar
        ctype{i} = 'B';
    end
    
    ctype = [ctype{:}];
    
    %Allocate Index Matrix
    A = zeros(3*nbflowVar, 3);
    bineq = zeros(2*nbArc,1);
    
    % Add Capacity Constraints
    j = 1;
    for i = 1:nbArc
       arc_comm = find(arc_comm_data(:, 1) == arc_data(i,1) & arc_comm_data(:, 2) == arc_data(i,2));
       
       if isempty(arc_comm) ==0
           A(j:j+length(arc_comm)-1,:) = [(i*2-1)*ones(length(arc_comm),1), arc_comm, -1*ones(length(arc_comm),1)];
           j = j+length(arc_comm);
           A(j:j+length(arc_comm)-1,:) = [(i*2)*ones(length(arc_comm),1), arc_comm, 1*ones(length(arc_comm),1)];
           j = j+length(arc_comm);

           bineq(i*2-1) = 0;
           A(j,:) = [i*2, nbflowVar+i, -1*arc_data(i,3)];
           j = j+1;
           bineq(i*2) = 0;
       end
    end
    
    %Make Aineq from Spare Index Matrix
    Aineq = sparse(A(1:j-1,1), A(1:j-1,2), A(1:j-1,3), 2*nbArc, nbVar);
    
    %Allocate Space for beq
    beq = zeros(nbComm*nbNodes,1);
    
    % Add Flow Conservation Constraints
    A = [(arc_comm_data(:, 3)-1)*nbNodes+arc_comm_data(:,1),[1:length(arc_comm_data)]', 1*ones(length(arc_comm_data),1)];
    A = [A; [(arc_comm_data(:, 3)-1)*nbNodes+arc_comm_data(:,2),[1:length(arc_comm_data)]', -1*ones(length(arc_comm_data),1)]];
    beq((arc_comm_data(:, 3)-1)*nbNodes+arc_comm_data(:,1)) = FlowNode_CommoditySet((arc_comm_data(:, 3)-1)*nbNodes+arc_comm_data(:,1), 3);

   Aeq = sparse(A(:,1), A(:,2), A(:,3), nbComm*nbNodes, nbVar);

   options = cplexoptimset;
   options.Diagnostics = 'on';
   options.MaxTime = 2400;
   
   [solution, fval, exitflag, output] = cplexmilp (f, Aineq, bineq, Aeq, beq,...
      [ ], [ ], [ ], lb, ub, ctype, [ ], options);
  

   %save('MCFN.mat', 'f', 'Aineq', 'bineq', 'Aeq', 'beq', 'lb', 'ub', 'ctype', 'x')
   
    
catch m
    throw (m);      
end
