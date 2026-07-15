function [x_new, eta_prime] = adaptive_denoiser(r, x_hat, SI_weights)
    % Applies side information weighted soft thresholding
    
    % Base threshold depends on current residual variance
    tau_base = 1.5 * std(r - x_hat); 
    tau_dynamic = tau_base * SI_weights; % Apply Side Information weights
    
    % Soft-thresholding step
    x_new = sign(r) .* max(abs(r) - tau_dynamic, 0);
    
    % Onsager Correction calculation
    % Ratio of non-zero elements acts as the derivative of soft thresholding
    eta_prime = mean(abs(x_new) > 0);
end
