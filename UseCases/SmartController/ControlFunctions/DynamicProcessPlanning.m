function [nextProcessStep] = DynamicProcessPlanning(inTask)
%DYNAMICPROCESSPLANNING Summary of this function goes here
%   Detailed explanation goes here

%CurrentProcessStep is the "marking" of the process plan
inTask.processPlan.currentProcessStep = inTask.processPlan.currentProcessStep+1;
nextProcessStep = inTask.processPlan.processSteps{inTask.processPlan.currentProcessStep};
end

