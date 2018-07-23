%% Start of the program.
clc
clear
close all

%% Problem Statement (Traveling Sealsman Problem)
Random = true;
CityNum = 20;
if Random == 1
    XCity = rand(1,CityNum);
    YCity = rand(1,CityNum);
else
    XCity = [0.1 0.2 0.1 0.6 0.3 0.7 0.8 0.6 0.5 0.6];
    YCity = [0.1 0.2 0.7 0.8 0.1 0.2 0.9 0.6 0.5 0.5];
end

CityDistanceMatrix = CityDistanceMatrix_Fcn(XCity,YCity);

% TourDistance = CalculateTourDistance_Fcn(Tour,CityDistanceMatrix,CityNum);
%% Algoritm Parameters
PopSize = 100;
ChromLenght = CityNum;
KeepPercent = 10/100;
CrossPercent = 60/100;
MutatPercent = 1 - KeepPercent - CrossPercent;
SelectionMode=1;

KeepNum = round(KeepPercent * PopSize);
CrossNum = round(CrossPercent * PopSize);
MutatNum = PopSize - KeepNum - CrossNum;

%% Initial Population
for ii=1:PopSize
   Pop(ii,:)=randperm(CityNum);
end
 Cost=Cost_Fcn(Pop,CityDistanceMatrix,CityNum);
 [Cost Index]=sort(Cost);
 Pop=Pop(Index,:);

%% MAIN LOOP
MaxIteration=100;
MinMat=[];
MeanMat=[];
for Iter = 1:MaxIteration
    %% Select Keep
    KeepPop=Pop(1:KeepNum,:);
    %% CrossOver
    SelectedIndexes=SelectParents_Fcn(Cost,CrossNum,SelectionMode);
   CrossPop=[];
    for ii=1:2:CrossNum
        Par1Index=SelectedIndexes(ii);
        Par2Index=SelectedIndexes(ii+1);
        Par1=Pop(Par1Index,:);
        Par2=Pop(Par2Index,:);
        [Off1,Off2]=CrossOver_Fcn(Par1,Par2);
        CrossPop=[CrossPop;Off1;Off2];
    end
    %% Mutation
   for ii=1:MutatNum
   MutatPop(ii,:)=randperm(CityNum);
   end
      
    %% NewPopulation
    Pop=[KeepPop;CrossPop;MutatPop];
     Cost=Cost_Fcn(Pop,CityDistanceMatrix,CityNum);
     [Cost Index]=sort(Cost);
     Pop=Pop(Index,:);
     MinMat=[MinMat min(Cost)];
     MeanMat=[MeanMat mean(Cost)];
    
    %% Display
    subplot(2,1,1)
    plot(MinMat,'r','linewidth',2.5);
    hold on
    plot(MeanMat,'b','linewidth',2);
    hold off
    xlim([1 MaxIteration]);
    pause(0.05)
    subplot(2,1,2)
    plot(XCity(Pop(1,:)),YCity(Pop(1,:)),'r-p')

    
end

%% Final Result Display
BestSolution=Pop(1,:);
BestCost=Cost(1);
    