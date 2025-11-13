function x = RMencode(r, m, msg)
    n = 2^m;
    
    mondegs = m-sum(de2bi(0:n-1, m), 2);
    A = find(mondegs <= r);
    x = Polarencode(m, A, msg);
end