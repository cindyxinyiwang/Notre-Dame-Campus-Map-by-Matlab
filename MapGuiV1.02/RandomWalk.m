function [Route, TotalCost] = RandomWalk(Map, Source, Destination)
%initialize clock
starttime = clock;

TotalCost = 0;
closed_set = {Source};
current_node = Source;
goal_node = Destination;
path = {Source};
while ~strcmp(current_node,goal_node)
    child_nodes = children(Map,current_node);
    available_children = {};
    for index = 1:numel(child_nodes)
        current_child = child_nodes{index};
        if sum(strcmp(current_child,closed_set))==0
            available_children = [available_children,{current_child}];
        end
    end
    previous_node = current_node;
    if numel(available_children)==0
        pos = randi(numel(child_nodes));
        closed_set = {current_node};
        current_node = child_nodes{pos};
    else
        pos = randi(numel(available_children));
        current_node = available_children{pos};
    end
    path = [path,{current_node}];
    TotalCost = Map.(previous_node).children.(current_node).cost+TotalCost;
end
Route = path;

%display elapsed time
elapsedtime = clock - starttime;
elapsedseconds = sum(elapsedtime.*...
    [31557600,2629800,86400,3600,60,1]);
disp(['Random Walk algorithm         ',...
    num2str(elapsedseconds),' seconds'])



function list = children(Map,Parent)
list = transpose(fieldnames(Map.(Parent).children));