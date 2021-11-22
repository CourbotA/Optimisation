function [xres] = Quasi_Newton(f,gradf,xk,eps)
%initialisation
I = eye(size(xk,1));
invH=I;

    
   while (abs(gradf(xk))> eps)
    %calcul de la direction dk
    dk = - invH*gradf(xk);

    %Recherche du pas
    ak = Fletcher_lemarechal(f,gradf,xk,dk,1);
    
    % calcul du nouvel xk
    xk_1 = xk+ak*dk;

    %maj de la matrice H
    yk_1 = gradf(xk_1) - gradf(xk) ; 
    dk_1 = xk_1 -xk ; 
    invH = (I- (dk_1*yk_1')/(dk_1'*yk_1) )*invH*(I- (yk_1*dk_1')/(dk_1'*yk_1) ) + (dk_1*dk_1')/(dk_1'*yk_1) ;
    xk = xk_1;
    
    end
    xres = xk;
end