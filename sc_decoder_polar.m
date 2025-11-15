function decoded = sc_decoder_polar(corrupted_words, A, m, p)
% decoded = sc_decoder_polar(corrupted_words, A, m, p)
% Minimal SC decoder for Polar codes that auto-detects bit-reversal ordering.
% Inputs:
%   corrupted_words : N x n (0/1)
%   A               : info indices (1-based OR 0-based)
%   m               : log2(n)
%   p (optional)    : BSC flip prob; if provided uses L0* (1-2*y) LLRs
%
% Behavior:
%  - First tries decoding with A as provided.
%  - If first few outputs are all zero, remaps A via bitrevorder and retries.
%  - Returns the decoded codewords (N x n matrix).

if nargin < 4, p = []; end

[N, n] = size(corrupted_words);
if n ~= 2^m, error('m does not match n'); end

% Normalize A to 1-based indices if zero-based was passed
A = A(:).';
if any(A == 0)
    Aidx = A + 1;
else
    Aidx = A;
end
if any(Aidx < 1) || any(Aidx > n), error('A contains invalid indices'); end

% Build isInfo mask for use
isInfo_try1 = false(1,n);
isInfo_try1(Aidx) = true;

% LLR setup
if isempty(p)
    useL0 = false;
else
    useL0 = true;
    if p <= 0 || p >= 0.5, warning('p should be in (0,0.5)'); end
    L0 = log((1-p)/p);
end

% min-sum f/g
f_func = @(a,b) sign(a).*sign(b).*min(abs(a),abs(b));
g_func = @(a,b,u) b + ((-1).^u).*a;

% local lambda to decode one full set with a given isInfo
    function out = decode_with_mask(isInfoMask)
        out = zeros(N, n);
        for cw = 1:N
            y = corrupted_words(cw,:);
            if useL0
                llr = L0 * (1 - 2*y);
            else
                llr = (1 - 2*y); % simple +/-1 LLR
            end
            uhat = polar_decode_block(llr, 1, isInfoMask, f_func, g_func);
            xhat = polar_encode_from_u(uhat, m);
            out(cw,:) = xhat;
        end
    end

% Try 1: decode with A as given
decoded_try1 = decode_with_mask(isInfo_try1);

% Quick test: if many-all-zero (first few words trivial) then try remap
ncheck = min(5, N);
sumOnes_first_try = sum(decoded_try1(1:ncheck,:), 2); % vector of sums
if all(sumOnes_first_try == 0) && ~isempty(Aidx)
    % Remap A via bitrevorder (attempt to map provided A to natural polar ordering)
    perm = bitrevorder(1:n);               % produces a permuted list of 1..n
    % find positions in natural order corresponding to provided indices
    % i.e., for each a in Aidx find pos such that perm(pos) == a
    A_mapped = arrayfun(@(a) find(perm==a,1), Aidx);
    % sanity: unique & valid
    A_mapped = unique(A_mapped);
    A_mapped( A_mapped < 1 | A_mapped > n ) = [];
    if isempty(A_mapped)
        % fallback: keep try1
        decoded = decoded_try1;
        return;
    end
    isInfo_try2 = false(1,n);
    isInfo_try2(A_mapped) = true;

    decoded_try2 = decode_with_mask(isInfo_try2);
    sumOnes_second = sum(decoded_try2(1:ncheck,:), 2);
    % pick whichever produced non-zero first words; prefer try2 if it yields some ones
    if any(sumOnes_second > 0)
        decoded = decoded_try2;
        return;
    else
        % both yielded zeros -> return try1 (no change)
        decoded = decoded_try1;
        return;
    end
else
    % try1 already produced non-trivial output -> use it
    decoded = decoded_try1;
    return;
end

end


%% ------------------------------------------------------------------------
% helper: recursive polar decode block (explicit start_pos indexing)
function u_block = polar_decode_block(llr_block, start_pos, isInfo, f_func, g_func)
% llr_block: 1 x L
% start_pos: absolute index in u of the first bit of this block
L = numel(llr_block);
if L == 1
    pos = start_pos;
    if isInfo(pos)
        u_block = llr_block < 0;  % 0 if LLR >= 0 else 1
    else
        u_block = 0;
    end
    return;
end

half = L/2;
left = llr_block(1:half);
right = llr_block(half+1:end);

L_left = f_func(left, right);
u_left = polar_decode_block(L_left, start_pos, isInfo, f_func, g_func);

g_vals = g_func(left, right, u_left);
u_right = polar_decode_block(g_vals, start_pos + half, isInfo, f_func, g_func);

u_block = [u_left, u_right];
end


%% ------------------------------------------------------------------------
% helper: polar encoding transform (butterfly) x = u * F^{⊗m}
function x = polar_encode_from_u(u, m)
n = 2^m;
if length(u) ~= n, error('u length mismatch'); end
x = mod(u(:).', 2);
len = 1;
for stage = 1:m
    step = 2*len;
    new = zeros(1, n);
    for i = 1:step:n
        left = x(i:i+len-1);
        right = x(i+len:i+step-1);
        new(i:i+len-1) = mod(left + right, 2);  % u+v
        new(i+len:i+step-1) = right;             % v
    end
    x = new;
    len = step;
end
end
