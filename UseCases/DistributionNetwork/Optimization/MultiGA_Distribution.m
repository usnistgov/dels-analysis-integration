
function [finalResult, FVAL, exitflag, Population] =  MultiGA_Distribution(Model, CustomerSet, DepotSet, ResourceCost, InitPop, Parallel)
%CustomerSet = {'Customer_1','Customer_2', 'Customer_3', 'Customer_4', 'Customer_5'};
%DepotSet = {'Depot_6', 'Depot_9', 'Depot_10'};
%global OBJVAL;
%OBJVAL = zeros(1, length(DepotSet)+2);
try
    
    N = length(DepotSet);
    CTtarget = 24;
    UTILtarget = .975;

    %ResourceCost= [1000, 1000, 1000]';
    
    if strcmp(Parallel, 'true')==1
        UseParallel(Model);
    end
    
    %InitialPopulation = 4*ones(1,N);
    lb = ones(1,N);
    ub = 30*ones(1,N);
    
    warning('off','all');
    opts = gaoptimset('PlotFcns', {@gaplotpareto},'Generations', 15, 'StallGenLimit', 3,'UseParallel', 'always', 'InitialPopulation', InitPop, 'PopulationSize', 350, 'ParetoFraction', .9);
    
    IntCon = [1:N];
    objThreshold = [0, CTtarget, UTILtarget];
    clear distributionCost;
    [finalResult, FVAL, exitflag, Output, Population] = gamultiobj(@(X)distributionCost(X, Model, DepotSet, CustomerSet, ResourceCost, objThreshold),N,[],[],[],[], lb,ub,opts);
    
    finalResult = ceil(finalResult);
    %fprintf('Solution', finalResult);
    %fprintf('Solution_Value', FVAL);

    warning('on', 'all');
    poolobj = gcp('nocreate');
    delete(poolobj);
    clear distributionCost;
    
catch err
    warning('on', 'all');
    poolobj = gcp('nocreate');
    delete(poolobj);
    clear distributionCost;
    rethrow(err)
end

end

function obj = distributionCost(vecX, Model, DepotSet, CustomerSet, ResourceCost, objThreshold)
% Objection function to run as part of the genetic algorithm
persistent OBJVAL;
obj = zeros(2,1);

        if isempty(OBJVAL)
            OBJVAL = zeros(1, length(vecX) + 2);
        end

        match = ismember(OBJVAL(:,1:length(vecX)), ceil(vecX), 'rows');
        
        if any(match)
            obj = OBJVAL(match, (length(vecX) + 1):end);
        else
            load_system(Model);
            for j = 1:length(vecX)
                    set_param([DepotSet(j).SimEventsPath, '/Resource_Pool'], 'Quantity', num2str(ceil(vecX(j))));
            end
            
            warning('off','all');
            
            %se_randomizeseeds(Model, 'Mode', 'All', 'Verbose', 'off');
            simOut = sim(Model,'StopTime', '500', 'SaveOutput', 'on');

            CustomerArrivals = [];
            for i = 1:length(CustomerSet)
                CustomerArrivals = [CustomerArrivals; simOut.get(CustomerSet(i).Node_Name).time, simOut.get(CustomerSet(i).Node_Name).signals.values];
            end


            Customer_CycleTime = [CustomerArrivals(:,1) - CustomerArrivals(:,4)];
            obj(1) = ceil(vecX)*ResourceCost;
            obj(2) = sum(Customer_CycleTime>objThreshold(2))/length(Customer_CycleTime);

            OBJVAL(end+1,:) = [ceil(vecX) obj(1) obj(2)];
        end
end

function poolobj = UseParallel(Model)
% TO DO: Set up each worker in its own working folder. this may prevent the
% conflict for the simulation file. 9/11/15 when working from the network
% drive on multiple computers, each tries to modify the simulation file and
% gets and error when it has been changed on disk.

    if isempty(gcp) ==1
        poolobj = parpool;
    end
    load_system(Model);
    spmd
        % Load the model on the worker
        warning('off','all');
        load_system(Model);
    end

end