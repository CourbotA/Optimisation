function[valeurs_res] = c_moindres_carres(a,b,data_x,data_y)   % calcule de la fonction côut en parcourant differents paramettre (a,b)

a_size = size(a,1);                    % taille des valeurs de a
b_size = size(b,1);                    % taille des valeurs de b

valeurs_res = zeros(a_size,b_size);    % initialiser le tableau des valeurs du calcule de moindre carres  

for i=(1:1:a_size)
    for j=(1:1:b_size)
        valeurs_res(i,j) = moindres_carres(a(i,j),b(i,j),data_x,data_y);   % calcul du moindre carres pour chaque couple (a,b)
    end
end

% cette fonction prend en entrée les données à analyser et une série de
% valeurs pour les paramètres a et b du modèle linéaire. Elle renvoie en sortie la
% somme des carrés des écarts entre les mesures et le modèle linéaire pour
% toutes les valeurs de paramètres indiquées  