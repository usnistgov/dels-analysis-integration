function solution = MultiCommodityFlow_v3(arc_comm_data, arc_data, supply_data)
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
  
    nbflowVar = length(arc_comm_data); %flow var
    nbfixedVar = length(arc_data);
    nbVar = nbflowVar+nbfixedVar;
    nbArc = length(arc_data);
    nbNodes = max(arc_comm_data(:,2));
    nbComm = max(arc_comm_data(:,1));
    flowUB = max(supply_data(:,3));
    
    %Declare Input Variables
    f = zeros(nbVar,1);
    lb = zeros(nbVar,1);
    ub = ones(nbVar,1);
    intcon = [1:nbflowVar+nbfixedVar];
    
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
    %for i = 1:nbfixedVar
    %    ctype = strcat(ctype,'B');
    %end
    
    
    %Allocate Sparse Matrix
    nzmax = 3*nbflowVar;
    Aineq = spalloc(2*nbArc,nbVar,nzmax);
    %Aineq = zeros(2*nbArc,nbVar);
    bineq = zeros(2*nbArc,1);
    

    % Add Capacity Constraints
    for i = 1:nbArc
       %S = zeros(1, nbVar);
       arc_comm = find(arc_comm_data(:, 2) == arc_data(i,1) & arc_comm_data(:, 3) == arc_data(i,2));
       for j = 1:length(arc_comm)
           Aineq(i*2-1, arc_comm(j)) = -1;
           Aineq(i*2, arc_comm(j)) = 1;
       end
       
       bineq(i*2-1) = 0;
       Aineq(i*2, nbflowVar+i) = -1*arc_data(i,3);
       bineq(i*2) = 0;
    end
    
    nzmax = 2*nbflowVar;
    Aeq = spalloc(nbComm*nbNodes,nbVar,nzmax);
    %Aeq = zeros(nbComm*nbNodes,nbVar);
    beq = zeros(nbComm*nbNodes,1);
    
    % Add Flow Conservation Constraints

    for k = 1:length(arc_comm_data)
        Aeq((arc_comm_data(k, 1)-1)*nbNodes+arc_comm_data(k,2),k) =1;
        Aeq((arc_comm_data(k, 1)-1)*nbNodes+arc_comm_data(k,3), k) =-1;
        beq((arc_comm_data(k, 1)-1)*nbNodes+arc_comm_data(k,2)) = supply_data((arc_comm_data(k, 1)-1)*nbNodes+arc_comm_data(k,2), 3);
    end
    

   %%%% CPLEX-Specific:
   %options = cplexoptimset;
   %options.Diagnostics = 'on';
   %options.MaxTime = 2400;
   
   %%%% MATLAB Optimization Toolbox
   %[solution, fval, exitflag, output] = intlinprog (f, intcon', Aineq, bineq, Aeq, beq, lb, ub);
    
   %%%% OPTI Toolbox
   %If MATLAB Optimization toolbox is available, OPTI will call it.
   opts = optiset('solver', 'auto','display','iter');
   Opt = opti('f',f,'ineq',Aineq,bineq,'eq',Aeq,beq,'bounds',lb,ub,'int',intcon', 'options', opts);
   [solution, fval, exitflag, output] =  solve(Opt);

   %%%% CPLEX-Specific:
   %[solution, fval, exitflag, output] = cplexmilp (f, Aineq, bineq, Aeq, beq, ...
   %   [ ], [ ], [ ], lb, ub, ctype, [ ], options);
  
   fprintf('\n   Cost = %f\n', fval);    
   %save('MCFN.mat', 'f', 'Aineq', 'bineq', 'Aeq', 'beq', 'lb', 'ub', 'ctype', 'x')
   

   solution = x;
    
catch m
    throw (m);      
end
