function tour = NearestNeighbor(stops,SD)
    
    time_ij = SD.time_ij;
    cross_aisle_set = SD.cross_aisle_set;
    PNodeSetList = SD.PickerNetwork.NodeSetList;
    
    time_ij = time_ij(length(cross_aisle_set)+2:end,length(cross_aisle_set)+2:end);
    
    logstops = stops(:,1) - length(PNodeSetList);

    C = time_ij([1;logstops],[1;logstops]);
    
    PDstops = [PNodeSetList(PNodeSetList(:,3)==0,1);logstops];
    
    [M,idx] = min(stops(:,2));
    [loc,TC,bestvtx] = tspnneighbor(C,idx);
    
    tour = PDstops(loc) + length(PNodeSetList);

    tour(1) = PNodeSetList(PNodeSetList(:,3)==0,1); % P/D-point
    tour(end) = PNodeSetList(PNodeSetList(:,3)==0,1); % P/D-point
    
end