function [finalResult, FVAL, exitflag, Population] =  CT_GA( Model, Parallel)

CustomerSet = {'Customer_1','Customer_2', 'Customer_3', 'Customer_4', 'Customer_5'};
DepotSet = {'Depot_6', 'Depot_9', 'Depot_10'};

try
    
    N = length(DepotSet);
    CTtarget = 24;
    UTILtarget = .975;

    ServerCost= [1000, 1000, 1000]';
    
    if strcmp(Parallel, 'true')==1
        UseParallel;
    end
    
    InitialPopulation = 4*ones(1,N);
    lb = max(InitialPopulation - 5,1);
    ub = InitialPopulation +5;


    warning('off','all');
    opts = gaoptimset('PlotFcns', {@gaplotbestf; @gaplotbestindiv},'Generations', 25, 'StallGenLimit', 10, 'UseParallel', 'always', ...
        'PopulationSize', 5, 'InitialPopulation', InitialPopulation);
    
    IntCon = [1:N];
    tic

    [finalResult, FVAL, exitflag, Output, Population] = ga(@(X)productionCost(X, Model, DepotSet, CustomerSet, ServerCost, CTtarget, UTILtarget),N,[],[],[],[], lb,ub,[],IntCon,opts);
    
    fprintf('Solution', finalResult);
    fprintf('Solution_Value', FVAL);
    
    for j = 1:length(finalResult)
        set_param(strcat('Distribution/',char(DepotSet{j}), '/Resource_Pool'), 'Quantity', num2str(finalResult(j)));
    end
    
    toc
    warning('on','all');
    if strcmp(Parallel, 'true') == 1
        matlabpool('close');
    end
catch err
    warning('on', 'all');
    matlabpool('close');
    rethrow(err)
end

end

function obj = productionCost(vecX, Model, DepotSet, CustomerSet, ServerCost, CTtarget, UTILtarget)
% Objection function to run as part of the genetic algorithm


        for j = 1:length(vecX)
                set_param(strcat('Distribution/',char(DepotSet{j}), '/Resource_Pool'), 'Quantity', num2str(vecX(j)));
        end
        

        simOut = sim(Model,'StopTime', '2000', 'SaveOutput', 'on');
        
        CustomerArrivals = [];
        for i = 1:length(CustomerSet)
            CustomerArrivals = [CustomerArrivals; simOut.get(char(CustomerSet{i})).time, simOut.get(char(CustomerSet{i})).signals.values];
        end


        Customer_CycleTime = [CustomerArrivals(:,1) - CustomerArrivals(:,4)];
       
        obj = vecX*ServerCost + 5*sum(Customer_CycleTime>CTtarget)+ 0.5*sum(max(Customer_CycleTime-CTtarget,0));
end

function UseParallel
    load_system('Distribution')
    matlabpool('open')
    spmd
        load_system('Distribution')
        se_randomizeseeds('Distribution', 'Mode', 'All', 'Verbose', 'off');
    end
end