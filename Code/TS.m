function varargout = TS(varargin)
% TS M-file for TS.fig
%      TS, by itself, creates a new TS or raises the existing
%      singleton*.
%
%      H = TS returns the handle to a new TS or the handle to
%      the existing singleton*.
%
%      TS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TS.M with the given input arguments.
%
%      TS('Property','Value',...) creates a new TS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TS

% Last Modified by GUIDE v2.5 28-Nov-2010 04:10:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TS_OpeningFcn, ...
                   'gui_OutputFcn',  @TS_OutputFcn, ...
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


% --- Executes just before TS is made visible.
function TS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TS (see VARARGIN)
clc;
% Choose default command line output for TS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on button press in btnCreatNetwork.
function btnCreatNetwork_Callback(hObject, eventdata, handles)
% hObject    handle to btnCreatNetwork (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CityNum XCity YCity
CityNum = str2double(get(handles.edit4,'String'));
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
MaxIteration=str2double(get(handles.edit1,'string'));
TabuTenure=str2double(get(handles.edit2,'string'));


CityDistanceMatrix = CityDistanceMatrix_Fcn(XCity,YCity);

%% Initialization
Current_Tour=sort(randperm(CityNum));
Current_Cost=CalculateTourDistance_Fcn(Current_Tour,CityDistanceMatrix,CityNum);
Best_Tour=Current_Tour;
Best_Cost=Current_Cost;
%% MAIN LOOP
Tabu(CityNum,CityNum)=[0];
Iter=1;
t=true;
 CurrentMat=[];
 BestMat=[];
while Iter~=MaxIteration && t
    counter=1;
    for ii=1:CityNum-1
        for jj=ii+1:CityNum
            temp=Current_Tour;
            temp1=Current_Tour(ii);
            temp2=Current_Tour(jj);
            temp(ii)=temp2;
            temp(jj)=temp1;
            Neighbor_Tour(counter,:)=temp;
            Offset(counter,1)=ii;
            Offset(counter,2)=jj;
            counter=counter+1;
        end
    end
    for ii=1:counter-1
         Neighbor_Cost(ii)=CalculateTourDistance_Fcn( Neighbor_Tour(ii,:),CityDistanceMatrix,CityNum);
    end
    [Neighbor_Cost Index]=sort(Neighbor_Cost);
    Neighbor_Tour=Neighbor_Tour(Index,:);
    Offset=Offset(Index,:);
    for ii=1:length(Neighbor_Cost)
        if   Neighbor_Cost(ii)< Current_Cost
            if Tabu(Offset(ii,1),Offset(ii,2))<=0
                Current_Tour = Neighbor_Tour (ii,:);
                Current_Cost = Neighbor_Cost(ii) ;
                Tabu(Offset(ii,1),Offset(ii,2))= TabuTenure ;
                break;
            
            elseif   Tabu(Offset(ii,1),Offset(ii,2))>0
                if Neighbor_Cost(ii) < Best_Cost
                Current_Tour = Neighbor_Tour (ii,:);
                Current_Cost = Neighbor_Cost(ii) ;
                Tabu(Offset(ii,1),Offset(ii,2))= TabuTenure ;
                break;
                end
            end
        end
         if ii==length(Neighbor_Cost)
             t=0;
         end
    end
    if Current_Cost < Best_Cost
        Best_Tour=Current_Tour;
        Best_Cost=Current_Cost;
    end
    Tabu=Tabu-1;
    Iter=Iter+1;
     %% Display
        shg
        pause(0.0005)
        plot(handles.axes1,XCity(Current_Tour),YCity(Current_Tour),'r-p')
        drawnow;
        
            %% Display
     CurrentMat=[CurrentMat Current_Cost];
     BestMat=[BestMat Best_Cost];
     shg
        plot(handles.axes2,CurrentMat,'r','linewidth',2.5);
        hold on
        plot(handles.axes2,BestMat,'b','linewidth',2);
    drawnow;
end
%% Final Result Display
       Best_Tour
       Best_Cost


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
