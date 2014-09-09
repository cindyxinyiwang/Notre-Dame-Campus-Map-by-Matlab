%modified from original to accept a SpecAxes argument to
%specify a set of axes.
function HighlightOnMap(RouteArray,MapStruct,SpecAxes)
%initialize clock
starttime = clock;

%hold on
hold(SpecAxes,'on')

PointsArray = RouteArray;
for index = 2:numel(PointsArray)
    %get info on current point
    CurrentPoint = PointsArray{index-1};
    ChildPoint = PointsArray{index};
    X = MapStruct.(CurrentPoint).X;
    Y = MapStruct.(CurrentPoint).Y;
    ChildX = MapStruct.(ChildPoint).X;
    ChildY = MapStruct.(ChildPoint).Y;
    plot(SpecAxes,[X,ChildX],[Y,ChildY],'-g')
    plot(SpecAxes,X,Y,'g*')
end
if numel(PointsArray)>1
    plot(SpecAxes,ChildX,ChildY,'g*')
end
hold(SpecAxes,'off')
axis(SpecAxes,'equal')
axis(SpecAxes,getappdata(gcf,'window'))

%display elapsed time
elapsedtime = clock - starttime;
elapsedseconds = sum(elapsedtime.*...
    [31557600,2629800,86400,3600,60,1]);
disp(['Displaying route              ',...
    num2str(elapsedseconds),' seconds'])