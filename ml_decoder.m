function decoded = ml_decoder(received, codewords)
    decoded = zeros(size(received,1), size(codewords,2));
    for i = 1:size(received,1)
        dists = sum(abs(codewords - received(i,:)), 2);
        [~, idx] = min(dists);
        decoded(i,:) = codewords(idx,:);
    end
end
