function [ solution_space ] = Distribution_Pareto(Model, CustomerSet, DepotSet, TransportationSet, ResourceSet, ResourceCost)
%DISTRIBUTION_RS1 Summary of this function goes here
%   Detailed explanation goes here

CTtarget = 24;
UTILtarget = .975;
%ResourceCost= [1000, 1000, 1000]';
objThreshold = [0, CTtarget, 0];

try
    % 1) Load model and initialize the pool.
    poolobj = parpool;
    load_system(Model);
    
    spmd
        currDir = pwd;
        addpath(currDir);
        tmpDir = tempname;
        mkdir(tmpDir);
        cd(tmpDir);
        warning('off','all');
        % Load the model on the worker
        load_system(Model);
    end
    
%     [m,n] = size(ResourceSet);
%     row_totals = sum(ResourceSet,2);
%     [sorted, row_ids] = sort(row_totals, 'descend');
%     ResourceSet = [ResourceSet(row_ids,:), row_totals(row_ids)];
%     ResourceSet = ResourceSet(ResourceSet(:,n+1)<=40 & ResourceSet(:,n+1)>=28,1:n);
    length(ResourceSet)

    solution_space = zeros(length(ResourceSet(:,1)),2,3);
    parfor i = 1:length(ResourceSet(:,1))
        i
        for j = 1:2 %PolicySpace
           obj = multiCriteria(Model, DepotSet, CustomerSet, TransportationSet, ResourceSet(i,:), ResourceCost, j, objThreshold);
           solution_space(i, j,:) = [obj(1), obj(2), obj(3)];
        end
    end

    % 5) Switch all of the workers back to their original folder.
    %TO DO: Come back and make the 'remove temp directories' work.
        save ParetoCheckpoint.mat;
        spmd
            cd(currDir);
            %rmdir(tmpDir,'s');
            %rmpath(currDir);
            close_system(Model, 0);
        end

        close_system(Model, 0);
        delete(gcp('nocreate'));
catch err
 % 5) Switch all of the workers back to their original folder.
 
    save ParetoCheckpoint.mat;
    spmd
        cd(currDir);
        %rmdir(tmpDir,'s');
        %rmpath(currDir);
        close_system(Model, 0);
    end
    
    close_system(Model, 0);
    delete(gcp('nocreate'));
    rethrow(err);
end

end


function obj = multiCriteria(Model, DepotSet, CustomerSet, TransportationSet, ResourceSet, ResourceCost, ResourceAllocationPolicy, objThreshold)
% Objection function to run as part of the genetic algorithm

        load_system(Model);
        for j = 1:length(DepotSet)
                set_param(strcat(DepotSet(j).SimEventsPath, '/Resource_Pool'), 'Quantity', num2str(ResourceSet(j)));
                set_param(strcat(DepotSet(j).SimEventsPath, '/Policy'), 'Value', num2str(ResourceAllocationPolicy));
        end

        simOut = sim(Model,'StopTime', '500', 'SaveOutput', 'on');
        
        CustomerArrivals = [];
        for i = 1:length(CustomerSet)
            CustomerArrivals = [CustomerArrivals; simOut.get(CustomerSet(i).Node_Name).time, simOut.get(CustomerSet(i).Node_Name).signals.values];
        end
        
        TravelDistance = 0;
        for i = 1:length(TransportationSet)
            TravelDistance = TravelDistance + simOut.get(strcat(TransportationSet(i).Node_Name,'_Status')).signals.values(end,3)...
                *TransportationSet(i).TravelDistance;
        end


        Customer_CycleTime = [CustomerArrivals(:,1) - CustomerArrivals(:,4)];
        obj = zeros(3,1);
        
        obj(1) = ResourceSet*ResourceCost;
        obj(2) = 1-sum(Customer_CycleTime>objThreshold(2))/length(Customer_CycleTime);
        obj(3) = TravelDistance;

end
