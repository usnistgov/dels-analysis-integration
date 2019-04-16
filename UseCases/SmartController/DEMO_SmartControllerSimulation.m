%% Products and Process Definitions



prod1 = ProductX001

%proc1 is a 'MakeProdX'-type process -- the 'top-level' process encapsulating all of the information
%   required to make ProductX. This doesn't typically have a specific class definition.

proc1 = prod1.processPlan



% The process steps can be accessed in two different ways
%   1) Process has a property called 'processSteps' that is the derivedUnion of its o
%       operations properties, e.g. op10, op20, etc.
%   2) Process has separate 'operations' properties for each process step



proc1.processSteps