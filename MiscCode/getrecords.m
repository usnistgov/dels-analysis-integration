function recordstruct = getrecords(database, sqlstring)
%GETRECORDS(tablename) opens a connection to the MSAccess database,
% creates a recordset from (tablename),
% puts the columns, or fieldnames, into recordstruct.columnnames,
% and puts the record contents into recordstruct.data.


cn=actxserver('Access.application');
%db=invoke(cn.DBEngine,'OpenDatabase','C:\Users\tsprock3\Desktop\DELS.accdb');
db=invoke(cn.DBEngine,'OpenDatabase',database);

%rs=invoke(db,'OpenRecordset',tablename);
%s = 'SELECT * FROM NodeTable;';
rs=invoke(db,'OpenRecordset',sqlstring);

fieldlist=get(rs,'Fields');
ncols=get(fieldlist,'Count');

nrecs=0;
while get(rs,'EOF')==0
    nrecs=nrecs + 1;
    for c=1:double(ncols)
        fields{c}=get(fieldlist,'Item',c-1);
        recordstruct.data{nrecs,c}=get(fields{c},'Value');
    end;
    invoke(rs,'MoveNext');
end;

for c=1:double(ncols)
    recordstruct.columnnames{c}=get(fields{c},'Name');
    %if we can discern datatypes, then we could convert them from cells at
    %runtime: data.Weight = cell2mat(data.Weight)
    recordstruct.(get(fields{c},'Name')) = recordstruct.data(:,c);
end;



invoke(rs,'Close');
invoke(db,'Close');
delete(cn);

end