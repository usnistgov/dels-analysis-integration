%% Screening equipment heights an number of SKUs
% Assume: ladder structure, SKU assignment by FoA, allocation 1 SKU per slot, 
% slotting most frequent<->most desirable, routing by serpentine and skipping



%% Initialize screening for equipment

sd(50) = Storage_Department;

maxHeight = sd.maxHeight;

mn = zeros(maxHeight*10,1);
c = 1;

tic
%% Screening
for e = 1:maxHeight

    for sku_percent = 0.1:0.1:1;
        
        sd(c).ID = c;
        sd(c).sku_percent = sku_percent;
        
        sd(c).StorageEquipment = Storage_Equipment;
        sd(c).StorageEquipment.ID = e;
        sd(c).StorageEquipment.storage_height = e;
        
        sd(c).PickEquipment = Pick_Equipment;
        sd(c).PickEquipment.ID = e;
        sd(c).PickEquipment.reachable_height = e;
        
        
        %% Dimensioning
        sd(c).Dimensioning
        
        sd(c).GeneratePickerNetwork
        sd(c).GenerateStorageNetwork


        %% Calculate distances and times between storage locations
        sd(c).Distances
        
        
        %% Simulation to determine mean time per stop
        [mn_time_per_stop,~] = sd(c).getMeanTimePerStop(50);
        
        
        %% Get footprint
        [~] = sd(c).getFootprint;
        
        %% Create array for plot
        mn(c) = mn_time_per_stop;

        c = c + 1;
        
    end
end


%% Plot 
match = findobj(sd, '-function', 'mn_time_per_stop', @(x)(x<20), '-and', '-function', 'footprint', @(y)(y<2e04));
color = repmat([0,0,1],50,1);
for i = 1:length(match)
    color(match(i).ID,:) = [0,1,0];
end
figure
scatter3(repmat((0.1:0.1:1)',maxHeight,1),reshape(repmat(1:maxHeight,10,1),10*maxHeight,1),mn,ones(maxHeight*10,1)*36,color,'filled')
title('Screening Forward Structure')
xlabel('SKU percentage')
ylabel('Height')
zlabel('Mean travel time per stop [s]')


% figure
% plot3d_errorbars(mn(:,2),mn(:,1),mn(:,3),sqrt(v(:,3)))
% xlabel('SKU percentage')
% ylabel('Height')
% zlabel('Mean travel time per stop')

toc