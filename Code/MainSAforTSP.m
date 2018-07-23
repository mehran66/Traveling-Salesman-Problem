%In the name of God
%% Start of the program.
clc
clear
close all

%% Problem Statement (Traveling Sealsman Problem)
Random = 0;
CityNum = 10;
if Random == 1
    XCity = rand(1,CityNum);
    YCity = rand(1,CityNum);
else
    XCity = [0.1 0.2 0.1 0.6 0.3 0.7 0.8 0.6 0.5 0.6];
    YCity = [0.1 0.2 0.7 0.8 0.1 0.2 0.9 0.6 0.5 0.5];
end

CityDistanceMatrix = CityDistanceMatrix_Fcn(XCity,YCity);

%% Algoritm Parameters
InitialTemperature =4000;
CoolingRate = .970;
MaxIteration= 10000;
Temperature =InitialTemperature;
%% Initialization
Current_Tour=sort(randperm(CityNum));
Current_Cost=CalculateTourDistance_Fcn(Current_Tour,CityDistanceMatrix,CityNum);
Best_Tour=Current_Tour;
Best_Cost(1)=Current_Cost;
%% MAIN LOOP
Iter=1;
t=1;
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
        if Current_Cost <= Best_Cost(t) 
            t=t+1;
            Best_Tour=Current_Tour;
            Best_Cost(t)=Current_Cost;
        end
     Current_C(Iter)=Current_Cost;
     Iter=Iter+1;
end
%% Final Result Display
Best_Tour
Best_Cost
plot(1:numel( Current_C), Current_C,'r')
hold on
plot(1:numel(Best_Cost),Best_Cost)