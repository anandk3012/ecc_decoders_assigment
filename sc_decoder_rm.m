function decoded = sc_decoder_rm(corrupted_words, r, m, p)
% decoded = sc_decoder_rm(corrupted_words, r, m, p)
% r: RM order
% p optional (BSC LLR magnitude). If omitted uses +/-1 LLRs.

if nargin < 4, p = []; end
[N, n] = size(corrupted_words);
if n ~= 2^m, error('m does not match n'); end

f_func = @(a,b) sign(a).*sign(b).*min(abs(a),abs(b));
g_func = @(a,b,u) b + ((-1).^u).*a;

decoded = zeros(N,n);
if isempty(p)
    useL0 = false;
else
    useL0 = true;
    if p <= 0 || p >= 0.5, warning('p should be in (0,0.5)'); end
    L0 = log((1-p)/p);
end

for cw = 1:N
    y = corrupted_words(cw,:);
    if useL0
        llr = L0 * (1 - 2*y);
    else
        llr = (1 - 2*y);
    end
    c = decode_rm_block(llr, m, r, f_func, g_func);
    decoded(cw,:) = c;
end
end
