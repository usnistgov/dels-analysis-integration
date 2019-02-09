function stops=OrderBatching_v01(avg_order_lines,T,SD)

    %Generate Orders (sample SKUs by frequency of access)
    %Combine orders 1..Equipment_Capacity
    
    batch_size = SD.PickEquipment.capacity;
    NodeSetList = SD.StorageNetwork.NodeSetList;
    movement_nodes = length(SD.PickerNetwork.NodeSetList);
    bay_width = SD.StorageEquipment.bay_width;
    aisle_module_width = SD.aisle_module_width;
    
    logstops = datasample(NodeSetList(:,1),batch_size*avg_order_lines,'Replace',false,'Weights',1./T) - movement_nodes;
    stops = NodeSetList(logstops,:);
    
    for aisle_count=0:SD.aisles-1
        logAisle1 = stops(:,2)==0.5*bay_width+aisle_count*aisle_module_width;
        logAisle2 = stops(:,2)==1.5*bay_width+SD.aisle_width+aisle_count*aisle_module_width;
        stops(logAisle1,5) = aisle_count+1;
        stops(logAisle2,5) = aisle_count+1;
    end

end