function [CleanRoute,NodeList] = Directions(Map,Route)
distancelimit = 10;

firststep = true;
newtheta = 0;
currentnode = Route{1};
X = Map.(currentnode).X;
Y = Map.(currentnode).Y;
CleanRoute = {};
NodeList = {};
lastdistance = 0;
for n = 1:(numel(Route)-1)
    lastnode = currentnode;
    currentnode = Route{1+n};
    if ~firststep
        olderX = oldX;
        olderY = oldY;
    end
    oldX = X;
    oldY = Y;
    X = Map.(currentnode).X;
    Y = Map.(currentnode).Y;
    oldtheta = newtheta;
    distance = round(sqrt((X-oldX)^2+(Y-oldY)^2));
    if distance < distancelimit
        X = oldX;
        Y = oldY;
        currentnode = lastnode;
    else
        %direction in degrees, counterclockwise from right
        newpseudotheta = atand((Y-oldY)/(X-oldX));
        %correct negative x values.
        if X-oldX < 0
            newtheta = newpseudotheta + 180;
        else
            newtheta = newpseudotheta;
        end
        pseudotheta = 90 + newtheta - oldtheta;
        % make all angles positive
        if pseudotheta < 0
            theta = pseudotheta + 360;
        elseif pseudotheta > 360
            theta = pseudotheta - 360;
        else
            theta = pseudotheta;
        end
        if firststep
            forward = true;
            DistString = [num2str(lastdistance),' feet.'];
            theta = theta - 90;
            if 22.5 < theta && theta < 67.5
                Step = 'Go northeast for ';
            elseif 67.5 < theta && theta < 112.5
                Step = 'Go north for ';
            elseif 112.5 < theta && theta < 157.5
                Step = 'Go northwest for ';
            elseif 157.5 < theta && theta < 202.5
                Step = 'Go west for ';
            elseif 202.5 < theta && theta < 247.5
                Step = 'Go southwest for ';
            elseif 247.5 < theta && theta < 292.5
                Step = 'Go south for ';
            elseif 292.5 < theta && theta < 337.5
                Step = 'Go southeast for ';
            else
                Step = 'Go east for ';
            end
            NodeList = [NodeList;{currentnode}];
            LastStep = Step;
            firststep = false;
        else
            lastdistance = lastdistance + distance;
            forward = false;
            DistString = [num2str(lastdistance),' feet.'];
            if 15 < theta && theta < 50
                Step = 'Turn slightly to the right, then go ';
            elseif 50 < theta && theta < 130
                forward = true;
            elseif 130 < theta && theta < 165
                Step = 'Turn slightly to the left, then go ';
            elseif 165 < theta && theta < 202.5
                Step = 'Turn left, then go ';
            elseif 202.5 < theta && theta < 247.5
                Step = 'Make a sharp left turn, then go ';
            elseif 247.5 < theta && theta < 292.5
                Step = 'Turn around, then go ';
            elseif 292.5 < theta && theta < 337.5
                Step = 'Make a sharp right turn, then go ';
            else
                Step = 'Turn right, then go ';
            end
        end
        if ~forward
            CleanRoute = [CleanRoute,{[LastStep,DistString]}];
            LastStep = Step;
            lastdistance = 0;
            NodeList = [NodeList;{currentnode}];
        end
    end
end
if strcmp(Route(numel(Route)),'NotreDameStadium')
    CleanRoute = [CleanRoute,{'Go Irish!!!!'}];
    NodeList = [NodeList;{'NotreDameStadium'}];
end