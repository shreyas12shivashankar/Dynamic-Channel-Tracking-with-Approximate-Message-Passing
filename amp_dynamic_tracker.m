function X_est = amp_dynamic_tracker(Y, Phi, N, M, T, max_iters)
    % Core Approximate Message Passing (AMP) loop over sequential time slots
    
    X_est = zeros(N, T);
    
    for t = 1:T
        y_t = Y(:, t);
        A_t = Phi{t};
        
        % Initialize AMP state for current time step
        if t == 1
            x_hat = zeros(N, 1);
            z = y_t;
            SI_weights = ones(N, 1); % No side information at t=1
        else
            % USE SIDE INFORMATION: Warm-start with previous estimate
            x_hat = X_est(:, t-1);
            z = y_t - A_t * x_hat;
            
            % Identify active paths from t-1 to create dynamic weights
            prev_support = abs(x_hat) > (0.2 * max(abs(x_hat)));
            
            % Paths that were active get a heavily reduced penalty (e.g., 30% of normal)
            SI_weights = ones(N, 1);
            SI_weights(prev_support) = 0.3; 
        end
        
        % AMP Iterations
        for iter = 1:max_iters
            % 1. Calculate Pseudo data (effective observation)
            r = x_hat + A_t' * z;
            
            % 2. Extended Denoiser: Adaptive Soft-Thresholding
            [x_new, eta_prime] = adaptive_denoiser(r, x_hat, SI_weights);
            
            % 3. Residual update with Onsager term
            z = y_t - A_t * x_new + (N/M) * z * eta_prime;
            x_hat = x_new;
        end
        
        X_est(:, t) = x_hat;
        fprintf('Processed Time Slot %d/%d\n', t, T);
    end
end
