function [xres] = Quasi_Newton(f,gradf,xk,Hk_1,eps)
%initialisation
    
    while ~(gradf(xk)<= eps) 
    %calcul de la direction dk
    dk = - Hk_1*gradf(xk);

    %Recherche du pas
    ak = Fletcher_Lemarechal(f,df,x,dk);
    
    % calcul du nouvel xk
    xk_1 = xk+ak*dk;

    %mise a jours de Hk_1
    Hk_1 = ( gradf(xk_1)-gradf(xk) )/(xk_1 - xk) ; 
    xk=xk_1;
    end
    xres = xk;
end