function varargout = SA(varargin)
% SA M-file for SA.fig
%      SA, by itself, creates a new SA or raises the existing
%      singleton*.
%
%      H = SA returns the handle to a new SA or the handle to
%      the existing singleton*.
%
%      SA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SA.M with the given input arguments.
%
%      SA('Property','Value',...) creates a new SA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SA

% Last Modified by GUIDE v2.5 28-Nov-2010 03:18:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SA_OpeningFcn, ...
                   'gui_OutputFcn',  @SA_OutputFcn, ...
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


% --- Executes just before SA is made visible.
function SA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SA (see VARARGIN)
clc;
% Choose default command line output for SA
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SA wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SA_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in btnCreateNetwork.
function btnCreateNetwork_Callback(hObject, eventdata, handles)
% hObject    handle to btnCreateNetwork (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CityNum XCity YCity
CityNum = str2double(get(handles.edit1,'String'));
    XCity = rand(1,CityNum);
    YCity = rand(1,CityNum);
plot (handles.axes1,XCity,YCity,'bo','MarkerSize',15,'MarkerEdgeColor','k','MarkerFaceColor','g');

% --- Executes on button press in btnResetNetwork.
function btnResetNetwork_Callback(hObject, eventdata, handles)
% hObject    handle to btnResetNetwork (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=[1];y=[1];
plot (handles.axes1,x,y);
hold off
plot (handles.axes2,x,y);
% --- Executes on button press in btnStart.
function btnStart_Callback(hObject, eventdata, handles)
% hObject    handle to btnStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CityNum XCity YCity
MaxIteration=str2double(get(handles.edit2,'string'));
CoolingRate=str2double(get(handles.edit4,'string'));
InitialTemperature=str2double(get(handles.edit3,'string'));

CityDistanceMatrix = CityDistanceMatrix_Fcn(XCity,YCity);
Temperature =InitialTemperature;
%% Initialization
Current_Tour=sort(randperm(CityNum));
Current_Cost=CalculateTourDistance_Fcn(Current_Tour,CityDistanceMatrix,CityNum);
Best_Tour=Current_Tour;
Best_Cost(1)=Current_Cost;
%% MAIN LOOP
Iter=1;
t=1;
 CurrentMat=[];
 BestMat=[];
while Iter~=MaxIteration || Temperature <= 0
    while true
        r1=floor(rand(1)*(CityNum)+1);
        r2=floor(rand(1)*(CityNum)+1);
        temp1=Current_Tour(r1);
        temp2=Current_Tour(r2);
        Neighbor_Tour=Current_Tour;
        Neighbor_Tour(r1)=temp2;
        Neighbor_Tour(r2)=temp1;
        Neighbor_Cost=CalculateTourDistance_Fcn( Neighbor_Tour,CityDistanceMatrix,CityNum);
        if   Neighbor_Cost <= Current_Cost 
            Current_Tour = Neighbor_Tour;
            break;
        elseif exp(-(Neighbor_Cost-Current_Cost)/Temperature) > random('uniform',0,1)
            Current_Tour = Neighbor_Tour;
            break;
        else 
            continue;
        end
    end
        Temperature=Temperature*CoolingRate;
        Current_Cost=CalculateTourDistance_Fcn(Current_Tour,CityDistanceMatrix,CityNum);
        if Current_Cost <= Best_Cost(Iter) 
           
            Best_Tour=Current_Tour;
            Best_Cost(Iter+1)=Current_Cost;
        end
        if Current_Cost > Best_Cost(Iter) 
            
          
            Best_Cost(Iter+1)=Best_Cost(Iter);
        end
     Current_C(Iter)=Current_Cost;
     Iter=Iter+1;
             %% Display
     shg
        pause(0.0005)
        plot(handles.axes1,XCity(Current_Tour),YCity(Current_Tour),'r-p')
    drawnow;
    

    
    %% Display
     CurrentMat=[CurrentMat Current_C(Iter-1)];
     BestMat=[BestMat Best_Cost(Iter-1)];
 shg
    plot(handles.axes2,CurrentMat,'r','linewidth',2.5);
    hold on
    plot(handles.axes2,BestMat,'b','linewidth',2);
drawnow;
end
%% Final Result Display
Best_Tour
Best_Cost(end)




function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
