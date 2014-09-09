function instruction = Direction(Map,Route)
instruction = {};
d = 0;
x = [1,0]; % x direction
y = [0,1]; % y direction
% run through the route
for index = 2:numel(Route)-1
    currentRoute = Route{index};
    % define three points
    a = [Map.(Route{index-1}).X, Map.(Route{index-1}).Y];
    b = [Map.(currentRoute).X, Map.(currentRoute).Y];
    c = [Map.(Route{index+1}).X, Map.(Route{index+1}).Y];
    v1 = (b-a);
    v1 = v1/sqrt(sum(v1.^2));% normalize direction vector
    v2 = (c-b);
    v2 = v2/sqrt(sum(v2.^2));
    theta = acosd(sum(v1.*v2)/(sqrt(sum(v1.^2))*sqrt(sum(v2.^2))));
    if theta < 30  % go straight
        d = d + Map.(currentRoute).children.(Route{index+1}).cost;
    else %turning
        % give direction for straight route
        if d > 0
            dstr = num2str(d);
            addins = ['Go straight for ', dstr , 'feet'];
            instruction{numel(instruction)+1} = addins;
            d = 0; % reset route distance
        end
        % decide turn northsouth or turn eastwest
        if acosd(sum(v1.*y)) > 45
            % turn northsouth
            if (v2(2) > v1(2))&&(v2(1)>=0)  % turn north
                ins = 'Left';
            elseif (v1(2) > v2(2))&&(v2(1)>=0)  % turn south
                ins = 'Right';
            elseif (v1(2) > v2(2))&&(v2(1)<=0)
                ins = 'Left';
            elseif (v2(2) > v1(2))&&(v2(1)<=0)
                ins = 'Right';
            end
        elseif acosd(sum(v1.*y)) < 45
            % turn eastwest
            % decide if turn east or west
            if (v2(1) > v1(1))&&(v2(2)>=0)
                ins =  'Right';
            elseif (v2(1) < v1(1))&&(v2(2)>=0)
                ins =  'Left';
            elseif (v2(1) < v1(1))&&(v2(2)<=0)
                ins = 'Right';
            elseif (v2(1) > v1(1))&&(v2(2)<=0)
                ins = 'Left';
            end
        end
        d = d + Map.(currentRoute).children.(Route{index+1}).cost;
        ins = ['Turn ' ins];
        instruction{numel(instruction)+1} = ins;
    end
end
if d > 0
            dstr = num2str(d);
            addins = ['Go straight for ', dstr , 'feet'];
            instruction{numel(instruction)+1} = addins;
instruction{numel(instruction)+1} = 'Destination!';
end