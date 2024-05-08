clear; close; clc;

% Problem Definition
a = 0; b = 10;
h = 0.5;
x = a:h:b;
A = 1;

m = 5; % # of neuron
nVar = 3*m+1;

%% Parameters
maxTrials = 25;     % Maximum # of trials
maxIter = 10^3;     % Maximum # of iterations (Stopping criteria)
%maxnFeval = 10^6;   % Maximum # of Cost function evalutaion (Stopping criteria)
eps = realmin;      % Minimum value of Cost function (Stopping criteria)
nBenchmarkFunc = 5; %17 % # of Benchmark Test Functions
maxnFeval = 10^6;

%empty_Sol.Problem.funName = '';
empty_Sol.Problem.nVar = 3*m+1;
empty_Sol.Problem.VarMin = -10;
empty_Sol.Problem.VarMax = 10;
empty_Sol.xmin = [];
empty_Sol.fmin = Inf;
empty_Sol.nFeval = 0;
empty_Sol.nRef = 0;
empty_Sol.nExp = 0;
empty_Sol.nIC = 0;
empty_Sol.nOC = 0;
empty_Sol.nShrink = 0;
empty_Sol.nIter = 0;
empty_Sol.BestCost = [];
fmin = inf*ones(1,maxTrials);
nFeval = zeros(1,maxTrials);
nIter = zeros(1,maxTrials);
T = zeros(1,maxTrials);

fid = fopen('Result\Results.txt','w+');




%% PSO
Sol=repmat(empty_Sol,maxTrials,1);

for k=1:maxTrials
    nVar = Sol(k).Problem.nVar;
    VarMin = Sol(k).Problem.VarMin;
    VarMax = Sol(k).Problem.VarMax;
    tic;
    [Sol(k).xmin,fmin(k),nFeval(k),nIter(k),Sol(k).Best] = pso('Cost',  10, nVar, VarMin, VarMax, maxIter, maxnFeval, eps, 'f',x,0,1);
    T(k) = toc;
    Sol(k).fmin = fmin(k);
    Sol(k).nFeval = nFeval(k);
    Sol(k).nIter = nIter(k);
    Sol(k).elapsedTime = T(k);
end



% Display results
[~,minInd] = min(fmin);
[~,maxInd] = max(fmin);

%% Euler and ODE45
teststep=0.25;
xtest=a:teststep:b;
%xtest=[a xtest(~ismember(xtest,x)) b];
odefun = @(t, y) exp(-t) - y;
t_start = a;
t_end = b;
step_size = teststep;
num_steps = round((t_end - t_start) / teststep);

% Initialize time and solution arrays for Euler method
t = linspace(t_start, t_end, num_steps + 1);
y = zeros(1, num_steps + 1);

y0 = 1;
y(1) = y0;

% Perform the Euler method
for i = 1:num_steps
    t_current = t(i);
    y_current = y(i);
    
    % Compute the next value using the Euler method
    y_next = y_current + step_size * odefun(t_current, y_current);
    
    % Store the next value in the solution array
    y(i + 1) = y_next;
end

% Compute the solution using ode45
[t_ode45, y_ode45] = ode45(odefun, xtest, y0);


fprintf('\n-----------------------------------------------------------------------\n\n');
fprintf(fid,'\n-----------------------------------------------------------------------\n\n');
yc  = (xtest+1).*exp(-xtest);
yt3= trialy(x,a,A,Sol(minInd).xmin);


ytest3= trialy(xtest,a,A,Sol(minInd).xmin);
%plot(x,yt3,'LineWidth',2);
figure;
plot(xtest,ytest3,'LineWidth',2);
hold on;
plot(t, y,'LineWidth', 2);
hold on;
plot(t,yc,'LineWidth',2);
hold on;
plot(xtest, y_ode45, 'g-');
legend('Neural Network','Euler Method','ode45','Exact Solution');
xlabel('t');
ylabel('y(t)');
title('Solution Comparison: Neural Network, Euler Method, ode45, and Exact Solution');
set(gca, 'FontSize', 20);
grid on;
fprintf('\n');
%fprintf(fid,'\n');
%fclose(fid);

error1 = abs(ytest3 - yc);
error2 = abs(y - yc);
error3 = abs(y_ode45' - yc);





% Plot the absolute errors
figure;
plot(xtest, error1, 'r-', 'LineWidth', 1.5); % Plot error1 in red
hold on;
plot(xtest, error2, 'g-', 'LineWidth', 1.5); % Plot error2 in green
plot(xtest, error3, 'b-', 'LineWidth', 1.5); % Plot error3 in blue
hold off;

% Add plot labels and legend
xlabel('t');
ylabel('Absolute Error');
title('Absolute Error of Different Methods Compared to Exact Solution');
legend('Neural Network', 'Euler Method', 'Ode45');
set(gca, 'FontSize', 20);
grid on;

error11 = sqrt(mean((ytest3 - yc).^2));
error22 = sqrt(mean((y - yc).^2));
error33 = sqrt(mean((y_ode45' - yc).^2));

figure;
% Combine them into an array for plotting
errors = [error11, error22, error33];

% Create a bar plot
bar(errors);

% Label the x-axis ticks with method names
set(gca, 'XTickLabel', {'Neural Network', 'Euler Method', 'Ode45'});

% Add a legend (with method names)
legend('RMSE');

% Label the axes
xlabel('Methods');
ylabel('Root Mean Squared Error (RMSE)');

% Add a title
title('Root Mean Squared Error (RMSE) Comparison');
set(gca, 'YScale', 'log');
% set(gca, 'FontSize', 20);


