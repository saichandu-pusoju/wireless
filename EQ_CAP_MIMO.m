function C = EQ_CAP_MIMO(H, SNR)
    % Calculate singular values squared
    lambda = svd(H).^2;  
    N = length(lambda);

    % Equal power allocation
    P_equal = SNR / N;  % Power equally distributed among antennas
    
    % Calculate capacity
    C = sum(log2(1 + P_equal * lambda));  % Equal power capacity (bits/s/Hz)
end
