function finalResult = Jackson_opt()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    opts = gaoptimset('PlotFcns', {@gaplotbestf; @gaplotbestindiv},'Generations', 25, 'StallGenLimit', 10, 'UseParallel', 'always');
    lb = [1 1 1 1 1 1 1];
    ub = [25 25 25 25 25 25 25];
    
    IntCon = [1 2 3 4 5 6 7];
    tic
    
    [finalResult, ~, exitflag] = ga(@productionCost,7,[],[],[],[],lb,ub,[],IntCon,opts);
    
    toc
end

function obj = productionCost(vecX)
% Objection function to run as part of the genetic algorithm

    %Taking values from the genetic algorithm and assigning them to values
    receiving = vecX(1);
    process1 = vecX(2);
    process2 = vecX(3);
    process3 = vecX(4);
    process4 = vecX(5);
    process5 = vecX(6);
    final = vecX(7);
    
    %Setting parameters on model with value from genetic algorithm
    set_param('Open_Jackson_Network/Receiving','NumberOfServers', num2str(receiving));
    set_param('Open_Jackson_Network/Process1','NumberOfServers', num2str(process1));
    set_param('Open_Jackson_Network/Process2','NumberOfServers', num2str(process2));
    set_param('Open_Jackson_Network/Process3','NumberOfServers', num2str(process3));
    set_param('Open_Jackson_Network/Process4','NumberOfServers', num2str(process4));
    set_param('Open_Jackson_Network/Process5','NumberOfServers', num2str(process5));
    set_param('Open_Jackson_Network/Final','NumberOfServers', num2str(final));
    
    %Simulation and capturing the output
    simOut = sim('Open_Jackson_Network', 'SaveOutput', 'on');
    
    Total_Metric = 0;
    Total_Metric = Total_Metric + simOut.get('Final_Metric').signals.values(end);
    Total_Metric = Total_Metric + simOut.get('Q1_Metric').signals.values(end);
    Total_Metric = Total_Metric + simOut.get('Q2_Metric').signals.values(end);
    Total_Metric = Total_Metric + simOut.get('Q3_Metric').signals.values(end);
    Total_Metric = Total_Metric + simOut.get('Q4_Metric').signals.values(end);
    Total_Metric = Total_Metric + simOut.get('Q5_Metric').signals.values(end);
    Total_Metric = Total_Metric + simOut.get('Receiving_Metric').signals.values(end);
    
    capital_cost = [100 200 200 500 200 200 100]*vecX';
    
    obj = Total_Metric*100 + capital_cost;
end