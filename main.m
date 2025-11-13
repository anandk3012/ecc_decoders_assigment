clc; clear; close all;

n = 256;
k = 37;
p = 0.1;
m = log2(n);

r = calculate_r(m, k);

decoder = 3;
Afile = sprintf('A/Polar_A_file_n_%d_k_%d.mat', n, k);


corrupted_file = sprintf('corrupted_files/n_%d_k_%d_p_%s.txt', n, k, num2str(p));


if (k <= 12) || (k > 12 && decoder ~= 1)
    % POLAR DECODER
    if decoder < 3
        [polar_decoded, polar_decoder_tag] = PolarDecode(m, Afile, decoder, p, corrupted_file);

  
        folder = sprintf('polar_decoded/%s_decoded', polar_decoder_tag);
        if ~exist(folder, 'dir')
            mkdir(folder);
        end

        [~, base, ~] = fileparts(corrupted_file);
        output_file = fullfile(folder, sprintf('%s_out_%s.txt', ...
            base, polar_decoder_tag));

        bits = reshape(polar_decoded.', [], 1); 
        pad = mod(8 - mod(length(bits),8), 8);
        if pad ~= 0
            bits = [bits; zeros(pad,1)];
        end
        bytes_mat = reshape(bits, 8, []).'; 
        weights = 2.^(7:-1:0); 
        bytes = uint8(double(bytes_mat) * weights.');

        fid = fopen(output_file, 'wb');
        if fid == -1
            error('Cannot open output file for writing: %s', output_file);
        end
        fprintf(fid, '%d ', bytes);
        fclose(fid);

        fprintf('Saved decoded 8-bit binary stream: %s\n', output_file);
    end


    % REED MULLER(RM) DECODER
    [rm_decoded, rm_decoder_tag] = RMDecode(r, m, k, decoder, p, corrupted_file);
    disp(size(rm_decoded));

    folder = sprintf('rm_decoded/%s_decoded', rm_decoder_tag);
    if ~exist(folder, 'dir')
        mkdir(folder);
    end

    [~, base, ~] = fileparts(corrupted_file);
    output_file = fullfile(folder, sprintf('%s_out_%s_v1.txt', ...
        base, rm_decoder_tag));

    bits = reshape(rm_decoded.', [], 1);  
    pad = mod(8 - mod(length(bits),8), 8);
    if pad ~= 0
        bits = [bits; zeros(pad,1)];
    end
    bytes_mat = reshape(bits, 8, []).'; 
    weights = 2.^(7:-1:0);
    bytes = uint8(double(bytes_mat) * weights.'); 

    fid = fopen(output_file, 'wb');
    if fid == -1
        error('Cannot open output file for writing: %s', output_file);
    end
    fprintf(fid, '%d ', bytes);
    fclose(fid);
    fprintf('Saved decoded 8-bit binary stream: %s\n', output_file);
end