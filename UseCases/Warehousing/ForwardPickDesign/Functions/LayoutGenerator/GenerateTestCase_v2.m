aisles = 13;
PD_aisle = 7;
slot_width = 10;
aisle_width = 30;
slots = 25;
cross_aisle = [10];
full = 1;

%% Initialize Layout Procedure
N = 1;
E = 1;

NodeSetList = zeros(2*aisles*slots, 4); %[ID, X, Y, Z]
EdgeSetList = zeros(2*2*aisles*slots, 4);
if eq(full,1)
    NodeSet(2*aisles*slots) = Node;
    EdgeSet(2*2*aisles*slots) = Edge;
end
cross_aisle_width = 3*slot_width;

%% Generate Aisles (Columns) of Travel Nodes
for aisle_count = 0:aisles-1
    %Generate the Bottom Cross Aisle    
    NodeSetList(N,:) = [N, 0.5*aisle_width+aisle_count*aisle_width, 0.25*cross_aisle_width, 0];
    
    if eq(full, 1)
        NodeSet(N) = Node(N, 0.5*aisle_width+aisle_count*aisle_width, 0.25*cross_aisle_width, 0, 'Transport');
        eO = Edge(E, N, N+1, 'UoH');
        eD = Edge(E+1, N+1, N, 'UoH');
        NodeSet(N).addEdge(eO);
        NodeSet(N).addEdge(eD);
        EdgeSet(E) = eO;
        EdgeSet(E+1) = eD;
    end
    
    last_xyz = [0.5*aisle_width+aisle_count*aisle_width, 0.25*cross_aisle_width, 0];
    EdgeSetList(E,:) = [E, N, N+1, 0];
    EdgeSetList(E+1,:) = [E+1, N+1, N, 0];

    N= N+1;
    E = E+2;
    for slot_count = 0:slots-1
                
        NodeSetList(N,:) = [N, 0.5*aisle_width+aisle_count*aisle_width, 0.5*slot_width + slot_count*slot_width + 0.25*cross_aisle_width,0];
        
        distance = max(1e-6,sqrt(sum((last_xyz - [0.5*aisle_width+aisle_count*aisle_width, 0.5*slot_width + slot_count*slot_width + 0.25*cross_aisle_width,0]).^2)));
        
        if eq(full,1)
            NodeSet(N) = Node(N, 0.5*aisle_width+aisle_count*aisle_width, 0.5*slot_width + slot_count*slot_width + 0.25*cross_aisle_width,0, 'Transport');
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
        
        last_xyz = [0.5*aisle_width+aisle_count*aisle_width, 0.5*slot_width + slot_count*slot_width + 0.25*cross_aisle_width,0];
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
    NodeSet(N) = Node(N, 0.5*aisle_width+aisle_count*aisle_width, slots*slot_width + 0.5*cross_aisle_width,0, 'Transport');
    NodeSetList(N,:) = [N, 0.5*aisle_width+aisle_count*aisle_width, slots*slot_width + 0.5*cross_aisle_width,0];
    
    distance = max(1e-6,sqrt(sum((last_xyz - [0.5*aisle_width+aisle_count*aisle_width, slots*slot_width + 0.5*cross_aisle_width,0]).^2)));
    if eq(full,1)
        eO.Weight = distance;
        eD.Weight = distance;
        NodeSet(N).addEdge(eO);
        NodeSet(N).addEdge(eD);
    end
        EdgeSetList(E-2, 4) = distance;
        EdgeSetList(E-1, 4) = distance;
    
    N= N+1;
end

%% Addition of the Cross Aisles on Top, Middle, and Bottom
% Can generalize to arbitrary number of cross aisles (perhaps with the mild
% condition that the aisle node was already placed in previous section
Cross_Aisle_Set = [0.25*cross_aisle_width, slots*slot_width + 0.5*cross_aisle_width, 0.5*slot_width + cross_aisle*slot_width + 0.25*cross_aisle_width];

for j = 1:length(Cross_Aisle_Set)
    
    if eq(full,1)
        Cross_Aisle = findobj(NodeSet, 'Y', Cross_Aisle_Set(j));

        for i = 1:length(Cross_Aisle)-1
            eO = Edge(E, Cross_Aisle(i).Node_ID, Cross_Aisle(i+1).Node_ID, 'UoH');
            eD = Edge(E+1, Cross_Aisle(i+1).Node_ID, Cross_Aisle(i).Node_ID, 'UoH');

            distance = max(1e-06, sqrt(sum([Cross_Aisle(i).X Cross_Aisle(i).Y Cross_Aisle(i).Z] - [Cross_Aisle(i+1).X Cross_Aisle(i+1).Y Cross_Aisle(i+1).Z]).^2));

            eO.Weight = distance; 
            eD.Weight = distance;
            Cross_Aisle(i).addEdge(eO);
            Cross_Aisle(i).addEdge(eD);
            Cross_Aisle(i+1).addEdge(eO);
            Cross_Aisle(i+1).addEdge(eD);

            EdgeSetList(E,:) = [E, Cross_Aisle(i).Node_ID, Cross_Aisle(i+1).Node_ID, distance]; 
            EdgeSetList(E+1,:) = [E+1, Cross_Aisle(i+1).Node_ID, Cross_Aisle(i).Node_ID, distance];


            EdgeSet(E) = eO;
            EdgeSet(E+1) = eD;
            E = E+2;
        end
    else
        Cross_Aisle = find(NodeSetList(:,3) == 0.25*cross_aisle_width);

        for i = 1:length(Cross_Aisle)-1
            distance = max(1e-06, sqrt(sum([NodeSetList(Cross_Aisle(i),2) NodeSetList(Cross_Aisle(i),3) NodeSetList(Cross_Aisle(i),4)] - [NodeSetList(Cross_Aisle(i+1),2) NodeSetList(Cross_Aisle(i+1),3) NodeSetList(Cross_Aisle(i+1),4)]).^2));
            EdgeSetList(E,:) = [E, NodeSetList(Cross_Aisle(i),1), NodeSetList(Cross_Aisle(i+1),1), distance];
            EdgeSetList(E+1,:) = [E+1, NodeSetList(Cross_Aisle(i+1),1), NodeSetList(Cross_Aisle(i),1), distance];
            E = E+2;
        end
        
        
    end
end

%% Insert Pickup & Drop-off Point(s)
    distance = 0.25*cross_aisle_width;
    
    if eq(full,1)
        NodeSet(N) = Node(N, 0.5*aisle_width+PD_aisle*aisle_width, 0, 0, 'P&D');
        n1 = findobj(findobj(NodeSet, 'X', 0.5*aisle_width+PD_aisle*aisle_width), 'Y', 0.25*cross_aisle_width);
        
        eO = Edge(E+1, n1.Node_ID, N, 'UoH');
        eD = Edge(E, N, n1.Node_ID, 'UoH');
        eO.Weight = distance;
        eD.Weight = distance;
        
        n1.addEdge(eO);
        n1.addEdge(eD);
        NodeSet(N).addEdge(eO);
        NodeSet(N).addEdge(eD);
        EdgeSet(E) = eO;
        EdgeSet(E+1) = eD;
    end
    
    NodeSetList(N,:) = [N, 0.5*aisle_width+PD_aisle*aisle_width, 0, 0];
    n1 = find(NodeSetList(:,2) == 0.5*aisle_width+PD_aisle*aisle_width & NodeSetList(:,3) == 0.25*cross_aisle_width);
    EdgeSetList(E,:) = [E, N, NodeSetList(n1, 1), distance];
    EdgeSetList(E+1,:) = [E+1,  NodeSetList(n1, 1), N, distance;];

    
    E = E+1;

%% Commit Data to Network Structure
MovementNetwork = Network;
MovementNetwork.NodeSetList = NodeSetList(1:N, :);
MovementNetwork.EdgeSetList = EdgeSetList(1:E , : );

if eq(full,1)
    MovementNetwork.NodeSet = NodeSet(1:N);
    MovementNetwork.EdgeSet = EdgeSet(1:E);
    %MovementNetwork.setEdgeWeights;
end

MovementNetwork.EdgeSetAdjList = list2adj(MovementNetwork.EdgeSetList(:, 2:end));


%% Generate Storage Network 
%(two storage nodes for each travel node in an aisle)
n = 1;
e = 1;

NodeSetList = zeros(2*2*aisles*slots, 4); %[ID, X, Y, Z]
EdgeSetList = zeros(2*2*2*aisles*slots, 4);
if eq(full,1)
    NodeSet(2*2*aisles*slots) = Node;
    EdgeSet(2*2*2*aisles*slots) = Edge;

    for i = 1:length(MovementNetwork.NodeSet)
        travelNode = MovementNetwork.NodeSet(i);

        if eq(any(travelNode.Y  == [0, 0.25*cross_aisle_width, 0.5*slot_width +slot_width*[cross_aisle-1, cross_aisle, cross_aisle+1]]),1)
            continue
        else
            tnID = travelNode.Node_ID;
            X = travelNode.X;
            Y = travelNode.Y;
            Z = travelNode.Z;
            for j = 1:2
            %Create Two Storage Nodes in the Same Location as the Transport
                %Node

                NodeSetList(n,:) = [N, X, Y, Z];
                NodeSet(n) = Node(N, X, Y, Z, 'Storage');

                eO = Edge(E+1, tnID, N, 'UoH');
                eD = Edge(E, N, tnID, 'UoH');

                eO.Weight = 1e-6;
                eD.Weight = 1e-6;
                NodeSet(n).addEdge(eO);
                NodeSet(n).addEdge(eD);
                travelNode.addEdge(eO);
                travelNode.addEdge(eD);
                EdgeSet(e) = eO;    
                EdgeSet(e+1) = eD;


                %Fudge the distance to make the shortest path alg work.
                EdgeSetList(e,:) = [E, N, tnID, 1e-6];
                EdgeSetList(e+1,:) = [E+1, tnID, N, 1e-6];


                N = N+1;
                n = n+1;
                E = E+2;
                e = e+2;
            end

        end
    end
else
    for i = 1:length(MovementNetwork.NodeSetList)
        travelNode = MovementNetwork.NodeSetList(i,:);

        if eq(any(travelNode(3)  == [0, 0.25*cross_aisle_width, 0.5*slot_width +slot_width*[cross_aisle-1, cross_aisle, cross_aisle+1]]),1)
            continue
        else
            tnID = travelNode(1);
            for j = 1:2
            %Create Two Storage Nodes in the Same Location as the Transport
                %Node
                NodeSetList(n,:) = [N, travelNode(2:4)];

                %Fudge the distance to make the shortest path alg work.
                EdgeSetList(e,:) = [E, N, tnID, 1e-6];
                EdgeSetList(e+1,:) = [E+1, tnID, N, 1e-6];

                N = N+1;
                n = n+1;
                E = E+2;
                e = e+2;
            end

        end
    end
end

%% Commit Data to Network Structure
StorageNetwork = Network;

StorageNetwork.NodeSetList = NodeSetList(1:n-1, :);
StorageNetwork.EdgeSetList = EdgeSetList(1:e-1, : );
StorageNetwork.EdgeSetAdjList = list2adj(StorageNetwork.EdgeSetList(:, 2:end));

if eq(full,1)
    StorageNetwork.NodeSet = NodeSet(1:n-1);
    StorageNetwork.EdgeSet = EdgeSet(1:e-1);
    %StorageNetwork.setEdgeWeights;
end

