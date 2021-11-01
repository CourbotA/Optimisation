function [xres] = Fletcher_lemarechal(f,fp,x0,eps,p)
% Fletcher_lemarechal prend une fonction f, son gradient fp, un point de
% depart x0 et un seuil eps pour retourner la coordonnee qui minimise la
% fonction avec la methode des plus fortes pentes.

xk = x0;
while (abs(fp(xk))> eps)
  dk = -fp(xk); 
  ak = p;
  xk2 = xk;
  while (f(xk2)> f(xk2+p*dk))
    xk2 = xk2 + p*dk;
  end
  xk = xk + ak*dk;
end
    xres = xk; 
end