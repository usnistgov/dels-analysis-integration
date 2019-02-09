function [finalResult, FVAL, exitflag] = SymboticOrderGenerator( DataPoints )
%SYMBOTICORDERGENERATOR Summary of this function goes here
%   Detailed explanation goes here
    
    N = length(DataPoints);
    warning('off','all');
    opts = gaoptimset('PlotFcns', {@gaplotbestf; @gaplotbestindiv},'Generations', 200, 'StallGenLimit', 10, 'UseParallel', 'always');
    lb = zeros(N);
    ub = ones(N);
    
    IntCon = [1:N];
    tic
    
    [finalResult, FVAL, exitflag] = ga(@(X)productionCost(X, DataPoints),N,[],[],[],[],lb,ub,[],IntCon,opts);
    
    X = (finalResult ==1)';
    finalResult = DataPoints(X,:);
    toc
    warning('on','all');
end

function obj = productionCost(vecX, Data)
% Objection function to run as part of the genetic algorithm

targetmean = [21 58 18];
targetstdev = [16.5 35.4 30.8];

X = (vecX ==1);
Data = Data(X,:);

avg = mean(Data);
    
stdev = std(Data);

ordersize = mean(sum(Data,2));

obj = 5*sum(((avg - targetmean)).^2) + sum((stdev - targetstdev).^2) + (ordersize -100)^2;% + ((1000-sum(vecX))/100)^2;

end