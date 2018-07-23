function CityDistanceMatrix = CityDistanceMatrix_Fcn(XCity,YCity)
% Purpose : compute the distance beetween each city and make a matrix for all city
%mehran ghandehary 2010

NCity = numel(XCity);
for ii = 1:NCity
    for jj = 1:NCity
        CityDistanceMatrix(ii,jj) = sqrt((XCity(ii) - XCity(jj))^2 + (YCity(ii) - YCity(jj))^2);
    end
end