function codewords = get_rm_codewords(G)
    % G: k x N generator for RM(r, m)
    k = size(G, 1);
    num_messages = 2^k;

    messages = zeros(num_messages, k);
    for i = 0:num_messages-1
        messages(i+1, :) = dec2bin(i, k) - '0';
    end

    codewords = mod(messages * G, 2);  % (2^k x N)
end

