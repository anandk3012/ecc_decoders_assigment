function x = RMmmencode(u, m)
    if m==1
        x = [u(1)+u(2) u(2)];
    else
        x = [RMmmencode(u(1:2:end)+u(2:2:end), m-1), RMmmencode(u(2:2:end), m-1)];
    end
end