cn = actxserver('Access.application');
db=invoke(cn.DBEngine,'OpenDatabase','C:\Users\tsprock3\Desktop\BoeingModel.accdb');

accessmodel = ' ProcessPlan2';
try    
    sqlstring = 'DELETE * FROM NodeTable;';

    db.Execute(sqlstring);
    
    %strcat truncates trailing spaces
    sqlstring = strcat('INSERT INTO NodeTable ( Node_ID, Node_Name, Type, Parent_ID, Echelon ) ', ...
                        ' SELECT Node_ID, Node_Name, Type, Parent_ID, Echelon ', ...
                            ' FROM', accessmodel ,'_Nodes;');

    db.Execute(sqlstring);

    sqlstring = 'DELETE * FROM ProcessAttributes;';

    db.Execute(sqlstring);

    sqlstring = strcat('INSERT INTO ProcessAttributes ( Process_ID, ServerCount, ProcessTime_Mean, ProcessTime_Stdev, StorageCapacity ) ', ...
                        ' SELECT Node_ID, ServerCount, ProcessTime_Mean, ProcessTime_Stdev, StorageCapacity ', ... 
                            ' FROM',  accessmodel ,'_Nodes;');

    db.Execute(sqlstring);

    sqlstring = 'DELETE * FROM EdgeTable;';

    db.Execute(sqlstring);

    sqlstring = strcat('INSERT INTO EdgeTable SELECT * FROM ', accessmodel, '_Edges;');

    db.Execute(sqlstring);


    db.Close;
    db.release;

    cn.delete;
    
catch err
    db.Close;
    db.release;

    cn.delete;
    rethrow(err);
end