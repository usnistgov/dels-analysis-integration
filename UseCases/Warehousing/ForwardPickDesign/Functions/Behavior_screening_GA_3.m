%% Screening capacity, speed, and fleet mix
% Assume: ladder structure, SKU assignment by FoA, allocation 1 SKU per slot,
% slotting most frequent<->most desirable, routing by serpentine and skipping

%% Initialize screening for behaviour
%Find storage department with minimum time per stop
[~, idx] = min(aisles(:,2));
sd_minT = sd_sf(aisles(idx,1)).Copy;


%% Genetic Algorithm
tic

[finalResult, FVAL, exitflag, Population] =  MultiGA_Distribution(sd_minT);

toc


%% Build storage departments with results from GA

sd_bh_GA(length(FVAL)) = Storage_Department;

for b = 1:length(FVAL)
    
    sd_bh_GA(b) = sd_minT.Copy;
    sd_bh_GA(b).fleet_size = finalResult(b,1);
    sd_bh_GA(b).PickEquipment.capacity = finalResult(b,2);
    sd_bh_GA(b).PickEquipment.vertical_velocity = finalResult(b,3);
    sd_bh_GA(b).PickEquipment.horizontal_velocity = finalResult(b,4);

    sd_bh_GA(b).time_ij = sd_bh_GA(b).delta_ij./sd_bh_GA(b).PickEquipment.horizontal_velocity;
    sd_bh_GA(b).T = sd_bh_GA(b).D./sd_bh_GA(b).PickEquipment.horizontal_velocity;
    
    sd_bh_GA(b).time100 = FVAL(b,3);
    sd_bh_GA(b).time_per_tour = FVAL(b,4);
    sd_bh_GA(b).var_cost = FVAL(b,1);
    sd_bh_GA(b).cap_cost = FVAL(b,2);
    
end


%% Plot duration vs. capital cost and variable cost for each fleet mix
figure
scatter3(FVAL(:,1),FVAL(:,2),FVAL(:,3),ones(length(FVAL(:,3)),1)*36, FVAL(:,3),'filled')
title('Screening Forward Behavior (capacity, speed, fleet size)')
xlabel('Variable Cost')
ylabel('Capital Cost')
zlabel('Time required to clear out 100 orders [s]')
colormap(jet);
colorbar;

figure
scatter3(FVAL(:,1),FVAL(:,2),FVAL(:,4),ones(length(FVAL(:,4)),1)*36, FVAL(:,4),'filled')
title('Screening Forward Behavior (capacity, speed, fleet size)')
xlabel('Variable Cost')
ylabel('Capital Cost')
zlabel('Avg time per tour [s]')
colormap(jet);
colorbar;