function G = RMmmgenerator(m)
    n=2^m;
    
    G=zeros(n, n);
    
    for i=1:1:n
        ui = zeros(1,n);
        ui(i)=1;
        G(i,:)=RMmmencode(ui, m);
    end
end