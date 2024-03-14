clear
clear global
tic;
%% system model
global gpmodel old_state xdim
model=toy_problem; % toy_problem pend_2d cart_pole
xdim=model.dimx;
udim=model.dimu;
x0=model.x0;
ulb=model.u_LB; %upperbound of control input
uub=model.u_UB; %lowerbound of control input
initial_size=5;
iter=100;
sample_size=initial_size+iter; %initial traning set size
trials=10;
epsilon_k = -0.05 + (0.1)*rand(xdim,sample_size); 
%gaussian observation noise
%% generate validation set
test_num=1000;
random_state = rand(test_num, xdim);
random_input=ulb + (uub-ulb)*rand(test_num,udim);
random_samples=[random_state, random_input];
%% generate initial traning set
for j=1:trials
%seed = 9;
%rng(seed);
initial_inputs=ulb + (uub-ulb)*rand(sample_size,1);
state_before = x0;
for i=1:sample_size
    state_after(:,i)=model.x_plus1(state_before,initial_inputs(i));
    state_before=state_after(:,i);
end
state_observed=state_after+epsilon_k;
state_observed=state_observed';
x=[x0, state_after(:,1:end-1)];
x=[x;reshape(initial_inputs,[1,sample_size])];
x=x';
%% fit gp model
al_x=x(1:initial_size,:);
al_y=state_observed(1:initial_size,:);
fit_gpmodel(al_x,al_y);
%% gp model
fit_gpmodel(x, state_observed);
old_state = state_observed(end, :);
%% optimistic control generation
global N
N = 15; % horizon length % this is T the paper% but we use N instead
options = optimoptions(@fmincon, 'Algorithm', 'interior-point', 'InitBarrierParam', 0.1, 'TolCon', 1e-6);
lb = [-5; -5; -Inf(N, 1)]; % optimization lower and upper bounds like we agreed
ub = [5; 5; Inf(N, 1)];
% generate validation set
test_num = 100;
random_state = rand(test_num, xdim);
random_input = ulb + (uub - ulb) * rand(test_num, udim);
random_samples = [random_state, random_input];
dec_vec_0 = zeros(1 + 1 + xdim * N, 1);
for k = 1:iter
    dec_optimal = fmincon(@objectif, dec_vec_0, [], [], [], [], lb, ub, @mycon, options);
    %disp(['Sample:', num2str(i)]);
    k_optimal = dec_optimal(1);
    %[x,state_observed]=utilize_control(x,state_observed,dec_optimal(1));
    [al_x,al_y] = utilize_control(al_x, al_y, k_optimal,model);
    fit_gpmodel(al_x,al_y);
    RMSE(j,k) =sqrt( test_result(model,random_samples,test_num));%calculate the MSE of the current model

%MSE(i)=test_result(model,[state_after' random_input],test_num) %calculate the MSE of the current model
end
save([model.name '_trial_' num2str(j)],'gpmodel')
for k=1:iter
fit_gpmodel(x(1:k+initial_size,:),state_observed(1:k+initial_size,:));
RMSE_no_al(j,k)=sqrt(test_result(model,random_samples,test_num));
end

% fit_gpmodel(x,state_observed);
% MSE_no_al(j)=test_result(model,random_samples,test_num);
end

RMSE_mean=mean(RMSE);
%figure_configuration_IEEE_standard;
plot(linspace(1,iter,iter),mean(RMSE),'color','#4DBEEE');
hold on;
plot(linspace(1,iter,iter),mean(RMSE_no_al),'--r')
xlabel('iterations');
ylabel('RMSE');
title('active learning GP (rec)')
legend('active learning GP','random sampling','Location','northeast')
% Display the runtime
% Stop the timer
elapsedTime = toc;
disp(['Elapsed time: ', num2str(elapsedTime), ' seconds']);

%% function handle of the cost function
function cost = objectif(dec_vec)
global old_state gpmodel N xdim;
var_noise = 0.5; % user-defined variation noise
cost = 0;
last_state = old_state;

% Check the size of dec_vec
%disp(['Size of dec_vec: ', num2str(size(dec_vec))]);

% Check the number of elements in dec_vec(3:end)
if xdim == 1
    u_elements = dec_vec(4:end);
elseif xdim == 2
        u_elements = dec_vec(5:end);
elseif xdim == 3
        u_elements = dec_vec(6:end);
end
expected_size = xdim * (N - 1);
%disp(['Number of elements in dec_vec ', num2str(numel(u_elements))]);
%disp(['Expected size: ', num2str(expected_size)]);
% Check if the number of elements is consistent with the expected size
%if numel(u_elements) ~= expected_size
 %   error('Incorrect number of elements in dec_vec(3:end).');
%end
% Reshape control inputs
u = reshape(u_elements, xdim, N - 1);
%  u = reshape(dec_vec(3:end), xdim, N - 1); % reshape control inputs
for i = 1:N - 1
    for j = 1:xdim
        %  try
        %[mu, sigma, ci] = predict(gpmodel, Xnew); used this
        %predefined function it runs.
        
        [~, var_t, ~] = predict(gpmodel{j}, [last_state u(j, i)]);
        %   catch
        %  var_t = 1.0;
        % end
        cost = cost + log(1 + (var_t.^2 / var_noise));
    end
    for k = 1:xdim
        last_state(k) = predict(gpmodel{k}, [last_state u(k, i)]);
    end
end
cost = -cost; % to get max instead of min
end
%% condition function
function [c, ceq] = mycon(dec_vec)
%in this function i get most of the errors
global gpmodel old_state N xdim;
beta = 2; % Standard for GP
c = 0;
eta = dec_vec(2);

% Initial state x0
ceq = zeros(xdim * (N - 1), 1);
last_state = old_state;
last_state = old_state;
%disp(['Size of dec_vec: ', num2str(size(dec_vec))]);

if xdim == 1
    u_elements = dec_vec(4:end);
elseif xdim == 2
    u_elements = dec_vec(5:end);
elseif xdim == 3
    u_elements = dec_vec(6:end);
end
expected_size = xdim * (N - 1);
% Reshape control inputs
u = reshape(u_elements, xdim, N - 1);
for t=1:N-1
  %  x_t = dec_vec((2 + 1 + (t - 1) * xdim):(2 + t * xdim));
   % u_t = dec_vec(1) * x_t;
    for j = 1:xdim
        [mu_t, var_t,~] = predict(gpmodel{j}, [last_state u(j,t)]);
        ceq(t,j) = mu_t + beta * var_t * eta - dec_vec((3 + (t-1)):(2 + t));
    end
end
ceq = ceq(:);
end
%%
function [new_x, new_y] = utilize_control(x, y, k,model)
global N
current_state = y(end, :);
for i = 1:N
    disp(['N:', num2str(i)]);
    u = k * current_state;
    new_state = model.x_plus1(current_state', u(1));
    new_x = [x; current_state, u(1)];
    new_y = [y; new_state'];
    epsilon_k = -0.05 + (0.1)*rand(size(new_state'));
    current_state = new_state' + epsilon_k;
end
end
%% train gp model
function fit_gpmodel(x, y)
global gpmodel xdim;
for i = 1:xdim
    gpmodel{i} = fitrgp(x, y(:, i));
end
end
%% calculate the MSE of gp model
function MSE = test_result(model, random_samples, test_num)
global gpmodel xdim;
for i = 1:test_num
    true_results(:, i) = model.x_plus1(random_samples(i, 1:end-1), random_samples(i, end));
    for j = 1:xdim
        predicted_y(i, j) = predict(gpmodel{j}, random_samples(i, :));
    end
end
MSE = immse(true_results, predicted_y');
end