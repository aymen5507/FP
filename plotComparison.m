%% Comparison Plot between all 4 algorithms

% size should be 1x1000
input_u = load('cart_u.mat');
x_true = load('cart_x_true.mat');
t = load('t.mat');

%hamza = load('hamza_pend_x_hat.mat');
aymen = load('Aymen_cart_pole_x_hat_1.mat');
%yan = load('Yan_pend_x_hat.mat');
%supi = load('Supi_pend.mat');

% colors
hamza_color = '#E69F00';
supi_color = '#56B4E9';
aymen_color = '#FF0000';
yan_color = '#0072B2';
orig_color = 'red';
input_color = 'green';

% linestyle
hamza_line = '--';
supi_line = '-.';
aymen_line = ':';
yan_line = '--';

% Example data (replace this with your actual data)
numStates = 2; % Number of states or dimensions
numInputs = 1;
t = t.t; % Time axix

original_values = x_true.x'; % Replace this with your original data matrix (time x dimensions)
%hamza = hamza.x_hat; % Replace this with your estimated data matrix (time x dimensions)
%supi = supi.pred;
%yan = yan.x_hat';
aymen = aymen.x_hat';

InputVector = input_u.u; % Replace this with your additional vector

% Plotting original and estimated values for each state in separate subplots
figure;

subplot(3, 1, 1);

plot(t, original_values(1, :), 'b', 'LineWidth', 1.5); % Plotting original values in blue
hold on;
%plot(t, hamza(1, :), 'Color',  hamza_color, 'Linestyle' , hamza_line, 'LineWidth', 1.2); % Plotting estimated values in red dashed line
%plot(t, supi(1, :), 'Color',  supi_color, 'Linestyle' , supi_line, 'LineWidth', 1.2); % Plotting estimated values in red dashed line
plot(t, aymen(1, :), 'Color',  aymen_color, 'Linestyle' , aymen_line, 'LineWidth', 1.2); % Plotting estimated values in red dashed line
%plot(t, yan(1, :), 'Color',  yan_color, 'Linestyle' , yan_line, 'LineWidth', 1.2); % Plotting estimated values in red dashed line
hold off;

% Customize plot properties as needed
%title(['State ' num2str(1)]);
ylabel('$x_1$');
legend('x_1', 'Estimated');
grid on;

subplot(3, 1, 2);
plot(t, original_values(2, :), 'b', 'LineWidth', 1.5); % Plotting original values in blue
hold on;
%plot(t, hamza(2, :), 'Color',  hamza_color, 'Linestyle' , hamza_line, 'LineWidth', 1.2); % Plotting estimated values in red dashed line
%plot(t, supi(2, :), 'Color',  supi_color, 'Linestyle' , supi_line, 'LineWidth', 1.2); % Plotting estimated values in red dashed line
plot(t, aymen(2, :), 'Color',  aymen_color, 'Linestyle' , aymen_line, 'LineWidth', 1.2); % Plotting estimated values in red dashed line
%plot(t, yan(2, :), 'Color',  yan_color, 'Linestyle' , yan_line, 'LineWidth', 1.2); % Plotting estimated values in red dashed line
hold off;


% Customize plot properties as needed
%title(['State ' num2str(2)]);
ylabel('x_2');
legend('x_2', 'Estimated');
grid on;

% % Adding subplot for the additional vector
% subplot(3, 1, 3);
% plot(t, InputVector, 'Color', input_color, 'LineWidth', 1.2); % Plotting the additional vector in green
% %title('Input Vector');
% xlabel('Time t');
% ylabel('u(t)');
% legend('Input Vector');
% grid on;

subplot(3, 1, 3);
plot(t, original_values(3, :), 'b', 'LineWidth', 1.5); % Plotting original values in blue
hold on;
%plot(t, hamza(2, :), 'Color',  hamza_color, 'Linestyle' , hamza_line, 'LineWidth', 1.2); % Plotting estimated values in red dashed line
%plot(t, supi(2, :), 'Color',  supi_color, 'Linestyle' , supi_line, 'LineWidth', 1.2); % Plotting estimated values in red dashed line
plot(t, aymen(3, :), 'Color',  aymen_color, 'Linestyle' , aymen_line, 'LineWidth', 1.2); % Plotting estimated values in red dashed line
%plot(t, yan(2, :), 'Color',  yan_color, 'Linestyle' , yan_line, 'LineWidth', 1.2); % Plotting estimated values in red dashed line
hold off;

% Customize plot properties as needed
%title(['State ' num2str(2)]);
ylabel('x_3');
legend('x_3', 'Estimated');
grid on;

sgtitle('Estimation of Cart Pole');

%matlab2tikz('comparisonPlot.tex');
