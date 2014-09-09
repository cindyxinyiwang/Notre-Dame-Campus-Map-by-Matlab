function name=pointButtonDown(hp,SpecAxes)
        name=get(hp,'DisplayName');
        %set(handles.CurrentSelected,'String',name);
        disp(name)
        
Map = getappdata(gcf,'Map');
HighlightOnePoint(Map,name,SpecAxes);