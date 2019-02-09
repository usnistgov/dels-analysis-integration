function [SD] = Dimensioning(SD)

    bay_width = SD.StorageEquipment.bay_width; 
    bay_length = SD.StorageEquipment.bay_length;
    bays = SD.bays;
    cross_aisle_width = SD.cross_aisle_width;
    sf = SD.shape_factor;
    sHeight = SD.StorageEquipment.storage_height;
    pHeight = SD.PickEquipment.reachable_height;
    aisle_width = SD.PickEquipment.req_aisle_width; 

    if sHeight > pHeight
        error('Storage height higher than reachable height of pick equipment.')
    end

    aisle_module_width = 2 * bay_width + aisle_width; % aisle plus shelves on both sides

    aisles = 1;
    bays_per_aisle = bays;
    aisle_length = (bays_per_aisle / sHeight / 2) * bay_length;        
    forward_length = aisle_length + 2 * cross_aisle_width;
    forward_width = aisles * aisle_module_width;

    while forward_length > sf * forward_width
        aisles = aisles + 1;
        bays_per_aisle = ceil(bays / aisles);
        aisle_length = ceil(bays_per_aisle / sHeight / 2) * bay_length;        
        forward_length = aisle_length + 2 * cross_aisle_width;
        forward_width = aisles * aisle_module_width;  
    end

    final_bay_count = bays_per_aisle * aisles; 

    SD.aisles = aisles;
    SD.aisle_module_width = aisle_module_width;
    SD.aisle_length = aisle_length * ones(aisles, 1);
    SD.aisle_width = aisle_width;
    SD.bays = final_bay_count;
    SD.cross_aisle_width = cross_aisle_width;
    SD.k = ceil(aisle_length/bay_width);
    SD.orientation = 0;
    SD.offset = [0,0];

end

