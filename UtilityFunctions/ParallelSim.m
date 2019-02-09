Model = 'UberSpurs';

if isempty(gcp) ==1
poolobj = parpool;
end

load_system(Model);
warning('off','all');

%This is the simple spmd command
% spmd
% % Load the model on the worker
% warning('off','all');
% load_system(Model);
% end

%Most of the time you should put the simulation models in their own temp
%folder for each worker.
spmd
    currDir = pwd;
    addpath(currDir);
    tmpDir = tempname;
    mkdir(tmpDir);
    cd(tmpDir);
    warning('off','all');
    % Load the model on the worker
    load_system(Model);
end


try
    %IF you want to store data from the output of the simulation, sometimes
    %you need to slice the matrix that is storing your results in a certain
    %way. if you don't get an error, don't worry about it.
    %http://www.mathworks.com/help/distcomp/sliced-variables.html
    parfor i = 1:10
        %se_randomizeseeds(Model, 'Mode', 'All', 'Verbose', 'off');
        simOut = sim(Model,'StopTime', '500', 'SaveOutput', 'on');
    end
    
    save Checkpoint.mat;
    %Change all the workers back to their original directory
    spmd
        cd(currDir);
        %rmdir(tmpDir,'s');
        %rmpath(currDir);
        close_system(Model, 0);
    end
    
    warning('on', 'all');
    close_system(Model, 0);
    delete(gcp('nocreate'));


catch err
 % 5) Switch all of the workers back to their original folder.
    
    %On Error, always save data first!
    save Checkpoint.mat;
    
    %Gracefully shut down the workers
    spmd
        cd(currDir);
        %rmdir(tmpDir,'s');
        %rmpath(currDir);
        close_system(Model, 0);
    end
    
    close_system(Model, 0);
    delete(gcp('nocreate'));
    
    %Then throw error
    rethrow(err);
end