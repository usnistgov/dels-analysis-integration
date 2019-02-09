function stops=OrderBatching(avg_order_lines,T,SD)

    %Generate Orders (sample SKUs by frequency of access)
    %Combine orders 1..Equipment_Capacity
    
    batch_size = SD.PickEquipment.capacity;
    NodeSetList = SD.StorageNetwork.NodeSetList;
    bay_width = SD.StorageEquipment.bay_width;
    aisle_module_width = SD.aisle_module_width;
    
    for b = 1:batch_size
        if b == 1
            order = randsample(length(NodeSetList(:,1)), avg_order_lines);%, true, 1./T);
        else
            order = [order, randsample(length(NodeSetList(:,1)), avg_order_lines)];%, true, 1./T)]; 
        end
    end

    stops = NodeSetList(unique(order),:);

    for aisle_count=0:SD.aisles-1
        logAisle1 = stops(:,2)==0.5*bay_width+aisle_count*aisle_module_width;
        logAisle2 = stops(:,2)==1.5*bay_width+SD.aisle_width+aisle_count*aisle_module_width;
        stops(logAisle1,5) = aisle_count+1;
        stops(logAisle2,5) = aisle_count+1;
    end

end