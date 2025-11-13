function [corrupted_words, corrupted_words_small, N, total_bits] = load_corrupted_words(filename, n)
    % Reads binary corrupted codewords from file as uint8 bytes.
    fid = fopen(filename, 'rb');
    if fid == -1
        error('Cannot open file: %s', filename);
    end
    buf = fread(fid, inf, 'uint8');
    fclose(fid);

    total_bits = numel(buf) * 8;
    N = total_bits / n;
    if mod(total_bits, n) ~= 0
        error('Total bits not a multiple of codeword length.');
    end

    % Manual MSB-first bit unpacking (equivalent to de2bi(buf,8,'left-msb'))
    bits_big = zeros(numel(buf), 8);
    for i = 1:numel(buf)
        bits_big(i, :) = bitget(buf(i), 8:-1:1);
    end
    bits_big = reshape(bits_big.', [], 1);
    corrupted_words = reshape(bits_big, n, N).';

    % Manual LSB-first bit unpacking (equivalent to de2bi(buf,8,'right-msb'))
    bits_little = zeros(numel(buf), 8);
    for i = 1:numel(buf)
        bits_little(i, :) = bitget(buf(i), 1:8);
    end
    bits_little = reshape(bits_little.', [], 1);
    corrupted_words_small = reshape(bits_little, n, N).';
end
