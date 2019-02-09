%% Useful Commands 
find_system('UberSpurs/spur1WorkCell') %get all the blocks in that subsystem
 se_randomizeseeds('UberSpurs','Mode','All', 'Verbose', 'On') %randomize all the rng seeds
 % fill to verify time for channel 1
 histogram(logsout.get('fill2VerifyTime').Values.Data(logsout.get('Channel').Values.Data == 1),'BinWidth', 1.5)
 % label to fill time on channel 2 spur 1
 histogram(logsout.get('label2FillTime').Values.Data(logsout.get('Channel').Values.Data(logsout.get('Spur').Values.Data == 1) == 2),'BinWidth', 10)

%% Set Release Rate
set_param('UberSpurs/orderRelease/Order Release', 'Period', '18/36')

%% set bagger availability
%PulseWidth is the % of the period that the server is paused
for ii = 1:4
    set_param(strcat('UberSpurs/BaggerWS', num2str(ii), '/Pulse Generator'), 'Amplitude', '1', 'Period', '100', 'PulseWidth', '10', 'PhaseDelay', num2str((ii-1)*1000/4));
end

%% Set Label Conveyor Parameters
set_param('UberSpurs/toLabel1', 'NumberOfServers', '22', 'ServiceTime', '8');
set_param('UberSpurs/fromLabel', 'NumberOfServers', '45', 'ServiceTime', '37');

%% Set Main Conveyor Parameters
set_param('UberSpurs/toSpur1', 'NumberOfServers', '20', 'ServiceTime', '8.3');
set_param('UberSpurs/toSpur2', 'NumberOfServers', '20', 'ServiceTime', '8.3');
set_param('UberSpurs/toSpur3', 'NumberOfServers', '20', 'ServiceTime', '8.3');

set_param('UberSpurs/toBagger1', 'NumberOfServers', '30', 'ServiceTime', '12.1');
set_param('UberSpurs/toBagger2', 'NumberOfServers', '30', 'ServiceTime', '12.1');
set_param('UberSpurs/toBagger3', 'NumberOfServers', '30', 'ServiceTime', '12.1');
set_param('UberSpurs/toBagger4', 'NumberOfServers', '30', 'ServiceTime', '12.1');

set_param('UberSpurs/toCapping', 'NumberOfServers', '25', 'ServiceTime', '10.4');
set_param('UberSpurs/fromBaggers', 'NumberOfServers', '13', 'ServiceTime', '5.3');
 
%% Set the parameters for Spurs

% Set Fill and Verify Time
for jj = 1:3
    for ii = 1:18
        set_param(strcat('UberSpurs/spur', num2str(jj), 'WorkCell/fillChannel', num2str(ii),'/processTime'), 'meanNorm', '12', 'stdNorm', '0.6');
    end
    set_param(strcat('UberSpurs/spur', num2str(jj), 'WorkCell/verifyWorkstation/VerifyServer'), 'ServiceTime', '1.55');
end

% Set capacity and travel time of on spur MHS
for jj = 1:3
    for ii = 1:18
    set_param(strcat('UberSpurs/spur', num2str(jj), 'WorkCell/toChannel', num2str(ii)), 'NumberOfServers', '2', 'ServiceTime', '0.8');
    end
    for ii = 1:17
    set_param(strcat('UberSpurs/spur', num2str(jj), 'WorkCell/toVerify', num2str(ii)), 'NumberOfServers', '2', 'ServiceTime', '0.8');
    end
    set_param(strcat('UberSpurs/spur', num2str(jj), 'WorkCell/toChannel'), 'NumberOfServers', '15', 'ServiceTime', '6');
    set_param(strcat('UberSpurs/spur', num2str(jj), 'WorkCell/toRecirculate'), 'NumberOfServers', '3', 'ServiceTime', '1');
    set_param(strcat('UberSpurs/spur', num2str(jj), 'WorkCell/toVerify'), 'NumberOfServers', '12', 'ServiceTime', '5');
end

% Set 'constant' value that each routing control uses
for jj = 1:3
    for ii = 1:18
        try
            set_param(strcat('UberSpurs/spur', num2str(jj), 'WorkCell/route2Channel', num2str(ii), '/Constant'), 'Value', num2str(ii))
        end
    end
end

