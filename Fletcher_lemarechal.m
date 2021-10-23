function [] = Fletcher_lemarechal(f,tau,x0,eps)
xk = x0;
  s= tau; 
    if ( -1 <= xk < 0 )
        s = - tau ; 
    end
    
    Result = f(xk + s
      
end