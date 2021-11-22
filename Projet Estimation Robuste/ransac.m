function [e_moy_min,a,b] = ransac(data_x,data_y,iteration, epsilon, alpha)
%RANSAC Summary of this function goes here
%   Detailed explanation goes here
n = size(data_x,1);
e_moy_min = 1/0;
nb_pts = n * alpha;
data_x_sel = [];
data_y_sel = [];
a = 0;
b=0;
for i=1:iteration
    selection = randi([1,n],1,2);
    x = zeros(1,2);
    y = zeros(1,2);
    for j=1:2
        x(j) = data_x(selection(j));
        y(j) = data_y(selection(j));
    end                      % Calculate Parameter Vector
    a_calc = (y(1) - y(2))/(x(1) - x(2));
    b_calc = y(1) - a_calc * x(1);

    droite = a_calc*data_x + b_calc;
    for j=1:n
        if abs(data_y(j) - droite(j)) < epsilon
            data_x_sel = [data_x_sel data_x(j)];
            data_y_sel = [data_y_sel data_y(j)];
        end
    end
    if size(data_x_sel,2) > nb_pts
        
        % calculons u grâce a l'expression de Q et le gradient de f
    u = [0;0];                                     % Initialisation de u
    u(1,1) = sum(-2 * data_x_sel .* data_y_sel);
    u(2,1) = sum(-2 * data_y_sel);

    % calculons la matrice hessienne :
    Q =[0 0 ; 0 0];                                % Initialisation de Q
    Q(1,1) = sum(2 * data_x_sel .* data_x_sel);
    Q(1,2) = sum(2 * data_x_sel);
    Q(2,1) = Q(1,2);
    Q(2,2) = 2 * length(data_x_sel);

    % c = sum(data.y_noisy.*data.y_noisy);         % non utile dans ce calcul
    % on retrouve le minimim en trouvant la valeur où grad_f(x)=0
    sol_min = Q \ (-u);                             
    a_ = sol_min(1,1);
    b_ = sol_min(2,1);                          % recuperer la position de b minimum
                             
        e_moy = sum((a_ * data_x_sel + b_ - data_y_sel).^2);
        if e_moy < e_moy_min
            e_moy_min = e_moy;
            a = a_;
            b = b_;
        end   
    end
    data_x_sel = [];
    data_y_sel = [];
end

