function X_true = generate_dynamic_channel(N, T, sparsity, rho, P_stay, P_new)
    % Generates a time varying sparse channel using a Gauss-Markov process
    
    X_true = zeros(N, T);
    support = rand(N, 1) < sparsity;
    X_true(:, 1) = support .* randn(N, 1); % Initial channel
    
    for t = 2:T
        % 1. Evolve Support (Paths appearing and disappearing)
        stay_active = support & (rand(N, 1) < P_stay);
        new_active = (~support) & (rand(N, 1) < P_new);
        support = stay_active | new_active;
        
        % 2. Evolve Amplitudes (Gauss-Markov process)
        innovation = randn(N, 1); % Fading noise
        X_true(:, t) = support .* (rho * X_true(:, t-1) + sqrt(1 - rho^2) * innovation);
    end
end
