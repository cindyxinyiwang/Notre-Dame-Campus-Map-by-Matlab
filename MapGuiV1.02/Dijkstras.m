function [Route, TotalCost] = Dijkstras(Map, Source, Destination)
%initialize clock
starttime = clock;

%set all g values to infinity!
all_nodes = fieldnames(Map);
for index = 1:numel(all_nodes)
    node_name = all_nodes{index};
    Map.(node_name).g = Inf;
end
Map.(Source).g = 0;
%get coordinates of destination node.
%DestX = Map.(Destination).X;
%DestY = Map.(Destination).Y;
%closed_set = origin node, with a f value of 0.
closed_set = {Source};
%open_set = all children of Source
%  add source for removal later
open_set = [children(Map,Source),{Source}];
%set current_node = start_node
current_node = Source;
%set goal_node = goal
goal_node = Destination;
%set beginning of path
Map.(Source).path = {Source};
%set path = start_node
path = {Source};
if numel(open_set)>0;
    while ~strcmp(current_node,goal_node)
        %put current_node in closed_set
        closed_set = [closed_set, {current_node}];
        %remove current_node from open_set
        pos = sum(strcmp(open_set,current_node).*...
            linspace(1,numel(open_set),numel(open_set)));
        open_set(pos) = [];
        child_nodes = children(Map,current_node);
        for index = 1:numel(child_nodes)
            current_child = child_nodes{index};
            %check if current_child is not in closed_set
            if sum(strcmp(current_child,closed_set)) == 0
                %check if current_child is not in open_set
                if sum(strcmp(current_child,open_set)) == 0
                    %add current_child to open_set
                    open_set = [open_set, {current_child}];
                end
                %calculate h for current_child
                %Map.(current_child).h = sqrt((Map.(current_child).X-DestX)^2 ...
                %+(Map.(current_child).Y-DestY)^2);
            end
        end
        %calculate g for each child node
        for index = 1:numel(child_nodes)
            current_child = child_nodes{index};
            current_g = Map.(current_node).g+...
                Map.(current_node).children.(current_child).cost;
            if current_g < Map.(current_child).g
                Map.(current_child).g = current_g;
                Map.(current_child).path = [Map.(current_node).path,...
                    {current_child}];
            end
        end
        %choose best next node
        current_best = open_set{1};
        bestF = Map.(current_best).g;
        % + Map.(current_best).h;
        for index = 2:numel(open_set)
            current_test = open_set{index};
            currentF = Map.(current_test).g;
            % + Map.(current_test).h;
            if currentF < bestF
                bestF = currentF;
                current_best = current_test;
            end
        end
        %set current node to best next node
        current_node = current_best;
    end
    %output route info
    Route = Map.(Destination).path;
    TotalCost = Map.(Destination).g;
else
    %ERROR
    error('Source node does not have any child nodes!')
end

%display elapsed time
elapsedtime = clock - starttime;
elapsedseconds = sum(elapsedtime.*...
    [31557600,2629800,86400,3600,60,1]);
disp(['Dijkstra''s algorithm          ',...
    num2str(elapsedseconds),' seconds'])



function list = children(Map,Parent)
list = transpose(fieldnames(Map.(Parent).children));