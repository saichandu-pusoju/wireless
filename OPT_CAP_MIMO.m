function C = OPT_CAP_MIMO(H, SNR)
    % Calculate channel eigenvalues (λ_i)
    lambda = svd(H).^2;  
    
    % Ensure lambda is a row vector
    lambda = lambda(:).';  % Converts to row vector

    % Total transmit power = SNR
    P_total = SNR;  

    % Get power allocation using water-filling
    P_alloc = water_filling(lambda, P_total);  

    % Calculate capacity: sum(log2(1 + allocated_power * λ_i))
    C = sum(log2(1 + P_alloc .* lambda));  % bits/s/Hz
end


function P_alloc = water_filling(lambda, P_total)
    % Water-filling algorithm for optimal power allocation
    [lambda_sorted, indices] = sort(lambda, 'descend');  
    N = length(lambda_sorted);
    P_alloc_sorted = zeros(1, N);  

    while true
        mu = (P_total + sum(1 ./ lambda_sorted)) / N;  % Calculate water level
        P_alloc_sorted = mu - 1 ./ lambda_sorted;      % Power allocation
        P_alloc_sorted(P_alloc_sorted < 0) = 0;        % Zero for negative allocations

        total_power_used = sum(P_alloc_sorted);

        if abs(total_power_used - P_total) < 1e-6 || total_power_used <= P_total
            break;
        else
            % Exclude zero-power channels
            zero_indices = (P_alloc_sorted == 0);
            lambda_sorted(zero_indices) = [];
            P_alloc_sorted(zero_indices) = [];
            N = length(lambda_sorted);
            if N == 0
                break;
            end
        end
    end

    % Return allocation in original order
    P_alloc = zeros(1, length(lambda));
    P_alloc(indices(1:length(P_alloc_sorted))) = P_alloc_sorted;
end
