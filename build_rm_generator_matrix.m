function G = build_rm_generator_matrix(r, m)

    %  Cnstruction from degree 0 to r
    %RM_GENERATOR  Generator matrix for RM(r, m)

    % if r < 0, error('r must be >= 0'); end
    % if r > m, r = m; end
    % 
    % N = 2^m;
    % X = (dec2bin(0:N-1, m) - '0').';  % m x N
    % 
    % rows = cell(r + 1, 1);
    % rows{1} = ones(1, N);
    % 
    % % Degrees 1..r
    % for d = 1:r
    %     combos = nchoosek(1:m, d); 
    %     T = size(combos, 1);
    %     R = false(T, N);                  
    % 
    %     for t = 1:T
    %         S = combos(t, :);
    %         R(t, :) = all(X(S, :), 1);
    %     end
    % 
    %     rows{d+1} = double(R);
    % end
    % 
    % % Stack all degrees together: G is k x N
    % G = double(cell2mat(rows));

    % Construction given in HW files
    G = RMmmgenerator(m);
end
