function c = decode_rm_block(llr_block, m_level, r_level, f_func, g_func)
% c = decode_rm_block(llr_block, m_level, r_level, f_func, g_func)
L = numel(llr_block);
if L == 1
    if r_level >= 0
        c = llr_block < 0;
    else
        c = 0;
    end
    return;
end
if r_level < 0
    c = zeros(1,L);
    return;
end
if r_level >= m_level
    c = llr_block < 0;
    return;
end

half = L/2;
left = llr_block(1:half);
right = llr_block(half+1:end);

L_for_v = f_func(left, right);
v_hat = decode_rm_block(L_for_v, m_level-1, r_level-1, f_func, g_func);

g_vals = g_func(left, right, v_hat);
u_hat = decode_rm_block(g_vals, m_level-1, r_level, f_func, g_func);

c_left = mod(u_hat + v_hat, 2);
c = [c_left, v_hat];
end
