function DisplayBackground(SpecAxes)


cla(SpecAxes)
hold(SpecAxes,'on')

Background = imread('Background.png','png');
x = [-3155.3089,3324.8159];
y = [2217.5883,-3416.5962];
hImage = image(x,y,Background);

set(hImage,'HitTest','Off');