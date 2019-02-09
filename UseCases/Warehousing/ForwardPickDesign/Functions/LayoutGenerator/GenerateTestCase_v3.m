aisles = 10;
aisle_width = 30;
aisle_length = 50*ones(aisles, 1);%1000-Parametric_Ellipse(0.5*aisle_width:aisle_width:aisle_width*(aisles-1)+0.5*aisle_width);
k = 50;
Orientation = 0; %pi; %pi/2; %0; %3*pi/2;
Offset = [0,0];%[aisles*aisle_width,1000+0.5*aisle_width];%[0,0];%[aisles*aisle_width,1000+aisle_width];%10*aisle_width]; %[2*aisle_length+30, 0]; %[0, 10*aisle_width];%[0, aisles*aisle_width]
full = 0;

%% Initialize Layout Procedure
N = 1;
E = 1;

NodeSetList = zeros(2*aisles*k, 4); %[ID, X, Y, Z]
EdgeSetList = zeros(2*2*aisles*k, 4);
Cross_Aisle_Set = zeros(2*aisles, 1);
if eq(full,1)
    NodeSet(2*aisles*k) = Node;
    EdgeSet(2*2*aisles*k) = Edge;
end


%% Generate Aisles (Columns) of Travel Nodes
for aisle_count = 0:aisles-1
    %Generate the Bottom Cross Aisle    
    NodeSetList(N,:) = [N, 0.5*aisle_width+aisle_count*aisle_width, 0.25*aisle_width, 0];
    Cross_Aisle_Set(2*aisle_count+1) = N;
    
    if eq(full, 1)
        NodeSet(N) = Node(N, 0.5*aisle_width+aisle_count*aisle_width, 0.25*aisle_width, 0, 'Transport');
        eO = Edge(E, N, N+1, 'UoH');
        eD = Edge(E+1, N+1, N, 'UoH');
        NodeSet(N).addEdge(eO);
        NodeSet(N).addEdge(eD);
        EdgeSet(E) = eO;
        EdgeSet(E+1) = eD;
    end
    
    last_xyz = [0.5*aisle_width+aisle_count*aisle_width, 0.25*aisle_width, 0];
    EdgeSetList(E,:) = [E, N, N+1, 0];
    EdgeSetList(E+1,:) = [E+1, N+1, N, 0];

    N= N+1;
    E = E+2;
    
    
    aislelength = aisle_length(aisle_count+1);
    for node_count = 1:k
                
        NodeSetList(N,:) = [N, 0.5*aisle_width+aisle_count*aisle_width, node_count*(aislelength/k)+ 0.25*aisle_width,0];
        
        distance = max(1e-6,sqrt(sum((last_xyz - [0.5*aisle_width+aisle_count*aisle_width, node_count*(aislelength/k) + 0.25*aisle_width,0]).^2)));
        
        if eq(full,1)
            NodeSet(N) = Node(N, 0.5*aisle_width+aisle_count*aisle_width, node_count*(aislelength/k) + 0.25*aisle_width,0, 'Transport');
            eO.Weight = distance;
            eD.Weight = distance;
            NodeSet(N).addEdge(eO);
            NodeSet(N).addEdge(eD);
        end
        
        EdgeSetList(E-2, 4) = distance;
        EdgeSetList(E-1, 4) = distance;
                        
        if eq(full, 1)
            eD = Edge(E+1, N+1, N, 'UoH');
            eO = Edge(E, N, N+1, 'UoH');
            NodeSet(N).addEdge(eO);
            NodeSet(N).addEdge(eD);
        end
        
        last_xyz = [0.5*aisle_width+aisle_count*aisle_width, node_count*(aislelength/k) + 0.25*aisle_width,0];
        EdgeSetList(E,:) = [E, N, N+1, 0];
        EdgeSetList(E+1,:) = [E+1, N+1, N, 0];

        if eq(full,1)
            EdgeSet(E) = eO;
            EdgeSet(E+1) = eD;
        end
        
        N = N+1;
        E = E+2;
    end
    %Generate the Top Cross Aisle
    NodeSetList(N,:) = [N, 0.5*aisle_width+aisle_count*aisle_width,node_count*(aislelength/k) + 0.5*aisle_width,0];
    Cross_Aisle_Set(2*aisle_count+2) = N;
    
    distance = max(1e-6,sqrt(sum((last_xyz - [0.5*aisle_width+aisle_count*aisle_width, node_count*(aislelength/k) + 0.5*aisle_width,0]).^2)));
    if eq(full,1)
        NodeSet(N) = Node(N, 0.5*aisle_width+aisle_count*aisle_width, node_count*(aislelength/k) + 0.5*aisle_width,0, 'Transport');
        eO.Weight = distance;
        eD.Weight = distance;
        NodeSet(N).addEdge(eO);
        NodeSet(N).addEdge(eD);
    end
        EdgeSetList(E-2, 4) = distance;
        EdgeSetList(E-1, 4) = distance;
    
    N= N+1;
end

%% Addition of the Cross Aisles on Top and Bottom
% Can generalize to arbitrary number of cross aisles (perhaps with the mild
% condition that the aisle node was already placed in previous section

Cross_Aisle = Cross_Aisle_Set(1:2: 2*(aisles-1)+1);

for i = 1:length(Cross_Aisle)-1
    
        distance = max(1e-06, sqrt(sum([NodeSetList(Cross_Aisle(i),2) NodeSetList(Cross_Aisle(i),3) NodeSetList(Cross_Aisle(i),4)] - [NodeSetList(Cross_Aisle(i+1),2) NodeSetList(Cross_Aisle(i+1),3) NodeSetList(Cross_Aisle(i+1),4)]).^2));
        EdgeSetList(E,:) = [E, NodeSetList(Cross_Aisle(i),1), NodeSetList(Cross_Aisle(i+1),1), distance];
        EdgeSetList(E+1,:) = [E+1, NodeSetList(Cross_Aisle(i+1),1), NodeSetList(Cross_Aisle(i),1), distance];
        E = E+2;
end

Cross_Aisle = Cross_Aisle_Set(2:2: 2*(aisles-1)+2);

for i = 1:length(Cross_Aisle)-1
    
        distance = max(1e-06, sqrt(sum([NodeSetList(Cross_Aisle(i),2) NodeSetList(Cross_Aisle(i),3) NodeSetList(Cross_Aisle(i),4)] - [NodeSetList(Cross_Aisle(i+1),2) NodeSetList(Cross_Aisle(i+1),3) NodeSetList(Cross_Aisle(i+1),4)]).^2));
        EdgeSetList(E,:) = [E, NodeSetList(Cross_Aisle(i),1), NodeSetList(Cross_Aisle(i+1),1), distance];
        EdgeSetList(E+1,:) = [E+1, NodeSetList(Cross_Aisle(i+1),1), NodeSetList(Cross_Aisle(i),1), distance];
        E = E+2;
end
%% Commit Data to Network Structure
MovementNetwork = Network;
MovementNetwork.NodeSetList = NodeSetList(1:N-1, :);
MovementNetwork.EdgeSetList = EdgeSetList(1:E-1, : );

if eq(full,1)
    MovementNetwork.NodeSet = NodeSet(1:N-1);
    MovementNetwork.EdgeSet = EdgeSet(1:E-1);
end

MovementNetwork.EdgeSetAdjList = list2adj(MovementNetwork.EdgeSetList(:, 2:end));

coordinates = [MovementNetwork.NodeSetList(:,2), MovementNetwork.NodeSetList(:,3)];
MovementNetwork.NodeSetList(:,2) = coordinates(:,1)*cos(Orientation)-coordinates(:,2)*sin(Orientation) + Offset(1);
MovementNetwork.NodeSetList(:,3) = coordinates(:,1)*sin(Orientation)+coordinates(:,2)*cos(Orientation) + Offset(2);
coordinates = [MovementNetwork.NodeSetList(:,2), MovementNetwork.NodeSetList(:,3)];
%[X2, Y2] = gplot(MovementNetwork.EdgeSetAdjList, coordinates, '-*');
%[X1,Y1] = gplot(MovementNetwork.EdgeSetAdjList, coordinates, '-*');
gplot(MovementNetwork.EdgeSetAdjList, coordinates, '-*')

