function [delta_ij, D, time_ij, T]=Distances(SD)
% Calculate distances and times between storage locations
    PickerNodeSetList = SD.PickerNetwork.NodeSetList;
    StorageNodeSetList = SD.StorageNetwork.NodeSetList;
    aisle_module_width = SD.aisle_module_width;

    A = list2adj([SD.PickerNetwork.EdgeSetList(:, 2:end); SD.StorageNetwork.EdgeSetList(:, 2:end)]);

    % Distances
    UnitedNodeSetList = cat(1,PickerNodeSetList,StorageNodeSetList);
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
    PD_aisle = ceil(SD.aisles / 2);
    PD = PickerNodeSetList(:,2) == 0.5*aisle_module_width+(PD_aisle-1)*aisle_module_width & PickerNodeSetList(:,3) == 0;
    D = delta_ij(PickerNodeSetList(PD), length(PickerNodeSetList)+1:N);

    % Travel times
    T = D./SD.PickEquipment.horizontal_velocity;
    time_ij = delta_ij./SD.PickEquipment.horizontal_velocity;
    
end