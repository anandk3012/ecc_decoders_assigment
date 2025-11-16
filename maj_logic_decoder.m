function decoded = maj_logic_decoder(corrupted_words, G, r, m)
decoded = [];
for cw = 1:size(corrupted_words, 1)
    y = corrupted_words(cw, :);
    for deg = r : -1 : 1
        coeffs = nchoosek((1:m), deg);

        for j = 1:size(coeffs, 1)
            % coeffs in a and complement indices in v
            a = coeffs(j, :);
            v = setdiff(1:m, a);

            % All possible bit combinations for indices in a and v
            bits_a = dec2bin(0:2^length(a)-1)-'0';
            bits_v = dec2bin(0:2^length(v)-1)-'0';
            estimate = zeros(1, 2^(length(a)));
            t = 1;

            for p = 1:size(bits_a, 1)

                est_sum = 0;
                bit_a = bits_a(p, :);
                for q = 1:size(bits_v, 1)
                    bit_v = bits_v(q, :);

                    full_bits = zeros(1, m);
                    full_bits(a) = bit_a;
                    full_bits(v) = bit_v;
                    idx = bi2de(full_bits, 'left-msb');
                    value = y(idx + 1);
                    est_sum = mod(est_sum + value, 2);
                end

                estimate(t) = est_sum;
                t = t + 1;
            end
            majority = mode(estimate);

            if majority == 1
                row = j + sum(arrayfun(@(l) nchoosek(m,  l), 0:deg-1));
                y = mod(y + G(row, :), 2);
            end
        end
        if mode(y) == 1
            y = mod(y + ones(1, length(y)), 2);
        end
        decoded = [decoded, y];
    end
end