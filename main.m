% Dynamic Channel Tracking using AMP with Side Information
clear;
clc;
close all;

%% 1. System Parameters
N = 512;          % Channel dimension (e.g. number of delay/angular bins)
M = 256;          % Number of measurements (Compressive Sensing: M < N)
T = 15;           % Number of sequential time slots
SNR_dB = 20;      % Signal to Noise Ratio

% Temporal Evolution Parameters
sparsity = 0.1;   % 10% of channel taps are active
rho = 0.95;       % Gauss-Markov temporal correlation (0 to 1)
P_stay = 0.90;    % Probability an active path stays active
P_new = sparsity * (1 - P_stay) / (1 - sparsity); % Balances steady state sparsity

%% 2. Generate Dynamic Time-Varying Channel
X_true = generate_dynamic_channel(N, T, sparsity, rho, P_stay, P_new);

%% 3. Generate Sequential Measurements
Y = zeros(M, T);
Phi = cell(T, 1);
noise_var = 10^(-SNR_dB/10);

for t = 1:T
    % i.i.d. Gaussian sensing matrix (representing pilot sequences)
    Phi{t} = randn(M, N) / sqrt(M); 
    noise = sqrt(noise_var) * randn(M, 1);
    Y(:, t) = Phi{t} * X_true(:, t) + noise;
end

%% 4. AMP Framework with Side Information Integration
max_iters = 40;
X_est = amp_dynamic_tracker(Y, Phi, N, M, T, max_iters);

%% 5. Visualization and Validation
MSE = sum((X_true - X_est).^2, 1) ./ sum(X_true.^2, 1);
MSE_dB = 10*log10(MSE);

% Plot MSE over time
figure;
plot(1:T, MSE_dB, '-bo', 'LineWidth', 2, 'MarkerFaceColor', 'b');
xlabel('Sequential Time Slots (t)');
ylabel('Normalized MSE (dB)');
title('Tracking Accuracy over Time (AMP with Side Information)');
grid on;

% Visualize a snapshot of the channel recovery
t_snap = round(T/2);
figure;
stem(X_true(:, t_snap), 'k', 'DisplayName', 'True Channel Paths'); hold on;
stem(X_est(:, t_snap), 'r--', 'DisplayName', 'AMP Estimate');
xlabel('Channel Tap Index');
ylabel('Amplitude');
title(sprintf('Sparse Channel Recovery at Time Slot %d', t_snap));
legend;
