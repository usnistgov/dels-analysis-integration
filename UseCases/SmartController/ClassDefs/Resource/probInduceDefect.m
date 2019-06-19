function [outputCondition] = probInduceDefect(inputCondition, machineHealth,productInstanceID)
%PROBINDUCEDEFECT Summary of this function goes here
%   Detailed explanation goes here

defectIndicator = rand(1)*10; %machine health is from 0-10
if machineHealth > defectIndicator
    outputCondition = inputCondition - 0.05*machineHealth;
else
    outputCondition = inputCondition;
end

end

