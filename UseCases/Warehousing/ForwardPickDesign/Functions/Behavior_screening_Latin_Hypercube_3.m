%% Screening capacity, speed, and fleet mix
% Assume: ladder structure, SKU assignment by FoA, allocation 1 SKU per slot,
% slotting most frequent<->most desirable, routing by serpentine and skipping

%% Initialize screening for behaviour
% Find storage department with minimum time per stop
[~, idx] = min(aisles(:,2));
sd_minT = sd_sf(aisles(idx,1)).Copy;

p = 100; % number of points

sd_bh(p) = Storage_Department;
time100_arr = zeros(p,1);
time_per_tour_arr = zeros(p,1);
var_cost = zeros(p,1);
cap_cost = zeros(p,1);

%% Generate fleet mixes to be investigated 
%(homogeneous fleets, latin hypercube fleet size, capacity, vertical and horizontal speed)

N = 4; % number of variables
lb = [1,1,55/60,200/60]; % lower bounds for variables
ub = [20,10,70/60,600/60]; % upper bounds for variables

X = lhsdesign(p,N);
mix = bsxfun(@plus,lb,bsxfun(@times,X,(ub-lb)));
mix(:,[1,2]) = round(mix(:,[1,2]));

tic 
%% Screening
for b = 1:p % points in latin hypercube design
    
    sd_bh(b) = sd_minT.Copy;
    sd_bh(b).fleet_size = mix(b,1);
    sd_bh(b).PickEquipment.capacity = mix(b,2);
    sd_bh(b).PickEquipment.vertical_velocity = mix(b,3);
    sd_bh(b).PickEquipment.horizontal_velocity = mix(b,4);
    
    % Adjust travel times for new velocities
    sd_bh(b).time_ij = sd_bh(b).delta_ij./sd_bh(b).PickEquipment.horizontal_velocity;
    sd_bh(b).T = sd_bh(b).D./sd_bh(b).PickEquipment.horizontal_velocity;
    
    %% Evaluate time it takes to clear out 100 orders and average time per tour
    [time100, time_per_tour] = sd_bh(b).getTime100Orders;

    %% Calculate costs
    varCost = sd_bh(b).getVariableCost;
    capCost = sd_bh(b).getCapitalCost;
    
    %% Create arrays for plots
    time100_arr(b) = time100;
    time_per_tour_arr(b) = time_per_tour;
    var_cost(b) = varCost;
    cap_cost(b) = capCost;
    
end

toc

%% Find Pareto front
X = [time100_arr,time_per_tour_arr,var_cost,cap_cost];
front = paretoGroup(X);
color = repmat([0,0,1],p,1);
for i = 1:length(front)
    if front(i) == 1
        color(i,:) = [0,1,0];
    end
end

%% Plot duration vs. capital cost and variable cost for each fleet mixfigure
figure
scatter3(var_cost,cap_cost,time100_arr,ones(p,1)*36,color,'filled')
title('Screening Forward Behavior (capacity, speed, fleet size)')
xlabel('Variable Cost')
ylabel('Capital Cost')
zlabel('Time required to clear out 100 orders [s]')

figure
scatter3(var_cost,cap_cost,time_per_tour_arr,ones(p,1)*36,color,'filled')
title('Screening Forward Behavior (capacity, speed, fleet size)')
xlabel('Variable Cost')
ylabel('Capital Cost')
zlabel('Avg time per tour [s]')