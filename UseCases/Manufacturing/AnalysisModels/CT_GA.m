function [finalResult, FVAL, exitflag, Population] =  CT_GA( Model, ProcessSet, Parallel, InitialPopulation)



try
    try
        d1 = MetricDirector;
        d1.ConstructMetric(ProcessSet, 'Utilization');
    end
    
    N = length(ProcessSet);
    CTtarget = 35;
    UTILtarget = 0.975;
    %ServerCost =100+ (1000-100).*rand(1,N)';
    %ServerCost = [520.6654  798.8752  626.8844  349.8374  542.5348  195.7873  554.0474  957.1888]';
    ServerCost= [888.0578  867.4894  389.1599  443.7355  312.6181  942.0706  248.7804 ...
             664.8621  226.1090  240.8440  876.0569  277.7495  964.7055  427.8105 ...
             104.0892  870.1119  863.0349  586.6399  528.1984  176.4817  441.6811]';
    
    if strcmp(Parallel, 'true')==1
        UseParallel;
    end
    
    if strcmp(InitialPopulation , 'true') ==1
        InitialPopulation = [];
        for j = 1:N
            InitialPopulation(end+1) = ProcessSet(j).ServerCount;
        end
        lb = max(InitialPopulation - 5,1);
        ub = InitialPopulation +5;
    else
        InitialPopulation = [];
        lb = ones(1,N);
        ub = 15*ones(1,N);
    end
    
    

    warning('off','all');
    opts = gaoptimset('PlotFcns', {@gaplotbestf; @gaplotbestindiv},'Generations', 50, 'StallGenLimit', 10, 'UseParallel', 'always', ...
        'PopulationSize', 20, 'InitialPopulation', InitialPopulation);
    
    IntCon = [1:N];
    tic
    
    [finalResult, FVAL, exitflag, Output, Population] = ga(@(X)productionCost(X, Model, ProcessSet, ServerCost, CTtarget, UTILtarget),N,[],[],[],[], lb,ub,[],IntCon,opts);
    
    for j = 1:length(finalResult)
        ProcessSet(j).ServerCount = finalResult(j);
        ProcessSet(j).setServerCount;
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

function obj = productionCost(vecX, Model, ProcessSet, ServerCost, CTtarget, UTILtarget)
% Objection function to run as part of the genetic algorithm

        for j = 1:length(vecX)
                ProcessSet(j).ServerCount = vecX(j);
                ProcessSet(j).setServerCount;
        end
        

        simOut = sim(Model,'StopTime', 'inf', 'SaveOutput', 'on');
        
        util = [];
        for i = 1:length(vecX)
            util(end+1) = simOut.get(strcat('Utilization_', ProcessSet(i).Node_Name)).signals.values(end);
        end
        
        %obj = vecX*ServerCost + 10*sum(simOut.get('ProcessTime').signals.values>CTtarget)+ 1000000*sum(util>UTILtarget);
        obj = vecX*ServerCost + 50*sum(simOut.get('ProcessTime').signals.values(100:end)>CTtarget);%+ 1000000*sum(util>UTILtarget);
end

function UseParallel
    load_system('ProcessModel')
    matlabpool('open')
    spmd
        load_system('ProcessModel')
        se_randomizeseeds('ProcessModel', 'Mode', 'All', 'Verbose', 'off');
    end
end