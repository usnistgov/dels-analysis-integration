classdef Storage_Department < handle
    %DEPARTMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    ID
    aisles
    aisle_width
    aisle_module_width % aisle width plus shelves on both sides
    aisle_length
    cross_aisle_width = 10;
    cross_aisle_set
    openings
    sku_percent = 0.2;
    shape_factor = 1;
    orientation
    maxHeight = 5;
    offset
    k
    delta_ij % Distance between storage nodes, and storage nodes<->cross aisles
    time_ij % Travel time between storage nodes, and storage nodes<->cross aisles
    D % Distance between storage nodes and P/D point
    T % Time between storage nodes and P/D point
    I % Index of nodes in delta_ij, time_ij, D, and T
    penalty = 2; % time penalty for each stop, in seconds
    fleet_size = 1;
    
    
    PickerNetwork@Network
    StorageNetwork@Network
    
    PickEquipment@Pick_Equipment
    StorageEquipment@Storage_Equipment
    
    
    % Warehouse parameters
    avg_order_lines = 10;
    total_sku_count = 5000;
    orders_per_year = 1000 * 250; % 1000 orders per day, 250 working days
    interest_rate = 0.1; % percent per year
    amortization_horizon = 5; % in years
    
    
    % Metrics
    mn_time_per_stop
    footprint
    time100
    time_per_tour
    var_cost
    cap_cost
    
    end
    
    methods
        
        function newSD = Copy(SD)
        % Make a copy of a handle object.    
            
            % Instantiate new object of the same class.
            newSD = feval(class(SD));
 
            % Copy all non-hidden properties.
            p = properties(SD);
            for i = 1:length(p)
                newSD.(p{i}) = SD.(p{i});
            end
            
            newSD.PickEquipment = SD.PickEquipment.Copy;
            newSD.StorageEquipment = SD.StorageEquipment.Copy;
            newSD.PickerNetwork = SD.PickerNetwork.Copy;
            newSD.StorageNetwork = SD.StorageNetwork.Copy;
            
        end
        
        function GeneratePickerNetwork(SD)
        %% Initialize Layout Procedure
            N = 1;
            E = 1;

            NodeSetList = zeros(2*SD.aisles*SD.k, 4); %[ID, X, Y, Z]
            EdgeSetList = zeros(2*2*SD.aisles*SD.k, 4);
            Cross_Aisle_Set = zeros(2*SD.aisles, 1);


            %% Generate SD.aisles (Columns) of Travel Nodes
            for aisle_count = 0:SD.aisles-1
                %Generate the Bottom Cross Aisle    
                NodeSetList(N,:) = [N, 0.5*SD.aisle_module_width+aisle_count*SD.aisle_module_width, 0.5*SD.cross_aisle_width, 0];
                Cross_Aisle_Set(2*aisle_count+1) = N;

                last_xyz = [0.5*SD.aisle_module_width+aisle_count*SD.aisle_module_width, 0.5*SD.cross_aisle_width, 0];
                EdgeSetList(E,:) = [E, N, N+1, 0];
                EdgeSetList(E+1,:) = [E+1, N+1, N, 0];

                N= N+1;
                E = E+2;


                aislelength = SD.aisle_length(aisle_count+1);
                for node_count = 1:SD.k

                    NodeSetList(N,:) = [N, 0.5*SD.aisle_module_width+aisle_count*SD.aisle_module_width, node_count*(aislelength/SD.k)+ SD.cross_aisle_width,0];

                    distance = max(1e-6,sqrt(sum((last_xyz - [0.5*SD.aisle_module_width+aisle_count*SD.aisle_module_width, node_count*(aislelength/SD.k) + SD.cross_aisle_width,0]).^2)));
                    EdgeSetList(E-2, 4) = distance;
                    EdgeSetList(E-1, 4) = distance;

                    last_xyz = [0.5*SD.aisle_module_width+aisle_count*SD.aisle_module_width, node_count*(aislelength/SD.k) + SD.cross_aisle_width,0];
                    EdgeSetList(E,:) = [E, N, N+1, 0];
                    EdgeSetList(E+1,:) = [E+1, N+1, N, 0];

                    N = N+1;
                    E = E+2;
                end
                
                %Generate the Top Cross Aisle
                NodeSetList(N,:) = [N, 0.5*SD.aisle_module_width+aisle_count*SD.aisle_module_width,node_count*(aislelength/SD.k) + 1.5*SD.cross_aisle_width,0];
                Cross_Aisle_Set(2*aisle_count+2) = N;

                distance = max(1e-6,sqrt(sum((last_xyz - [0.5*SD.aisle_module_width+aisle_count*SD.aisle_module_width, node_count*(aislelength/SD.k) + 1.5*SD.cross_aisle_width,0]).^2)));
                EdgeSetList(E-2, 4) = distance;
                EdgeSetList(E-1, 4) = distance;

                N= N+1;
            end

            %% Addition of the Cross SD.aisles on Top and Bottom
            % Can generalize to arbitrary number of cross SD.aisles (perhaps with the mild
            % condition that the aisle node was already placed in previous section

            Cross_Aisle = Cross_Aisle_Set(1:2: 2*(SD.aisles-1)+1);

            for i = 1:length(Cross_Aisle)-1

                    distance = max(1e-06, sqrt(sum([NodeSetList(Cross_Aisle(i),2) NodeSetList(Cross_Aisle(i),3) NodeSetList(Cross_Aisle(i),4)] - [NodeSetList(Cross_Aisle(i+1),2) NodeSetList(Cross_Aisle(i+1),3) NodeSetList(Cross_Aisle(i+1),4)]).^2));
                    EdgeSetList(E,:) = [E, NodeSetList(Cross_Aisle(i),1), NodeSetList(Cross_Aisle(i+1),1), distance];
                    EdgeSetList(E+1,:) = [E+1, NodeSetList(Cross_Aisle(i+1),1), NodeSetList(Cross_Aisle(i),1), distance];
                    E = E+2;
            end

            Cross_Aisle = Cross_Aisle_Set(2:2: 2*(SD.aisles-1)+2);

            for i = 1:length(Cross_Aisle)-1

                    distance = max(1e-06, sqrt(sum([NodeSetList(Cross_Aisle(i),2) NodeSetList(Cross_Aisle(i),3) NodeSetList(Cross_Aisle(i),4)] - [NodeSetList(Cross_Aisle(i+1),2) NodeSetList(Cross_Aisle(i+1),3) NodeSetList(Cross_Aisle(i+1),4)]).^2));
                    EdgeSetList(E,:) = [E, NodeSetList(Cross_Aisle(i),1), NodeSetList(Cross_Aisle(i+1),1), distance];
                    EdgeSetList(E+1,:) = [E+1, NodeSetList(Cross_Aisle(i+1),1), NodeSetList(Cross_Aisle(i),1), distance];
                    E = E+2;
            end
            
            %% Insert Pickup & Drop-off Point(s)
            PD_aisle = ceil(SD.aisles / 2);

            NodeSetList(N,:) = [N, 0.5*SD.aisle_module_width+(PD_aisle-1)*SD.aisle_module_width, 0,0];

            I = find(NodeSetList(:,2) == 0.5*SD.aisle_module_width+(PD_aisle-1)*SD.aisle_module_width);
            n1 = I(1);

            distance = max(1e-06, sqrt(sum([NodeSetList(N,2) NodeSetList(N,3) NodeSetList(N,4)] - [NodeSetList(n1,2) NodeSetList(n1,3) NodeSetList(n1,4)]).^2));
            EdgeSetList(E,:) = [E, N, n1, distance];
            EdgeSetList(E+1,:) = [E+1, n1, N, distance];

            N = N+1;
            E = E+2;
            
            %% Commit Data to Network Structure
            SD.PickerNetwork = Network;
            SD.PickerNetwork.NodeSetList = NodeSetList(1:N-1, :);
            SD.PickerNetwork.EdgeSetList = EdgeSetList(1:E-1, : ); 
            SD.cross_aisle_set = Cross_Aisle_Set;

            SD.PickerNetwork.EdgeSetAdjList = list2adj(SD.PickerNetwork.EdgeSetList(:, 2:end));
            
            coordinates = [SD.PickerNetwork.NodeSetList(:,2), SD.PickerNetwork.NodeSetList(:,3)];
            SD.PickerNetwork.NodeSetList(:,2) = coordinates(:,1)*cos(SD.orientation)-coordinates(:,2)*sin(SD.orientation) + SD.offset(1);
            SD.PickerNetwork.NodeSetList(:,3) = coordinates(:,1)*sin(SD.orientation)+coordinates(:,2)*cos(SD.orientation) + SD.offset(2);

            %SD.PickerNetwork.plotNetwork;
        end
        
        function GenerateStorageNetwork(SD)
            %% Initialize Layout
            N = 1;
            E = 1;
            
            NodeSetList = [0,0,0,0];
            EdgeSetList = [0,0,0,0];
            
            %% Create Nodes
            for height_count = 0:SD.StorageEquipment.storage_height-1
                for aisle_count = 0:SD.aisles-1
                    for node_count = 0:ceil(SD.openings/SD.aisles/SD.StorageEquipment.storage_height/2)-1 %ground openings per aisle on one side

                            NodeSetList(N,:) = [N, 0.5*SD.StorageEquipment.opening_width+aisle_count*SD.aisle_module_width, 0.5*SD.StorageEquipment.opening_length+node_count*SD.StorageEquipment.opening_length+SD.cross_aisle_width, height_count*SD.StorageEquipment.opening_height];
                            NodeSetList(N+1,:) = [N+1, 1.5*SD.StorageEquipment.opening_width+SD.aisle_width+aisle_count*SD.aisle_module_width, 0.5*SD.StorageEquipment.opening_length+node_count*SD.StorageEquipment.opening_length+SD.cross_aisle_width, height_count*SD.StorageEquipment.opening_height];

                            N = N+2;
                    end
                end
            end

            %% Shift Node IDs
            l = length(SD.PickerNetwork.NodeSetList);
            NodeSetList(:,1) = NodeSetList(:,1)+l;

            %% Create Edges
            % Closest travel node to ground openings
            logGroundBaySet = NodeSetList(:,4) == 0;
            GroundBaySet = NodeSetList(logGroundBaySet,:);
            for i=1:length(GroundBaySet)
                [distance, I] = min(max(1e-6,sqrt((GroundBaySet(i,2)-SD.PickerNetwork.NodeSetList(:,2)).^2+(GroundBaySet(i,3)-SD.PickerNetwork.NodeSetList(:,3)).^2)));
                closest = SD.PickerNetwork.NodeSetList(I,1);
                EdgeSetList(E,:) = [E, GroundBaySet(i,1), closest, distance];
                EdgeSetList(E+1,:) = [E+1, closest, GroundBaySet(i,1), distance];
                E=E+2;
            end
            
            % Vertical edges
            if SD.StorageEquipment.storage_height>1
                for node_count = 1:length(GroundBaySet)
                    logHigherBaySet = NodeSetList(:,2) == NodeSetList(node_count,2) & NodeSetList(:,3) == NodeSetList(node_count,3);
                    HigherBaySet = NodeSetList(logHigherBaySet,:);
                    for height_count = 1:size(HigherBaySet,1)-1
                        EdgeSetList(E,:) = [E, HigherBaySet(height_count,1), HigherBaySet(height_count+1,1), SD.StorageEquipment.opening_height];
                        EdgeSetList(E+1,:) = [E+1, HigherBaySet(height_count+1,1), HigherBaySet(height_count,1), SD.StorageEquipment.opening_height];
                        E=E+2;
                    end

                end

            % Changing weight of vertical edges based on vertical velocity and
            % acceleration
            for E=length(GroundBaySet)*2+1:length(EdgeSetList)
                EdgeSetList(E,4) = SD.StorageEquipment.opening_height*(SD.PickEquipment.horizontal_velocity/SD.PickEquipment.vertical_velocity); % vertical accelerations can be considered here!
            end

            E=E+1;
            end
            
            % Horizontal edges
            for height_count = 1:SD.StorageEquipment.storage_height
                for aisle_count = 0:SD.aisles-1
                    logLeftBaySet = NodeSetList(:,2) == 0.5*SD.StorageEquipment.opening_width+aisle_count*SD.aisle_module_width & NodeSetList(:,4) == height_count*SD.StorageEquipment.opening_height;
                    logRightBaySet = NodeSetList(:,2) == 1.5*SD.StorageEquipment.opening_width+SD.aisle_width+aisle_count*SD.aisle_module_width & NodeSetList(:,4) == height_count*SD.StorageEquipment.opening_height;

                    LeftBaySet = NodeSetList(logLeftBaySet,:);
                    RightBaySet = NodeSetList(logRightBaySet,:);

                    for node_count = 1:length(LeftBaySet)-1 %ground openings per aisle on one side
                        EdgeSetList(E,:) = [E, LeftBaySet(node_count,1), LeftBaySet(node_count+1,1), SD.StorageEquipment.opening_length];
                        EdgeSetList(E+1,:) = [E+1, LeftBaySet(node_count+1,1), LeftBaySet(node_count,1), SD.StorageEquipment.opening_height];
                        EdgeSetList(E+2,:) = [E+2, RightBaySet(node_count,1), RightBaySet(node_count+1,1), SD.StorageEquipment.opening_length];
                        EdgeSetList(E+3,:) = [E+3, RightBaySet(node_count+1,1), RightBaySet(node_count,1), SD.StorageEquipment.opening_height];
                        E=E+4;

                    end
                end
            end
            
            %% Commit Data to Network Structure
            SD.StorageNetwork = Network;
            SD.StorageNetwork.NodeSetList = NodeSetList(1:N-1, :);
            SD.StorageNetwork.EdgeSetList = EdgeSetList(1:E-1, : ); 

            SD.StorageNetwork.EdgeSetAdjList = list2adj(SD.StorageNetwork.EdgeSetList(:, 2:end));
            
        end

        function PlotNetworks(SD)
        % Plots the picker and storage network in a figure that shows the
        % storage area
            UnitedNodeSetList = cat(1,SD.PickerNetwork.NodeSetList,SD.StorageNetwork.NodeSetList);

            figure
            scatter3(SD.StorageNetwork.NodeSetList(:,2),SD.StorageNetwork.NodeSetList(:,3),SD.StorageNetwork.NodeSetList(:,4),'filled','MarkerEdgeColor','r','MarkerFaceColor','r')
            hold on
            gplot(SD.PickerNetwork.EdgeSetAdjList, [SD.PickerNetwork.NodeSetList(:,2), SD.PickerNetwork.NodeSetList(:,3)], '-*')
            gplot32(SD.StorageNetwork.EdgeSetAdjList, [UnitedNodeSetList(:,2), UnitedNodeSetList(:,3), UnitedNodeSetList(:,4)], 'c')
            hold off

       end
        
        function ShiftStorageNodeID(SD)
            N = length(SD.PickerNetwork.NodeSetList);
            SD.StorageNetwork.NodeSetList(:,1) = SD.StorageNetwork.NodeSetList(:,1)+N;            
            
        end
        
        function Dimensioning(SD)
        % Determines the number of aisles and their length, and completes
        % the storage departmend object (number of aisles, aisle width,
        % aisle length, aisle modul width, final number of openings,
        % granularity, orientation, and offset)
            opening_width = SD.StorageEquipment.opening_width; 
            opening_length = SD.StorageEquipment.opening_length;
            b = SD.total_sku_count * SD.sku_percent;
            c_a_w = SD.cross_aisle_width;
            sf = SD.shape_factor;
            sHeight = SD.StorageEquipment.storage_height;
            pHeight = SD.PickEquipment.reachable_height;
            a_w = SD.PickEquipment.req_aisle_width; 

            if sHeight > pHeight
                error('Storage height higher than reachable height of pick equipment.')
            end

            a_m_w = 2 * opening_width + a_w; % aisle plus shelves on both sides

            a = 1;
            openings_per_aisle = b;
            a_l = (openings_per_aisle / sHeight / 2) * opening_length;        
            forward_length = a_l + 2 * c_a_w;
            forward_width = a * a_m_w;

            while forward_length > sf * forward_width
                a = a + 1;
                openings_per_aisle = ceil(b / a);
                a_l = ceil(openings_per_aisle / sHeight / 2) * opening_length;        
                forward_length = a_l + 2 * c_a_w;
                forward_width = a * a_m_w;  
            end

            final_opening_count = openings_per_aisle * a; 

            SD.aisles = a;
            SD.aisle_module_width = a_m_w;
            SD.aisle_length = a_l * ones(a, 1);
            SD.aisle_width = a_w;
            SD.openings = final_opening_count;
            SD.k = ceil(a_l/opening_width);
            SD.orientation = 0;
            SD.offset = [0,0];

        end
        
        function Distances(SD)
            % Calculate distances and times between storage locations
            PickerNodeSetList = SD.PickerNetwork.NodeSetList;
            StorageNodeSetList = SD.StorageNetwork.NodeSetList;
            a_m_w = SD.aisle_module_width;
            c_a_s = SD.cross_aisle_set;

            A = list2adj([SD.PickerNetwork.EdgeSetList(:, 2:end); SD.StorageNetwork.EdgeSetList(:, 2:end)]);

            PD_aisle = ceil(SD.aisles / 2);
            PD = PickerNodeSetList(PickerNodeSetList(:,2) == 0.5*a_m_w+(PD_aisle-1)*a_m_w & PickerNodeSetList(:,3) == 0);

            % Distances
            UnitedNodeSetList = cat(1,PickerNodeSetList([PD ; c_a_s],:),StorageNodeSetList);
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

            D = delta_ij(1, length(c_a_s)+2:N);

            % Travel times
            T = D./SD.PickEquipment.horizontal_velocity;
            time_ij = delta_ij./SD.PickEquipment.horizontal_velocity;
            
            % Save distances and times to storage department
            SD.delta_ij = delta_ij;
            SD.time_ij = time_ij;
            SD.D = D;
            SD.T = T;
            SD.I = I;
     
        end
        
        function stops = GenerateOrdersFoA(SD,order_lines)
        % Generates orders based on the frequency of access (or
        % desirability of storage locations), no batching
            NodeSetList = SD.StorageNetwork.NodeSetList;
            movement_nodes = length(SD.PickerNetwork.NodeSetList);
            opening_width = SD.StorageEquipment.opening_width;
            a_m_w = SD.aisle_module_width;
            T = SD.T;

            logstops = datasample(NodeSetList(:,1),order_lines,'Replace',false,'Weights',1./T) - movement_nodes;
            stops = NodeSetList(logstops,:);

            for aisle_count=0:SD.aisles-1
                logAisle1 = stops(:,2)==0.5*opening_width+aisle_count*a_m_w;
                logAisle2 = stops(:,2)==1.5*opening_width+SD.aisle_width+aisle_count*a_m_w;
                stops(logAisle1,5) = aisle_count+1;
                stops(logAisle2,5) = aisle_count+1;
            end

        end
        
        function stops = GenerateBatchesFoA(SD)
        % Generates orders based on the frequency of access (or
        % desirability of storage locations), and combines them into
        % batches based on pick equipment capacity

            batch_size = SD.PickEquipment.capacity;
            NodeSetList = SD.StorageNetwork.NodeSetList;
            movement_nodes = length(SD.PickerNetwork.NodeSetList);
            opening_width = SD.StorageEquipment.opening_width;
            a_m_w = SD.aisle_module_width;
            a_o_l = SD.avg_order_lines;
            T = SD.T;

            logstops = datasample(NodeSetList(:,1),batch_size*a_o_l,'Replace',false,'Weights',1./T) - movement_nodes;
            stops = NodeSetList(logstops,:);

            for aisle_count=0:SD.aisles-1
                logAisle1 = stops(:,2)==0.5*opening_width+aisle_count*a_m_w;
                logAisle2 = stops(:,2)==1.5*opening_width+SD.aisle_width+aisle_count*a_m_w;
                stops(logAisle1,5) = aisle_count+1;
                stops(logAisle2,5) = aisle_count+1;
            end

        end
        
        function stops = GenerateOrdersUni(SD,order_lines)
        % Generates orders uniformly, no batching
        
            NodeSetList = SD.StorageNetwork.NodeSetList;
            movement_nodes = length(SD.PickerNetwork.NodeSetList);
            opening_width = SD.StorageEquipment.opening_width;
            a_m_w = SD.aisle_module_width;

            logstops = datasample(NodeSetList(:,1),order_lines,'Replace',false) - movement_nodes;
            stops = NodeSetList(logstops,:);

            for aisle_count=0:SD.aisles-1
                logAisle1 = stops(:,2)==0.5*opening_width+aisle_count*a_m_w;
                logAisle2 = stops(:,2)==1.5*opening_width+SD.aisle_width+aisle_count*a_m_w;
                stops(logAisle1,5) = aisle_count+1;
                stops(logAisle2,5) = aisle_count+1;
            end

        end
        
        function stops = GenerateBatchesUni(SD)
        % Generates ordersuniformly and batches them based on pick
        % equipment capacity

            batch_size = SD.PickEquipment.capacity;
            NodeSetList = SD.StorageNetwork.NodeSetList;
            movement_nodes = length(SD.PickerNetwork.NodeSetList);
            opening_width = SD.StorageEquipment.opening_width;
            a_m_w = SD.aisle_module_width;
            a_o_l = SD.avg_order_lines;

            logstops = datasample(NodeSetList(:,1),batch_size*a_o_l,'Replace',false) - movement_nodes;
            stops = NodeSetList(logstops,:);

            for aisle_count=0:SD.aisles-1
                logAisle1 = stops(:,2)==0.5*opening_width+aisle_count*a_m_w;
                logAisle2 = stops(:,2)==1.5*opening_width+SD.aisle_width+aisle_count*a_m_w;
                stops(logAisle1,5) = aisle_count+1;
                stops(logAisle2,5) = aisle_count+1;
            end

        end
        
        function tour = SerpentineSkipping(SD,stops)
            % Determine sequence of nodes to visit based on serpentine and
            % skipping policy
            aisles = SD.aisles;
            c_a_s = SD.cross_aisle_set;
            NodeSetList = SD.PickerNetwork.NodeSetList;
            stops = sortrows(stops, 5);
            a = 0;

            tour = [NodeSetList(NodeSetList(:,3)==0,:), 0]; % P/D-point

            for aisle_count=1:aisles
                if ismember(aisle_count,stops(:,5))
                    a = a + 1;
                    if mod(a,2) == 0
                        tour = cat(1, tour, [c_a_s(2*aisle_count),NodeSetList(c_a_s(2*aisle_count),2),NodeSetList(c_a_s(2*aisle_count),3),NodeSetList(c_a_s(2*aisle_count),4),aisle_count]);
                        aisle_stops = sortrows(stops(stops(:,5)==aisle_count,:),-3);
                        tour = cat(1, tour, aisle_stops);
                        tour = cat(1, tour, [c_a_s(2*aisle_count-1),NodeSetList(c_a_s(2*aisle_count-1),2),NodeSetList(c_a_s(2*aisle_count-1),3),NodeSetList(c_a_s(2*aisle_count-1),4),aisle_count]);
                    else
                        tour = cat(1, tour, [c_a_s(2*aisle_count-1),NodeSetList(c_a_s(2*aisle_count-1),2),NodeSetList(c_a_s(2*aisle_count-1),3),NodeSetList(c_a_s(2*aisle_count-1),4),aisle_count]);
                        aisle_stops = sortrows(stops(stops(:,5)==aisle_count,:),3);
                        tour = cat(1, tour, aisle_stops);
                        tour = cat(1, tour, [c_a_s(2*aisle_count),NodeSetList(c_a_s(2*aisle_count),2),NodeSetList(c_a_s(2*aisle_count),3),NodeSetList(c_a_s(2*aisle_count),4),aisle_count]);
                    end
                end
            end

            tour = cat(1, tour, [NodeSetList(NodeSetList(:,3)==0,:), 0]); % P/D-point

        end
        
        function tour = NearestNeighbor(SD,stops)
            % Determine sequence of nodes to visit based on nearest neighbor policy
            time_ij = SD.time_ij;
            c_a_s = SD.cross_aisle_set;
            PNodeSetList = SD.PickerNetwork.NodeSetList;

            time_ij = time_ij(length(c_a_s)+2:end,length(c_a_s)+2:end);

            logstops = stops(:,1) - length(PNodeSetList);

            C = time_ij([1;logstops],[1;logstops]);

            PDstops = [PNodeSetList(PNodeSetList(:,3)==0,1);logstops];

            [M,idx] = min(stops(:,2));
            [loc,TC,bestvtx] = tspnneighbor(C,idx);

            tour = PDstops(loc) + length(PNodeSetList);

            tour(1) = PNodeSetList(PNodeSetList(:,3)==0,1); % P/D-point
            tour(end) = PNodeSetList(PNodeSetList(:,3)==0,1); % P/D-point

        end
        
        function time = TourTravelTime(SD,tour)
        % Calculate the travel time for a tour
            time_ij = SD.time_ij;
            I = SD.I;
            time = 0;
            
            for t = 1:length(tour)-1
                time = time + time_ij(I==tour(t),I==tour(t+1));
            end
            
        end
        
        function [mn_time_per_stop, variance] = getMeanTimePerStop(SD,num_runs)
            % Simulation to determine mean time per stop
            
            travel_time = zeros(num_runs,1);
            for m = 1:num_runs % runs of Monte Carlo Simulation

                % Batching (Monte Carlo Sampling)
                stops = SD.GenerateBatchesFoA;

                % Routing - Create Tours
                tour = SD.NearestNeighbor(stops);

                % Calculate travel time
                time = SD.TourTravelTime(tour);

                travel_time(m) = (time + SD.penalty * length(stops))/length(stops);
            end

            % Calculate mean travel time per stop
            mn_time_per_stop = mean(travel_time);
            variance = var(travel_time);
            SD.mn_time_per_stop = mn_time_per_stop;
            
        end
        
        function footprint = getFootprint(SD)
        % Determine the footprint of the storage area and save it to the
        % storage department object
            forward_length = SD.aisle_length(1) + 2 * SD.cross_aisle_width;
            forward_width = SD.aisles * SD.aisle_module_width;
            
            footprint = forward_length * forward_width;
            SD.footprint = footprint;
            
        end
        
        function [time100, time_per_tour] = getTime100Orders(SD)
            %% Evaluate time it takes to clear out 100 orders
            % Generate 100 orders (without replacement within a group of orders (1
            % to capacity)) and calculate the times it takes to pick each batch
            capacity = SD.PickEquipment.capacity;
            
            max_time = zeros(50,1);
            mn_time_tour = zeros(50,1);
            tours = floor(100/capacity);
            for m = 1:50 % 50 Simulation runs
                travel_time = zeros(tours,1);
                for o = 1:tours
                    % Batching (Monte Carlo Sampling)
                    stops = SD.GenerateBatchesFoA;

                    % Routing - Create Tours
                    tour = SD.NearestNeighbor(stops);

                    % Calculate travel time
                    time = SD.TourTravelTime(tour);

                    travel_time(o) = time + SD.penalty * length(stops);
                end
                
                % if there is a rest to 100 orders, generate a shorter tour
                if tours * capacity < 100
                    % Batching (Monte Carlo Sampling)
                    stops = SD.GenerateOrdersFoA(100-(length(travel_time)*capacity));

                    % Routing - Create Tours
                    tour = SD.NearestNeighbor(stops);

                    % Calculate travel time
                    time = SD.TourTravelTime(tour);

                    travel_time(end+1) = time + SD.penalty * length(stops);  
                end


                % Assign travel times to each member of the fleet
                time_assigned = zeros(length(travel_time),SD.fleet_size);
                for o = 1:length(travel_time)
                    colum_sum = sum(time_assigned,1);
                    [~,idx] = min(colum_sum);
                    time_assigned(o,idx) = travel_time(o);
                end
                colum_sum = sum(time_assigned,1);
                max_time(m) = max(colum_sum);
                mn_time_tour(m) = mean(travel_time);
            end

            % Calculate time to clear out 100 orders and corresponding mean time per tour
            time100 = mean(max_time);
            time_per_tour = mean(mn_time_tour);
            
            SD.time100 = time100;
            SD.time_per_tour = time_per_tour;
        end
        
        function varCost = getVariableCost(SD)
                        
            %varCost = sum((1/(1 + SD.interest_rate)).^(1:SD.amortization_horizon))*(SD.PickEquipment.variable_cost * SD.time_per_tour/3600*(SD.orders_per_year/SD.PickEquipment.capacity)); % discounted annual cost, 8 hrs per day, 230 working days per year, interest rate 10%, planning horizon 5 years
            varCost = sum((1/(1 + SD.interest_rate)).^(1:SD.amortization_horizon))*(SD.time100/3600*SD.orders_per_year/100 * SD.PickEquipment.variable_cost * SD.fleet_size);
            SD.var_cost = varCost;
            
        end
        
        function capCost = getCapitalCost(SD)
            
            capCost = SD.fleet_size * SD.PickEquipment.fixed_cost + SD.StorageEquipment.fixed_cost * SD.openings;
            SD.cap_cost = capCost;
            
        end
    end
    
end

