%modified from original to accept a SpecAxes argument to
%specify a set of axes.
function DisplayMap(MapStruct,SpecAxes)
%initialize clock
starttime = clock;

%clear axes, hold on
hold(SpecAxes,'on')
%
set(SpecAxes, 'DrawMode', 'fast')
%

PointsArray = fieldnames(MapStruct);
for index = 1:numel(PointsArray)
    %get info on current point
    CurrentPoint = PointsArray{index};
    X = MapStruct.(CurrentPoint).X;
    Y = MapStruct.(CurrentPoint).Y;
    %get points already covered
    PointsSoFar = PointsArray{1:index};
    %loop through all children
    ChildrenNames = fieldnames(MapStruct.(CurrentPoint).children);
    for index2 = 1:numel(ChildrenNames)
        ChildPoint = ChildrenNames{index2};
        %runs for every link twice
        %limit to only once
        if sum(strcmp(PointsSoFar,ChildPoint))==0
            %only runs once for each link
            ChildX = MapStruct.(ChildPoint).X;
            ChildY = MapStruct.(ChildPoint).Y;
            %show black if is inside
            if MapStruct.(CurrentPoint).children.(ChildPoint).isOutside
                line([X,ChildX],[Y,ChildY],'Parent',SpecAxes,...
                    'Color','b','HitTest','off')
            else
                line([X,ChildX],[Y,ChildY],'Parent',SpecAxes,...
                    'Color','k','HitTest','off')
            end
        end
    end
    hLine = line(X,Y,'Parent',SpecAxes,'MarkerEdgeColor','r','Marker','o',...
        'DisplayName',PointsArray{index});
    set(hLine,'ButtonDownFcn',@(s,e) pointButtonDown(hLine,SpecAxes))
end
%
%set(SpecAxes, 'HitTest', 'off')
%
hold(SpecAxes,'off')
axis(SpecAxes,'equal')

%display elapsed time
elapsedtime = clock - starttime;
elapsedseconds = sum(elapsedtime.*...
    [31557600,2629800,86400,3600,60,1]);
disp(['Displaying map                ',...
    num2str(elapsedseconds),' seconds'])