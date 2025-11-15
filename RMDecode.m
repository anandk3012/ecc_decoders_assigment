function [decoded, decoder_tag] = RMDecode(r, m, ~, decoder, ~, corrupted_file)
    n = 2^m;
    fprintf('RM Decoder Implemented_r_%d_m_%d\n', r, m)
    G = build_rm_generator_matrix(r, m);
    
    [corrupted_words, ~, N, ~] = load_corrupted_words(corrupted_file, n);
    disp(size(corrupted_words));
    disp(N);

    if decoder == 1
        fprintf('Using ML decoder...\n');
        codewords = get_rm_codewords(G);
        decoded = ml_decoder(corrupted_words, codewords);
        decoder_tag = 'ml';
    elseif decoder == 2
        fprintf('Using Successive cancellation decoder...\n');
        decoded = sc_decoder_rm(corrupted_words, r, m);
        decoder_tag = 'scd';
    elseif decoder == 3
        fprintf('Using Maj Logic decoder...\n');
        decoded = maj_logic_decoder(corrupted_words, G, r, m);
        decoder_tag = 'maj_log';
    end
end
