function [pf1, ef1] = build_process_sim(database, Model)
    database = 'C:/Users/tsprock3/Desktop/BoeingModel.accdb';
    Model = 'ProcessModel';
    ef1 = EdgeFactory;
    ef1.Model = Model;
    ef1.database = database;
    ef1.setEdgeSet;
    pf1 = ProcessFactory;
    pf1.Model = Model;
    pf1.database =database;
    pf1.setNodeSet;
    pf1.allocate_edges(ef1.EdgeSet);

    open('DELS_Library');
    open(Model);
    simeventslib;
    
    try
        pf1.CreateNodes;
        ef1.CreateEdges;
        set_param('ProcessModel/SourceSink/Process/SystemTimer', 'TimerTag', strcat('T_', pf1.NodeSet(1).Node_Name))
    catch err
        rethrow(err);
    end

end

