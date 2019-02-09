function [finalResult, FVAL, exitflag] = SymboticOrderGenerator_partI()
%SYMBOTICORDERGENERATOR Summary of this function goes here
%   Detailed explanation goes here
    
    warning('off','all');
    opts = gaoptimset('PlotFcns', {@gaplotbestf; @gaplotbestindiv},'Generations', 25, 'StallGenLimit', 10, 'UseParallel', 'always');
    lb = [0 10 25];
    ub = [10 25 97];
    
    IntCon = [1:3];
    tic
    
    [finalResult, FVAL, exitflag] = ga(@productionCost,3,[],[],[],[],lb,ub,[],IntCon,opts);
    
    toc
    warning('on','all');
end

function obj = productionCost(vecX)
% Objection function to run as part of the genetic algorithm

targetmean = [21 58 18];
targetstdev = [16.5 35.4 30.8];

set_param('Untitled1/Zone1', 'minTri', num2str(vecX(1)));
set_param('Untitled1/Zone1', 'modeTri', num2str(vecX(2)));
set_param('Untitled1/Zone1', 'maxTri', num2str(vecX(3)));

simOut = sim('Untitled1', 'SaveOutput', 'on');

avg = mean(simOut.get('Generated').signals.values(:,1));
stdev = std(simOut.get('Generated').signals.values(:,1));

obj = 10*(avg - targetmean(1))^2 + 10*(stdev - targetstdev(1))^2;

end

