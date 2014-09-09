function DisplayBackground(SpecAxes)

ylimits = get(SpecAxes,'ylim');
xlimits = get(SpecAxes,'xlim');

if getappdata(gcf,'FirstBackground')
    setappdata(gcf,'FirstBackground',false)
else
    setappdata(gcf,'window',[xlimits,ylimits])
end

cla(SpecAxes)
hold(SpecAxes,'on')

Background = imread('Background.png','png');
x = [-3115.3089,3364.8159];
y = [2177.5893,-3446.5962];
hImage = image(x,y,Background);

set(hImage,'HitTest','Off');