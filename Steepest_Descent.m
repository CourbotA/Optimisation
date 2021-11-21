function [xres, iteres, dist, valf, valdf] = Steepest_Descent(f,fp,x0,eps)
% Fletcher_lemarechal prend une fonction f, son gradient fp, un point de
% depart x0 et un seuil eps pour retourner la coordonnee qui minimise la
% fonction avec la methode des plus fortes pentes.

iteres = [x0];
dist = [0];
valf = [f(x0)];
valdf = [norm(fp(x0))];
xk = x0;
temp = xk;
while (abs(fp(xk))> eps)
  dk = -fp(xk); %recherche de la direction Optimale
  ak=Fletcher_lemarechal(f,fp,x0,dk); % Recherche du pas optimal
  temp = xk;
  xk = xk + ak.*dk;
  iteres = [iteres xk];
  dist = [dist norm(xk-temp)];
  valf = [valf f(xk)];
  valdf = [valdf norm(fp(xk))];
end
xres = xk ;  
end

