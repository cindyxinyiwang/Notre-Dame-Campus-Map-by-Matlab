function varargout = MapGui(varargin)
% MAPGUI MATLAB code for MapGui.fig
%      MAPGUI, by itself, creates a new MAPGUI or raises the existing
%      singleton*.
%
%      H = MAPGUI returns the handle to a new MAPGUI or the handle to
%      the existing singleton*.
%
%      MAPGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAPGUI.M with the given input arguments.
%
%      MAPGUI('Property','Value',...) creates a new MAPGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MapGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MapGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MapGui

% Last Modified by GUIDE v2.5 17-Apr-2014 16:46:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MapGui_OpeningFcn, ...
                   'gui_OutputFcn',  @MapGui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before MapGui is made visible.
function MapGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MapGui (see VARARGIN)

% Choose default command line output for MapGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MapGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%INITIALIZE CLOCK
starttime = clock;
%INITIALIZE CLOCK
%CHANGE TITLE
set(gcf,'name','ND Map')
%CHANGE TITLE
% LOAD BUILDING NAMES
load('BuildingNames.mat','BuildingNames')
load('BuildingNamesPretty.mat','BuildingNamesPretty')
setappdata(gcf,'BuildingList',BuildingNamesPretty);
setappdata(gcf,'BuildingListNodeNames',BuildingNames);
% LOAD BUILDING NAMES
% LOAD MAP DATA FROM FILE
load('Map.mat','Map')
setappdata(gcf,'Map',Map)
%Map can be accessed using getappdata(gcf,'Map')
% LOAD MAP DATA FROM FILE
% SET SELECTION BOXES TO INITIAL DATA
%can use Map to get the map because already loaded.
set(handles.SourceSelector,'String',...
    [getappdata(gcf,'BuildingList');{'(Selected node)'}])
set(handles.DestinationSelector,'String',...
    [getappdata(gcf,'BuildingList');{'(Selected node)'}])
% SET SELECTION BOXES TO INITIAL DATA
%DISPLAY BACKGROUND
%RECORD THAT IS FIRST DISPLAY OF BACKGROUND
setappdata(gcf,'FirstBackground',true)
DisplayBackground(handles.Map)
%DISPLAY BACKGROUND
% DISPLAY MAP
DisplayMap(Map,handles.Map)
% DISPLAY MAP
% RECORD THAT FIRST CALCULATION HAS NOT BEEN DONE YET
setappdata(gcf,'RoutedYet',0)
% RECORD THAT FIRST CALCULATION HAS NOT BEEN DONE YET
% SET INITIAL DUMMY VALUE FOR HANDLE OF SELECTED POINT
setappdata(gcf,'HighlightedPointHandle',-10)
setappdata(gcf,'HighlightedPointName','NONE')
% SET INITIAL DUMMY VALUE FOR HANDLE OF SELECTED POINT
%DISPLAY ELAPSED TIME
elapsedtime = clock - starttime;
elapsedseconds = sum(elapsedtime.*...
    [31557600,2629800,86400,3600,60,1]);
disp(['Total Initialization Time:    ',...
    num2str(elapsedseconds),' seconds'])
%DISPLAY ELAPSED TIME
%ENABLE PANNING
pan on
setappdata(gcf,'PanIsOn',true)
%ENABLE PANNING

% --- Outputs from this function are returned to the command line.
function varargout = MapGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ZoomInButton.
function ZoomInButton_Callback(hObject, eventdata, handles)
% hObject    handle to ZoomInButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pan(handles.Map,'on')
zoom(handles.Map,1.25)
if ~getappdata(gcf,'PanIsOn')
    pan(handles.Map,'off')
end
Map = getappdata(gcf,'Map');
HighlightOnePoint(Map,'ZoomChange',handles.Map);

% --- Executes on button press in ZoomOutButton.
function ZoomOutButton_Callback(hObject, eventdata, handles)
% hObject    handle to ZoomOutButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pan(handles.Map,'on')
zoom(handles.Map,.8)
if ~getappdata(gcf,'PanIsOn')
    pan(handles.Map,'off')
end
Map = getappdata(gcf,'Map');
HighlightOnePoint(Map,'ZoomChange',handles.Map);

% --- Executes on button press in ResetButton.
function ResetButton_Callback(hObject, eventdata, handles)
% hObject    handle to ResetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pan(handles.Map,'on')
zoom(handles.Map,'out')
if ~getappdata(gcf,'PanIsOn')
    pan(handles.Map,'off')
end
Map = getappdata(gcf,'Map');
HighlightOnePoint(Map,'ZoomChange',handles.Map);

% --- Executes on button press in RandomWalkRadio.
function RandomWalkRadio_Callback(hObject, eventdata, handles)
% hObject    handle to RandomWalkRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RandomWalkRadio


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on slider movement.
function WeatherSlider_Callback(hObject, eventdata, handles)
% hObject    handle to WeatherSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.WeatherText,'String',num2str(get(handles.WeatherSlider,'Value')));

% --- Executes during object creation, after setting all properties.
function WeatherSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WeatherSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function WeatherText_Callback(hObject, eventdata, handles)
% hObject    handle to WeatherText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WeatherText as text
%        str2double(get(hObject,'String')) returns contents of WeatherText as a double
set(handles.WeatherSlider,'Value',str2double(get(handles.WeatherText,'String')));

% --- Executes during object creation, after setting all properties.
function WeatherText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WeatherText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SourceSelector.
function SourceSelector_Callback(hObject, eventdata, handles)
% hObject    handle to SourceSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SourceSelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SourceSelector

%initialize clock
starttime = clock;
disp(' ')
disp(' ')
disp('Calculation Times:')
disp('___________________________________________')

Map = getappdata(gcf,'Map');
BuildingList = getappdata(gcf,'BuildingListNodeNames');
NodeNumber = get(handles.SourceSelector,'Value');
if NodeNumber > numel(BuildingList)
    % is selected point
    NodeName = getappdata(gcf,'HighlightedPointName');
else
    NodeName = BuildingList{NodeNumber};
end
HighlightOnePoint(Map,NodeName,handles.Map)

%display elapsed time
elapsedtime = clock - starttime;
elapsedseconds = sum(elapsedtime.*...
    [31557600,2629800,86400,3600,60,1]);
disp('                              _____________')
disp(['Total                         ',...
    num2str(elapsedseconds),' seconds'])

% --- Executes during object creation, after setting all properties.
function SourceSelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SourceSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in RouteList.
function RouteList_Callback(hObject, eventdata, handles)
% hObject    handle to RouteList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns RouteList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RouteList

%initialize clock
starttime = clock;
disp(' ')
disp(' ')
disp('Calculation Times:')
disp('___________________________________________')

Map = getappdata(gcf,'Map');
% make sure first calculation has been done
if getappdata(gcf,'RoutedYet')==1
    NodeNumber = get(handles.RouteList,'Value');
    NodeList = getappdata(gca,'InstNodes');
    NodeName = NodeList{NodeNumber};
    HighlightOnePoint(Map,NodeName,handles.Map)
end

%display elapsed time
elapsedtime = clock - starttime;
elapsedseconds = sum(elapsedtime.*...
    [31557600,2629800,86400,3600,60,1]);
disp('                              _____________')
disp(['Total                         ',...
    num2str(elapsedseconds),' seconds'])

% --- Executes during object creation, after setting all properties.
function RouteList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RouteList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in DestinationSelector.
function DestinationSelector_Callback(hObject, eventdata, handles)
% hObject    handle to DestinationSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DestinationSelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DestinationSelector

%initialize clock
starttime = clock;
disp(' ')
disp(' ')
disp('Calculation Times:')
disp('___________________________________________')

Map = getappdata(gcf,'Map');
BuildingList = getappdata(gcf,'BuildingListNodeNames');
NodeNumber = get(handles.DestinationSelector,'Value');
if NodeNumber > numel(BuildingList)
    % is selected point
    NodeName = getappdata(gcf,'HighlightedPointName');
else
    NodeName = BuildingList{NodeNumber};
end
HighlightOnePoint(Map,NodeName,handles.Map)

%display elapsed time
elapsedtime = clock - starttime;
elapsedseconds = sum(elapsedtime.*...
    [31557600,2629800,86400,3600,60,1]);
disp('                              _____________')
disp(['Total                         ',...
    num2str(elapsedseconds),' seconds'])

% --- Executes during object creation, after setting all properties.
function DestinationSelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DestinationSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CalculateButton.
function CalculateButton_Callback(hObject, eventdata, handles)
% hObject    handle to CalculateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%initialize clock
starttime = clock;
disp(' ')
disp(' ')
disp('Calculation Times:')
disp('___________________________________________')

Map = getappdata(gcf,'Map');
BuildingList = getappdata(gcf,'BuildingListNodeNames');
SourcePos = get(handles.SourceSelector,'Value');
if SourcePos > numel(BuildingList)
    % is selected point
    Source = getappdata(gcf,'HighlightedPointName');
else
    Source = BuildingList{SourcePos};
end
DestPos = get(handles.DestinationSelector,'Value');
if DestPos > numel(BuildingList)
    % is selected point
    Destination = getappdata(gcf,'HighlightedPointName');
else
    Destination = BuildingList{DestPos};
end
% choose whether to use weather
if get(handles.checkbox2,'Value')
    factor = 10^get(handles.WeatherSlider,'Value');
    Map2 = AddWeather(Map,factor);
else
    Map2 = Map;
end
%choose which algorithm to run
%CHANGE TITLE
set(gcf,'name','ND Map')
%CHANGE TITLE
if strcmp(Source,'Basilica') && strcmp(Destination,'DomeStairs')
    %CHANGE TITLE
    set(gcf,'name','Crazy ND Map')
    %CHANGE TITLE
    [Route,Cost] = RandomWalk(Map2,Source,Destination);
elseif get(handles.AStarRadio,'Value')
    [Route,Cost] = AStar(Map2,Source,Destination);
elseif get(handles.DijkstraRadio,'Value')
    [Route,Cost] = Dijkstras(Map2,Source,Destination);
else
    errormessage = ['There is no routing algorithm selected!\n',...
        'You have somehow broken all computer logic!\n',...
        'This should be impossible!\n',...
        'You should never see this message!'];
    error('ERROR:ERROR',errormessage)
end
% give direction 
[instruction,InstructNodes] = Directions(Map, Route);
distance = 0;
for index = 1:(numel(Route)-1)
    distance = round(distance+Map.(Route{index}).children.(Route{index+1}).cost);
end
set(handles.distanceText,'String',num2str(distance));
set(handles.RouteList,'String',instruction)
setappdata(gca,'InstNodes',InstructNodes)
DisplayBackground(handles.Map)
DisplayMap(Map,handles.Map)
HighlightOnMap(Route,Map,handles.Map)
% record that first calculation has now been done
setappdata(gcf,'RoutedYet',1)
%reset position in RouteList
set(handles.RouteList,'Value',1)
% SET INITIAL DUMMY VALUE FOR HANDLE OF SELECTED POINT
setappdata(gcf,'HighlightedPointHandle',-10)
% SET INITIAL DUMMY VALUE FOR HANDLE OF SELECTED POINT
% REPLOT SELECTED POINT
point = getappdata(gcf,'HighlightedPointName');
if ~strcmp(point,'NONE')
    HighlightOnePoint(Map,point,handles.Map);
end
% REPLOT SELECTED POINT

%display elapsed time
elapsedtime = clock - starttime;
elapsedseconds = sum(elapsedtime.*...
    [31557600,2629800,86400,3600,60,1]);
disp('                              _____________')
disp(['Total                         ',...
    num2str(elapsedseconds),' seconds'])

% display cost
disp(['Route Length:    ',num2str(Cost),' feet'])


% --- Executes on button press in SelectPointsCheckbox.
function SelectPointsCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to SelectPointsCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SelectPointsCheckbox
if get(handles.SelectPointsCheckbox,'Value')
    % select points is on
    setappdata(gcf,'PanIsOn',false)
    pan(handles.Map,'off')
else
    % select points is off
    setappdata(gcf,'PanIsOn',true)
    pan(handles.Map,'on')
end
function distanceText_Callback(hObject, eventdata, handles)
% hObject    handle to distanceText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of distanceText as text
%        str2double(get(hObject,'String')) returns contents of distanceText as a double


% --- Executes during object creation, after setting all properties.
function distanceText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distanceText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
