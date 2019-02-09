function tour = SerpentineSkipping(stops,SD)
            
    aisles = SD.aisles;
    cross_aisle_set = SD.cross_aisle_set;
    NodeSetList = SD.PickerNetwork.NodeSetList;
    stops = sortrows(stops, 5);
    a = 0;

    tour = [NodeSetList(NodeSetList(:,3)==0,:), 0]; % P/D-point

    for aisle_count=1:aisles
        if ismember(aisle_count,stops(:,5))
            a = a + 1;
            if mod(a,2) == 0
                tour = cat(1, tour, [cross_aisle_set(2*aisle_count),NodeSetList(cross_aisle_set(2*aisle_count),2),NodeSetList(cross_aisle_set(2*aisle_count),3),NodeSetList(cross_aisle_set(2*aisle_count),4),aisle_count]);
                aisle_stops = sortrows(stops(stops(:,5)==aisle_count,:),-3);
                tour = cat(1, tour, aisle_stops);
                tour = cat(1, tour, [cross_aisle_set(2*aisle_count-1),NodeSetList(cross_aisle_set(2*aisle_count-1),2),NodeSetList(cross_aisle_set(2*aisle_count-1),3),NodeSetList(cross_aisle_set(2*aisle_count-1),4),aisle_count]);
            else
                tour = cat(1, tour, [cross_aisle_set(2*aisle_count-1),NodeSetList(cross_aisle_set(2*aisle_count-1),2),NodeSetList(cross_aisle_set(2*aisle_count-1),3),NodeSetList(cross_aisle_set(2*aisle_count-1),4),aisle_count]);
                aisle_stops = sortrows(stops(stops(:,5)==aisle_count,:),3);
                tour = cat(1, tour, aisle_stops);
                tour = cat(1, tour, [cross_aisle_set(2*aisle_count),NodeSetList(cross_aisle_set(2*aisle_count),2),NodeSetList(cross_aisle_set(2*aisle_count),3),NodeSetList(cross_aisle_set(2*aisle_count),4),aisle_count]);
            end
        end
    end

    tour = cat(1, tour, [NodeSetList(NodeSetList(:,3)==0,:), 0]); % P/D-point
    
end