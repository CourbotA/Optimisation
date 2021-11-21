function [xres, iteres] = Steepest_Descent(f,fp,x0,eps)
% Fletcher_lemarechal prend une fonction f, son gradient fp, un point de
% depart x0 et un seuil eps pour retourner la coordonnee qui minimise la
% fonction avec la methode des plus fortes pentes.

iteres = [x0];
xk = x0;
while (abs(fp(xk))> eps)
  dk = -fp(xk); %recherche de la direction Optimale
  ak=Fletcher_Lemarechal(f,fp,x0,dk); % Recherche du pas optimal
  xk = xk + ak.*dk;
  iteres = [iteres xk];
end
xres = xk ;  
end

