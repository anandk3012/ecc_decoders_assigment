function x = Polarencode(m, A, msg)  
    n = 2^m;
    k = length(A);
    u = zeros(n, 1);
    
    u(A) = msg;
    
    x = RMmmencode(m, u);
end