function [healthIndex] = machineHealthIndex(machineInstanceID, currentHealthIndex, maxHealthIndex, runTime, maxRunTime, partCount, maxPartCount)
%MACHINEHEALTHINDEX outputs new health index for machine
% allows for run-based and time-based failures
% Complete failure is when currentHealthIndex exceeds maxHealthIndex

healthIndex = currentHealthIndex + runTime / maxRunTime;

end

