function HighlightOnePoint(MapStruct,NodeName,SpecAxes)
%initialize clock
starttime = clock;

%record dimensions of map
ylimits = get(SpecAxes,'ylim');
xlimits = get(SpecAxes,'xlim');
%get the handle of the point
p = getappdata(gcf,'HighlightedPointHandle');
hold(SpecAxes,'on')
if strcmp(NodeName,'ZoomChange') && p == -10
    %DO NOTHING
elseif p == -10
    X = MapStruct.(NodeName).X;
    Y = MapStruct.(NodeName).Y;
    theta = linspace(0, 2*pi, 30);
    %scale r to axis size
    r = (xlimits(2)-xlimits(1))/100;
    %r = 30;
    Xaround = r * cos(theta) + X;
    Yaround = r * sin(theta) + Y;
    p = patch(Xaround,Yaround,'k','Parent',SpecAxes);
    setappdata(gcf,'HighlightedPointHandle',p)
    setappdata(gcf,'HighlightedPointX',X)
    setappdata(gcf,'HighlightedPointY',Y)
    setappdata(gcf,'HighlightedPointName',NodeName)
elseif strcmp(NodeName,'ZoomChange')
    X = getappdata(gcf,'HighlightedPointX');
    Y = getappdata(gcf,'HighlightedPointY');
    theta = linspace(0, 2*pi, 30);
    %scale r to axis size
    r = (xlimits(2)-xlimits(1))/100;
    %r = 30;
    Xaround = r * cos(theta) + X;
    Yaround = r * sin(theta) + Y;
    set(p,'X',Xaround)
    set(p,'Y',Yaround)
    setappdata(gcf,'HighlightedPointX',X)
    setappdata(gcf,'HighlightedPointY',Y)
else
    oldX = getappdata(gcf,'HighlightedPointX');
    oldY = getappdata(gcf,'HighlightedPointY');
    X = MapStruct.(NodeName).X;
    Y = MapStruct.(NodeName).Y;
    set(p,'X',(get(p,'X')-oldX+X))
    set(p,'Y',(get(p,'Y')-oldY+Y))
    setappdata(gcf,'HighlightedPointX',X)
    setappdata(gcf,'HighlightedPointY',Y)
    setappdata(gcf,'HighlightedPointName',NodeName)
end

hold(SpecAxes,'off')
axis(SpecAxes,[xlimits, ylimits])

%display elapsed time
elapsedtime = clock - starttime;
elapsedseconds = sum(elapsedtime.*...
    [31557600,2629800,86400,3600,60,1]);
disp(['Displaying selected point     ',...
    num2str(elapsedseconds),' seconds'])