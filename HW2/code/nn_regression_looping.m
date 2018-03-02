clear all

%% Set up parameters
N = 40; % Number of training samples
epsilon = 0.0; % Amount of label noise
Nhs = 1:1:40;
repetitionsPerSize = 500;
lambda = 0;

%% Make dataset
target_fn = @(t) sin(t);
x = linspace(-pi,pi,N);
y = target_fn(x) + epsilon*randn(size(x));

Ntest = 100;
x_test = linspace(-pi,pi,Ntest);
y_test = target_fn(x_test);

Ni = 2;
meanSquaredErrors = zeros(size(Nhs));
for NhIndex = 1:size(Nhs,2)
    disp(num2str(NhIndex));
    Nh = Nhs(NhIndex);
    for i = 1:repetitionsPerSize
        
        J = randn(Nh,Ni)/Nh;

        h = J*[x; ones(1,N)];
        h(h<0)=0;

        h_test = J*[x_test; ones(1,Ntest)];
        h_test(h_test<0)=0;


        squared = h*h';
        w = y*h'*pinv(squared + lambda*eye(size(squared,1)));

        y_pred = w*h_test;

        mean_squared_error = norm(y_test-y_pred).^2;

        meanSquaredErrors(NhIndex) = meanSquaredErrors(NhIndex) + mean_squared_error;
    end
end

plot(Nhs, meanSquaredErrors/repetitionsPerSize);
xlabel("Second Layer Size");
ylabel("Mean Squared Error");


% plot(x,y,'ob')
% hold on
% plot(x_test,y_test)
% hold on
% plot(x_test,y_pred)
% 
% text(-pi,[.1 .9]*get(gca,'YLim')',sprintf('MSE: %g ', mean_squared_error))
% xlabel('Input')
% ylabel('Output')
% legend('Training data','Test data','Prediction')



