Warehouse1 = DELS;
f1 = Facility;
Warehouse1.Facility = f1;
c1 = Controller;
s1 = Scheduling_ClarkWrightVRP;
c1.SchedulingStrategy(s1);
Warehouse1.addController(c1);


Warehouse1.ResourceSet(5) = Resource;

TaskList(1000) = Task;
for i = 1:1000
    TaskList(i).Task_ID = i;
    TaskList(i).RequiredResourceState = [100*rand(1), 100*rand(1)];
    %TaskList(i).CapacityRequirement = 1;
    TaskList(i).CapacityRequirement = randi(5);
end

Warehouse1.Controller.Scheduling(TaskList);
disp('Complete.');
