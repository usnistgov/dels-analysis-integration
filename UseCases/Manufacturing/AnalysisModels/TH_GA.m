function [finalResult, FVAL, exitflag] =  TH_GA( Model, ProcessSet )

    try
        d1 = MetricDirector;
        d1.ConstructMetric(ProcessSet, 'Utilization');
    end

    N = length(ProcessSet);
    warning('off','all');
    opts = gaoptimset('PlotFcns', {@gaplotbestf; @gaplotbestindiv},'Generations', 100, 'StallGenLimit', 10, 'UseParallel', 'always', ...
        'PopulationSize', 20, 'EliteCount', 4);
    lb = ones(1,N);
    ub = 10*ones(1,N);
    
    IntCon = [1:N];
    tic
    
    [finalResult, FVAL, exitflag] = ga(@(X)productionCost(X, Model, ProcessSet),N,[],[],[],[], lb,ub,[],IntCon,opts);
    
    for j = 1:length(finalResult)
        ProcessSet(j).ServerCount = finalResult(j);
        ProcessSet(j).setServerCount;
    end
    
    toc
    warning('on','all');


end

function obj = productionCost(vecX, Model, ProcessSet)
% Objection function to run as part of the genetic algorithm
        for j = 1:length(vecX)
                ProcessSet(j).ServerCount = vecX(j);
                ProcessSet(j).setServerCount;
        end
        
        
        %se_randomizeseeds('ProcessModel', 'Mode', 'All', 'Verbose', 'off');
        simOut = sim(Model, 'SaveOutput', 'on');
        util = [];
        
        for i = 1:length(vecX)
            util(end+1) = simOut.get(strcat('Utilization_Process_', num2str(i))).signals.values(end);
        end
        
        obj = 1000*sum(util>0.99)+10*sum(vecX);
end