function [xres] = Quasi_Newton(f,gradf,x0,H0_1,eps)
%initialisation
xk = x0;
Hk_1 = H0_1;

%calcul de la direction dk
dk = - Hk_1*gradf(xk)

%Recherche du pas

end
