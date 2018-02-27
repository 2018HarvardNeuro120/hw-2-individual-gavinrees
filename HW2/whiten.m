%% Problem 3, part B
function whitened = whiten(inputData)

subtractMeans = @(d) d - mean(d);
%verified using the cov 
getCovariance = @(d) (1/size(d,1)) * transpose(subtractMeans(d)) * subtractMeans(d);

centered = subtractMeans(inputData);
myCovariance = getCovariance(centered);
[eigenVectorM,eigenValueM] = eig(myCovariance);

inverseRootEigenvalues = transpose(diag(eigenValueM).^(-0.5));
scaledEigenVectorM = eigenVectorM .* inverseRootEigenvalues;
whitened = centered * scaledEigenVectorM;


