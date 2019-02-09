function [finalResult, FVAL, exitflag, Population] =  MultiGA_Distribution(Model)

try
    
    N = 4;

    %UseParallel(Model);

    %InitialPopulation = 4*ones(1,N);
    lb = [1,1,55/60,200/60];
    ub = [20,10,70/60,600/60];
    
    warning('off','all');
    opts = gaoptimset('PlotFcns', {@gaplotpareto},'Generations', 10, 'StallGenLimit', 4,'UseParallel', 'always', 'PopulationSize', 200);
    

    [finalResult, FVAL, exitflag, Output, Population] = gamultiobj(@(X)TH_SL(X, Model),N,[],[],[],[], lb,ub,opts);
    
    finalResult = [round(finalResult(:,[1 2])),finalResult(:,[3 4])];
    fprintf('Solution', finalResult);
    fprintf('Solution_Value', FVAL);
    
    warning('on','all');
    clear distributionCost;
    
catch err
    warning('on', 'all');
    clear distributionCost;
    rethrow(err)
end

end

function obj = TH_SL(vecX, Model)
% Objection function to run as part of the genetic algorithm
persistent OBJVAL;
obj = zeros(4,1);

        if isempty(OBJVAL)
            OBJVAL = zeros(1, length(vecX) + 4); % + 4 is number of response values
        end

        match = ismember(OBJVAL(:,1:length(vecX)), ceil(vecX), 'rows');
        
        if any(match)
            obj = OBJVAL(match, (length(vecX) + 1):end);
        else
            
            % Run simulation here:

            Model.fleet_size = vecX(1);
            Model.fleet_size = round(Model.fleet_size);
            Model.PickEquipment.capacity = vecX(2);
            Model.PickEquipment.capacity = round(Model.PickEquipment.capacity);
            Model.PickEquipment.vertical_velocity = vecX(3);
            Model.PickEquipment.horizontal_velocity = vecX(4);
            
            % Adjust travel times for new velocities
            Model.time_ij = Model.delta_ij./Model.PickEquipment.horizontal_velocity;
            Model.T = Model.D./Model.PickEquipment.horizontal_velocity;
            
            % Evaluate time it takes to clear out 100 orders and average time per tour
            Model.getTime100Orders;

            % Calculate costs
            Model.getVariableCost;
            Model.getCapitalCost;
            
            % Output responses to obj here:
            obj(1) = Model.var_cost;
            obj(2) = Model.cap_cost;
            obj(3) = Model.time100;
            obj(4) = Model.time_per_tour;

            OBJVAL(end+1,:) = [[round(vecX(:,[1 2])),vecX(:,[3 4])] obj(1) obj(2) obj(3) obj(4)];
        end
end

function poolobj = UseParallel(Model)

    if isempty(gcp) ==1
        poolobj = parpool;
    end

    spmd
        warning('off','all');
        load_system(Model)
    end

end