function [decoded, decoder_tag] = PolarDecode(m, Afile, decoder, p, corrupted_file)
    % PolarDecode(m, Afile, decoder, p, filename)
    % Outputs decoded codewords as a binary stream of 8-bit integers.

    n = 2^m;
    load(Afile, 'A');
    A = A(:)';
    A = A - 1;
    k = length(A);

    % Build generator matrix
    F = [1 0; 1 1];
    G = F;
    for ii = 2:m
        G = mod(kron(G, F), 2);
    end

    % ---- Load corrupted bits ----
    [corrupted_words, ~, N, total_bits] = load_corrupted_words(corrupted_file, n);
    fprintf('Loaded %s | Codewords: %d | Total bits: %d\n', ...
        corrupted_file, N, total_bits);

    % ---- Decode ----
    if decoder == 1
        fprintf('Using ML decoder...\n');
        codewords = get_codewords(k, G, A);
        decoded = ml_decoder(corrupted_words, codewords);
        decoder_tag = 'ml';
    elseif decoder == 2
        fprintf('Using SC decoder...\n');
        decoded = sc_decoder_polar(corrupted_words, A, m, p);
        decoder_tag = 'scd';
    else
        error('Invalid decoder type. Use 1 for ML or 2 for SCD.');
    end
end
