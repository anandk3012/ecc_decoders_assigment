function codewords = get_codewords(k, G, A)
    num_messages = 2^k;
    messages = zeros(num_messages, k);
    for i = 0:num_messages-1
        messages(i+1,:) = dec2bin(i,k) - '0';
    end
    codewords = mod(messages * G(A+1,:), 2);
end
