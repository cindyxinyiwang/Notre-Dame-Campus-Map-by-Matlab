function MapStruct = AddWeather(MapStruct,fac)
NodeNames = fieldnames(MapStruct);
Num = numel(NodeNames); % number of nodes
for index = 1: Num % go through every node and check if inside
    currentNode = NodeNames{index};
    childnames = fieldnames(MapStruct.(currentNode).children);
    nodesSofar = NodeNames{1:index};
    % run through the children
    for index2 = 1: numel(childnames)
        currentchild = childnames{index2};
        % XXdon't add factor to cost already added
        % add anyway - it should only go through these once
        %if sum(strcmp(nodesSofar,currentchild)) == 0
            if MapStruct.(currentNode).children.(currentchild).isOutside == 1
                MapStruct.(currentNode).children.(currentchild).cost = fac * MapStruct.(currentNode).children.(currentchild).cost;
            end
        %end
    end
end