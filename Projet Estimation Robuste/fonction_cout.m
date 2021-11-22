function [ valeurs_res ] = fonction_cout(a, b, data_x, data_y, sigma)

a_size = size(a,1);                    % taille des valeurs de a
b_size = size(b,1);                    % taille des valeurs de b

data_size= size(data_x,1);            

 valeurs_res = zeros(a_size,b_size);
 for i=(1:1:a_size)
    for j=(1:1:b_size)
       somme = 0;
       for k=(1:1:data_size)
          somme = somme + penalisation(a(i,j) * data_x(k) + b(i,j) - data_y(k),sigma);
       end
       valeurs_res(i,j) = somme;
    end
 end
end



