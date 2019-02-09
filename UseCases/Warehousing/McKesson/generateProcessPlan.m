function [ ProcessPlan, NextProcess ] = generateProcessPlan(maxLengthProcessPlan, P_lengthProcessPlan, P_processVisit )
%GENERATEPROCESSPLAN Summary of this function goes here
%   All of the process plans must be the same length, and the last element
%   of the process plan has to be one greater than the number of
%   workstations that can be visit. This is because the routing mechanism
%   will always have 1 extra port to route stuff out of the system.

%T = gendist(P,N,M)
T = gendist(P_processVisit, gendist(P_lengthProcessPlan,1,1), 1);

%Initialize the Process Plan to it's max length plus 1 with all elements equal to
%the max number of processes plus 1 to guarantee that the last element
%routes to the sink
ProcessPlan = (length(P_processVisit)+1)*ones((maxLengthProcessPlan+1),1);

%Map the generated process plan into the final process plan vector.
ProcessPlan(1:length(T), 1) = T;

%Select
NextProcess = T(1);

end

