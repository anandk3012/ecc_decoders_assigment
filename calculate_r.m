function r = calculate_r(m, k)
    r = 0;
    current_k = 1;  % Start with r=0 which gives k=1
    
    % Keep incrementing r until we reach or exceed the target k
    while current_k < k && r < m
        r = r + 1;
        current_k = current_k + nchoosek(m, r);
    end
    
    % Check if we found the exact k
    if current_k ~= k
        warning('No exact r found for given m and k');
    end
end