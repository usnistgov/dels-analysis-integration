%% Screening shape factor
% Assume: ladder structure, SKU assignment by FoA, allocation 1 SKU per slot,
% slotting most frequent<->most desirable, routing by serpentine and skipping

%% Initialize screening for shape factor

% Find storage department with minimum time per stop
[minT, idx] = min(mn);
sd_minT = sd(idx).Copy;

sd_sf = Storage_Department.empty(60,0);
aisle_count = zeros(60,1);
mn = zeros(60,1);
e = zeros(60,1);
s = 1;
a = 1;

tic
%% Screening
for sf = 0.2:0.2:12; %shape factor;
    
    sd_sf(s) = sd_minT.Copy;
    sd_sf(s).shape_factor = sf;
    
    %% Dimensioning
    sd_sf(s).Dimensioning
    sd_sf(s).GeneratePickerNetwork
    sd_sf(s).GenerateStorageNetwork
    %SD.PlotNetworks

    %% Distances and times between storage locations
    sd_sf(s).Distances
    
    %% Simulation to determine mean time per stop
    [mn_time_per_stop,variance] = sd_sf(s).getMeanTimePerStop(5000);
    
    %% Create arrays for plot
    mn(s) = mn_time_per_stop;
    e(s) = sqrt(variance);
    aisle_count(s) = sd_sf(s).aisles;
    
    if (s>1 && aisle_count(s-1)>aisle_count(s))
        aisles(a,1)=s;
        aisles(a,2)=mn(s);
        aisles(a,3)=sf;
        a=a+1;
    end
    
    s = s +1;

end

%% Plot
figure
errorbar(0.2:0.2:12,mn,e)
title('Screening Shape Factor')
xlabel('Shape Factor')
ylabel('Mean travel time per stop [s]')

hold on
scatter(aisles(:,3),aisles(:,2))
hold off

toc

