function [xres] = Fletcher_lemarechal(f,fp,x0,eps)
% Fletcher_lemarechal prend une fonction f, son gradient fp, un point de
% depart x0 et un seuil eps pour retourner la coordonnee qui minimise la
% fonction avec la methode des plus fortes pentes.

xk = x0;
while (abs(fp(xk))> eps)
  dk = -fp(xk); 
  ak = 0; %Recherche de ak tq f(xk + ak*dk) soit min 
  xk = xk + ak*dk;
end
    xres = xk   
end