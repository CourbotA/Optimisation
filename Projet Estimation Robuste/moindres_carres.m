function[res] = moindres_carres(a,b,data_x,data_y)   % calcul du moindre carré pour un seul couple de parametre (a,b)

data_size= size(data_x,1);         
valeurs = zeros(data_size,1);      % Initialiser le tableau de valeurs

for i=(1:1:data_size)
    valeurs(i) = (a * data_x(i) + b - data_y(i))^2; % remplir le calcul pour chaque i dans le tableau des valeurs 
end
res = sum(valeurs);    % le resultat de la somme de toutes les valeurs 

% cette fonction retourne la valeur du carrés des écarts entre les mesures 