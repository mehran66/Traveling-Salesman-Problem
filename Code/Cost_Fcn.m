function Cost=Cost_Fcn(Pop,CityDistanceMatrix,NCity)
% purpose : Clculate the cost of a population for Genetic algorithm
%It use CalculateTourDistance_Fcn function for this purpose
%mehran ghandehary 2010

for ii=1:size(Pop,1)
    Tour=Pop(ii,:);
    Cost(ii,1)=CalculateTourDistance_Fcn(Tour,CityDistanceMatrix,NCity);
end