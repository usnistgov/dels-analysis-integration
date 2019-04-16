function [idx, availableTasks] = Sequencing(availableTasks)
%SEQUENCING Summary of this function goes here
%   Detailed explanation goes here

if ~isempty(availableTasks)
    %sortrows throws an error if array is empty
    
    %call sequencing
    [~,I] = sortrows(availableTasks, [4,5,2]);
    %assign priority to available tasks
    availableTasks(:,1) = I;
    %find #1 priority
    [~, J] = min(I);
    % set inx to unique key of #1 priority -- 3rd data item is it's ID
    idx = availableTasks(J,3);
    %remove task from available Tasks
    availableTasks(J,:) = [];
    
    %Teturn task list back to base.
    assignin('base', 'availableTasks', availableTasks)
else
    idx = 0;
end

end

