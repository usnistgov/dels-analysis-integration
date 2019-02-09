function [delta_ij, D, time_ij, T, I]=Distances_v01(SD)
% Calculate distances and times between storage locations
    PickerNodeSetList = SD.PickerNetwork.NodeSetList;
    StorageNodeSetList = SD.StorageNetwork.NodeSetList;
    aisle_module_width = SD.aisle_module_width;
    
    cross_aisle_set = SD.cross_aisle_set;
    
    A = list2adj([SD.PickerNetwork.EdgeSetList(:, 2:end); SD.StorageNetwork.EdgeSetList(:, 2:end)]);
    
    PD_aisle = ceil(SD.aisles / 2);
    PD = PickerNodeSetList(PickerNodeSetList(:,2) == 0.5*aisle_module_width+(PD_aisle-1)*aisle_module_width & PickerNodeSetList(:,3) == 0);
    
    % Distances
    UnitedNodeSetList = cat(1,PickerNodeSetList([PD ; cross_aisle_set],:),StorageNodeSetList);
    I = UnitedNodeSetList(:,1);
    N = length(UnitedNodeSetList);
    to = UnitedNodeSetList(:,1);
    if N > 200
        delta_ij = zeros(N);
            parfor i= 1:N
                delta_ij(i, :) = dijk(A, UnitedNodeSetList(i,1), to);
            end
    else
        delta_ij = dijk(A, to, to);
    end

    D = delta_ij(1, length(cross_aisle_set)+2:N);

    % Travel times
    T = D./SD.PickEquipment.horizontal_velocity;
    time_ij = delta_ij./SD.PickEquipment.horizontal_velocity;
    
end