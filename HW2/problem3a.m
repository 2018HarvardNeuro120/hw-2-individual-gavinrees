subtractMeans = @(d) d - mean(d);
%verified using the cov 
getCovariance = @(d) (1/size(d,1)) * transpose(subtractMeans(d)) * subtractMeans(d);

myCovariance = getCovariance(toWhiten);
[eigenVectorM,eigenValueM] = eig(myCovariance);
%make a row vector of the eigenvalues to later scale the principal
%component plot
eigenValueV = transpose(diag(eigenValueM));

toWhitenMean = mean(toWhiten);

%scatterplot the data
scatter(toWhiten(:,1), toWhiten(:,2))
hold on
%plot the principal components
quiver(toWhitenMean(1)*ones(1,2), toWhitenMean(2)*ones(1,2),eigenVectorM(1,:).* eigenValueV ,eigenVectorM(2,:).* eigenValueV)
