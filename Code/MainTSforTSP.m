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
TabuTenure = 10 ;
MaxIteration= 2000;

%% Initialization
Current_Tour=sort(randperm(CityNum));
Current_Cost=CalculateTourDistance_Fcn(Current_Tour,CityDistanceMatrix,CityNum);
Best_Tour=Current_Tour;
Best_Cost=Current_Cost;
%% MAIN LOOP
Tabu(CityNum,CityNum)=[0];
Iter=1;
t=true;
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
end
%% Final Result Display
       Best_Tour
        Best_Cost
