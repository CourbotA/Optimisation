%% Projet d’optimisation continue 
%% Estimation robuste: les M-estimateurs

%% Nom : LOGEAIS et DE LAROCQUE LATOUR
%% Prenom : Thomas et Enguerran

%% 1 Description du problème

clear all; close all;
data = load('data.mat');

% Représentation des données :
figure(1);
plot(data.x,data.y_noisy,'or');title('Jeu de données bruitées du problème');    %% Mesure bruité
xlabel('x');
ylabel('y noisy')
grid();

%Nous remarquons la présence de valeurs très eloignées qui devraient poser
%un problème lorsque nous utilisons un modèle linéaire. 

%% 2 Estimation au sens des moindres carrés

%% Question 1 : Représentation de la fonction de coût dans l'espace de paramètres (a,b)

% nous allons mettre en place la fonction moindre carré qui sera utilisé
% pour calculer la fonction coût dans l'espace de paramètres (a,b)

dbtype('c_moindres_carres.m'); 

[A,B] = meshgrid(0:0.5:20, -10:0.5:10); % Les valeurs de paramètres (a,b) que l'on relève grace à l’analyse de la figure en page 1

fonction_de_cout = c_moindres_carres(A,B,data.x, data.y_noisy); % On récupère la somme des carrés des écarts pour chaque couple de
% paramètres

figure(2); 
contour(A,B,fonction_de_cout,80),colorbar; % nous visualisons 80 lignes de niveaux  
title('Representation 2D de la fonction moindres carres en fonction des parametres a et b');
xlabel('a'); ylabel('b');
legend('somme des carres des ecarts entre les mesures', 'Location','northwest');

figure(3); 
mesh(A,B,fonction_de_cout);     
s.FaceColor = 'flat';
title('Representation 3D de la fonction moindres carres en fonction des parametres a et b');
xlabel('a'); ylabel('b'); zlabel('fonction moindre carres');
legend('somme des carres des ecarts entre les mesures', 'Location','northwest');

%% Commentaire :
% Nous pouvons conclure à la presence d’un minimum global que l'on peut
% estimé à la position (a_min,b_min)=(6.4,-2.3)

%% Question 2 : Détermination une solution approchée par échantillonnage régulier des paramètres a et b

[tous_les_mins, tous_les_positions_mins] = min(fonction_de_cout);    % recuperer les mins de chaque ligne de la fonction ainssi que leurs positions 
 
[min_de_tous_les_mins, pos_ligne_min] = min(tous_les_mins);          % recuperer le min de tous les mins de la fonction ainsi que la ligne où se trouve le min

pos_colonne_min = tous_les_positions_mins(pos_ligne_min);            % recuperer la colonne associé à la ligne où se trouve le min de la fonction 

a_min = A(pos_colonne_min, pos_ligne_min)                            % recuperer la position de a minimum
b_min = B(pos_colonne_min, pos_ligne_min)                            % recuperer la position de b minimum

min_global = min(fonction_de_cout(:))                                % le niveau du min global de la fonction se trouvant en (pos_colonne_min,pos_ligne_min)

%% Question 3 : Determiner l'expression analytique du minimum et calculer avec précision les paramètres a_ et b_
% On cherche Q, u, et c tels que :
% f(x) = f(a,b) = 1/2 * [a b] * Q * [a;b] +u' * [x1;x2] + c 

% On a grad_f(x)= Q * x + u
% le minimun correspond au couple x=(a_,b_) qui annule le gradian

% calculons u grâce a l'expression de Q et le gradient de f
u = [0;0];                                     % Initialisation de u
u(1,1) = sum(-2 * data.x .* data.y_noisy);
u(2,1) = sum(-2 * data.y_noisy);

% calculons la matrice hessienne :
Q =[0 0 ; 0 0];                                % Initialisation de Q
Q(1,1) = sum(2 * data.x .* data.x);
Q(1,2) = sum(2 * data.x);
Q(2,1) = Q(1,2);
Q(2,2) = 2 * length(data.x);

% c = sum(data.y_noisy.*data.y_noisy);         % non utile dans ce calcul
% on retrouve le minimim en trouvant la valeur où grad_f(x)=0
sol_min = Q \ (-u);                             
a_ = sol_min(1,1);
b_ = sol_min(2,1);
    
%% Question 4 : Représentation du minimum sur la fonction de coût

figure(4);
contour(A,B,fonction_de_cout,80),colorbar; % nous visualison 80 lignes de niveaux  
title('Representation 2D de la fonction moindres carres en fonction des parametres a et b');
xlabel('a'); ylabel('b');
hold on;
plot(a_, b_, 'r+');
legend('somme des carres des ecarts entre les mesures','le minimum');
hold off;

%% Question 5 : Tracer la courbe d'équations y = a_*x + b_ avec les (a_,b_) obtenus

X = linspace(min(data.x),max(data.x),90);
Y = a_.* X + b_;

figure(5);
plot(data.x,data.y_noisy,'or');   % mesure bruitées 
xlabel('x');
ylabel('y noisy');
grid();
hold on;
plot(X,Y,'g-'); title('droite de l''estimateur');
plot([2.321 2.807 3.124 3.431 -0.04992],[38.13 50.1 57.09 64.24 -16.46],'b-');
legend('mesures bruitées','Modèle linéaire', 'droite traversant les 5 points aberant', 'Location','northwest');
hold off; 

%% 3 Estimation robuste

%% Question 6 : 
% code pour la méthode des plus fortes pente et determination d'alpha avec
% fletcher_lemarechal

dbtype('plus_forte_pente.m');
dbtype('fletcher_lemarechal.m');
dbtype('CW1.m');
dbtype('CW2.m');

%% Exemple avec la fonction de cout des moindres carres
[A,B] = meshgrid(0:0.5:20, -10:0.5:10);

fonction_de_cout = c_moindres_carres(A,B,data.x, data.y_noisy);

epsilon = 10^(-3);
x_0 = [8 8];             % point de depart ( choisi pour avoir un nb d'iteration >100 )
[a_k,b_k, k] = plus_forte_pente(x_0, data.x, data.y_noisy, epsilon);

figure(6);
contour(A,B,fonction_de_cout,20),colorbar;
title('méthode des plus fortes pente pour les moindres carrés');
xlabel('a'); ylabel('b');
hold on;
plot(a_k, b_k, 'r-');
nb_iter = sprintf("Le nombre d\'itération pour retrouver la solution est : %d ",k);
legend(nb_iter);
hold off;


figure(7);
contour(A,B,fonction_de_cout,20),colorbar;axis([3 9 -4 2])
title('méthode des plus fortes pente pour les moindres carrés zoomé');
xlabel('a'); ylabel('b');
hold on;
plot(a_k, b_k, 'r-');
nb_iter = sprintf("Le nombre d\'iteration pour converger vers le centre est : %d ",k);
legend(nb_iter);
hold off;

%% Représenter la fonction de pénalisation pour sigma = 1. 
dbtype('penalisation.m'); % la fonction pénalisation de Cauchy

% Nous traçons la fonction pour des résidus valant de -100 à 100 et avec un
% facteur de pénalisation unitaire.
X = linspace(-100,100,200);
sigma = 1;

fonction_penalisation = penalisation(X,sigma);
figure(6);
plot(X,fonction_penalisation);
xlabel('Résidus');
ylabel('fonction de pénalisation');
legend('Pénalisation de Cauchy en fonction du résidu pour sigma = 1', 'Location','northwest');
grid();

%% Calculer les deux premières dérivées. 
X = linspace(-20,20,200);

derive_fs= X./(sigma^2 + X.*X);                                         % calcul de la derivée 1ere
derive_sd= (sigma^2 - X.*X)./((sigma^2 + X.*X).*(sigma^2 + X.*X));      % calcul de la derivée seconde 

plot(X,fonction_penalisation);
xlabel('Résidus');
ylabel('fonction de pénalisation');
hold on;
plot(X,derive_fs,'-g');
plot(X,derive_sd,'-r');
legend('Pénalisation de Cauchy en fonction du résidu pour sigma = 1','derivée 1ere','derivée seconde', 'Location','north');
hold off;
grid();

%% La fonction de penalisation de cauchy est-elle convexe?
% Non la fonction n'est pas convexe car : 
% Si nous prenons un point a de residu proche de 0 et un autre point b de
% residu élevé et que l'on trace une droite qui traverse les 2 on remarque
% que le segement n'est pas au dessus de la courbe de la fonction. cela
% signifie que la fonction n'est pas convexe sur R. 

%% Question 7 : Représenter la nouvelle fonction de coût dans l'espace des paramètres (a,b)
dbtype('fonction_cout.m');

sigma = 1;
[A,B] = meshgrid(-10:0.5:10, -10:0.5:10);

fonction_d_cout = fonction_cout(A,B,data.x,data.y_noisy,sigma);

figure(7);
contour(A,B,fonction_d_cout,15),colorbar;
title('Representation 2D de la fonction cout');
xlabel('a'); ylabel('b');
hold on;
plot(a_, b_, 'r+');              % representer le min avec les paramètres a_ et b_
legend('representation de la fonction cout','min', 'Location','northwest');
hold off;

figure(8);
mesh(A,B,fonction_d_cout),colorbar;
s.FaceColor = 'flat';
title('Representation 3D de la fonction de cout');
xlabel('a'); ylabel('b'); zlabel('fonction cout');

% comme on s'en doutait le minimun avec les paramètres a_ et b_ ne coincide pas avec le minimun de la
% nouvelle fonction cout 

%% Question 8 : 

%% Calculer (à la main) le gradient de la fonction de coût
dbtype('gradient_a.m');
dbtype('gradient_b.m');


%% Question 9 : Representer le gradiant de la fonction cout
[A,B] = meshgrid(-10:0.5:10, -10:0.5:10);

[valeurs_grad_a,valeurs_grad_b]=gradient_fonction_cout(A,B,data.x,data.y_noisy);

figure(9);
hold on;
quiver(A,B,valeurs_grad_a,valeurs_grad_b);axis equal; axis([-2 8 -5 5]);
title('Representation le grandient de la fonction cout');
contour(A,B,fonction_d_cout,10),colorbar;axis equal; axis([-2 8 -5 5]);
xlabel('a'); ylabel('b');
hold off;


% le gradient est bien orthogonal aux lignes de niveau.

%% Question 10 :

%% Implémentez la méthode des plus fortes pentes en réalisant l’étape de recherche linéaire avec l’algorithme de Fletcher-Lemaréchal

dbtype('plus_forte_pente.m');
dbtype('fletcher_lemarechal.m');
dbtype('CW1.m');
dbtype('CW2.m');

%% Représentez la succession des itérés sur la représentation de la fonction de coût
epsilon = 10^(-3);
x_0 = [6 6];             % point de depart ( choisi pour avoir un nb d'iteration >100 )
[a_k,b_k, k] = plus_forte_pente(x_0, data.x, data.y_noisy, epsilon);

figure(10);
contour(A,B,fonction_d_cout,20),colorbar;
title('methode des plus fortes pente');
xlabel('a'); ylabel('b');
hold on;
plot(a_k, b_k, 'r-');
nb_iter = sprintf("Le nombre d\'iteration pour retrouver la solution est : %d ",k);
legend(nb_iter);
hold off;


figure(11);
contour(A,B,fonction_d_cout,20),colorbar;axis([2 4 -2 0])
title('methode des plus fortes pente zoomé');
xlabel('a'); ylabel('b');
hold on;
plot(a_k, b_k, 'r-');
nb_iter = sprintf("Le nombre d\'iteration pour converger vers le centre est : %d ",k);
legend(nb_iter);
hold off;

% nous remarquons que plus nous nous rapprochons de la solution, plus cette
% méthode a du mal à la trouver et demande beaucoup d’itérations.


%% Distance entre itérés en fonction de l'itération.
iteration = linspace(1,k,k);                    % axe des abscisse 
distance_iteres = zeros(k,1);                   % initialiser le tableau d'iteration 
for i = 1:k
   v1 = [a_k(i) b_k(i)] ;
   v2 = [a_k(i + 1) b_k(i + 1)];
   distance_iteres(i) = abs(norm(v2) - norm(v1));
end

figure(12);
plot(iteration, distance_iteres);
legend('Évolution de la distance entre iteres en fonction de l itération','location','northeast');
xlabel('iteration'); ylabel('distance entre iteres');
grid();

% Nous remarquons que nous nous approchons très rapidement de la solution
% au début de l’algorithme. Mais rapidement les écarts ne sont plus
% significatifs et l’approximation de la solution reste la même

%% Évolution de la fonction de coût et de la norme du gradient en fonction de l'itération.
iteration = linspace(1,k,k);           % abscisse
y_k_fonction_cout = zeros(k,1);        % valeurs de la fonction cout 
y_k_norme_grad = zeros(k,1);           % valeurs de la norme du gradient de la fonction 

for i = 1:k
    y_k_fonction_cout(i) = fonction_cout(a_k(i),b_k(i), data.x,data.y_noisy,1);      % appliquer le fonction cout a chaque iteres
    y_k_norme_grad(i) = norm(gradient_fonction(a_k(i),b_k(i),data.x,data.y_noisy));      % calculer le gradiant a chaque iteres
end

figure(13);
subplot(2,1,1);
plot(iteration, y_k_fonction_cout);
legend('Évolution de la fonction de coût en fonction de l itération');
xlabel('iteration'); ylabel('fonction cout');
grid()

subplot(2,1,2);
plot(iteration, y_k_norme_grad);
legend('Évolution de la norme du gradient en fonction de l itération');
xlabel('iteration'); ylabel('norme du gradiant');
grid()

% Nous remarquons que la fonction de coût atteint très rapidement son
% minimum et reste ensuite plus ou moins constante contrairement à son
% gradient qui connait quelques variations dues au changement de direction.

%% Distance à la solution trouvée en fonction de l'itération
iteration = linspace(1,k,k);
distances_k = zeros(k,1);

v_k = [a_k(k) b_k(k)];
for i = 1:k
    v_i = [a_k(i) b_k(i)];
    distances_k(i) = abs(norm(v_k) - norm(v_i));
end

figure(14);
plot(iteration, distances_k);
legend('la distance à la solution finale en fonction de l''itération');
xlabel('iteration'); ylabel('distance');
grid()

% nous remarquons que la courbe n’est pas strictement monotone et que sa
% distance de départ est conditionnée par le point de départ
% sélectioné.


% La fonction de coût reste monotone et globalement
%décroissante tandis que la norme du gradient peut connaître de grandes
%fluctuations mais finira toujours par tendre vers 0.


%% Question 11 : Répétez cette étude pour d’autres points de départ

% J'ai décidé de tester avec 3 points très different afin d'evoluer la
% performence de cette algorithme 

%% Point loin 
sigma = 1;
[A,B] = meshgrid(-15:0.5:15, -20:0.5:10);

fonction_d_cout = fonction_cout(A,B,data.x,data.y_noisy,sigma);

x_0 = [-9 9];             
[a_k,b_k, k] = plus_forte_pente(x_0, data.x, data.y_noisy, epsilon);

figure(15);
contour(A,B,fonction_d_cout,20),colorbar;
title('methode des plus fortes pente');
xlabel('a'); ylabel('b');
hold on;
plot(a_k, b_k, 'r-');
nb_iter = sprintf("Le nombre d\'iteration pour retrouver la solution est : %d ",k);
legend(nb_iter);
hold off;

% Distance entre itérés en fonction de l'itération.
iteration = linspace(1,k,k);                    % axe des abscisse 
distance_iteres = zeros(k,1);                   % initialiser le tableau d'iteration 
for i = 1:k
   v1 = [a_k(i) b_k(i)] ;
   v2 = [a_k(i + 1) b_k(i + 1)];
   distance_iteres(i) = abs(norm(v2) - norm(v1));
end

figure(16);
plot(iteration, distance_iteres);
legend('Évolution de la distance entre iteres en fonction de l itération','location','northeast');
xlabel('iteration'); ylabel('distance entre iteres');
grid();

% Évolution de la fonction de coût et de la norme du gradient en fonction de l'itération.
iteration = linspace(1,k,k);           % abscisse
y_k_fonction_cout = zeros(k,1);        % valeurs de la fonction cout 
y_k_norme_grad = zeros(k,1);           % valeurs de la norme du gradient de la fonction 

for i = 1:k
    y_k_fonction_cout(i) = fonction_cout(a_k(i),b_k(i), data.x,data.y_noisy,1);      % appliquer le fonction cout a chaque iteres
    y_k_norme_grad(i) = norm(gradient_fonction(a_k(i),b_k(i),data.x,data.y_noisy));      % calculer le gradiant a chaque iteres
end

figure(17);
subplot(2,1,1);
plot(iteration, y_k_fonction_cout);
legend('Évolution de la fonction de coût en fonction de l itération');
xlabel('iteration'); ylabel('fonction cout');
grid()

subplot(2,1,2);
plot(iteration, y_k_norme_grad);
legend('Évolution de la norme du gradient en fonction de l itération');
xlabel('iteration'); ylabel('norme du gradiant');
grid()

% Distance à la solution trouvée en fonction de l'itération
iteration = linspace(1,k,k);
distances_k = zeros(k,1);

v_k = [a_k(k) b_k(k)];
for i = 1:k
    v_i = [a_k(i) b_k(i)];
    distances_k(i) = abs(norm(v_k) - norm(v_i));
end

figure(18);
plot(iteration, distances_k);
legend('la distance à la solution finale en fonction de l''itération');
xlabel('iteration'); ylabel('distance');
grid()

% On remarque que l'algorithme est très puissant du fait que même avec un
% point très loin, la methode permet de trouver la solution en utilisant
% tout de même beaucoup plus d'iterations.


%% Point (a_,b_) retrouvé à la question 3 
sigma = 1;
[A,B] = meshgrid(-10:0.5:10, -10:0.5:10);

fonction_d_cout = fonction_cout(A,B,data.x,data.y_noisy,sigma);

x_0 = [6.9585 -2.3803];             
[a_k,b_k, k] = plus_forte_pente(x_0, data.x, data.y_noisy, epsilon);

figure(19);
contour(A,B,fonction_d_cout,20),colorbar;
title('methode des plus fortes pente (point question 3)');
xlabel('a'); ylabel('b');
hold on;
plot(a_k, b_k, 'r-');
nb_iter = sprintf("Le nombre d\'iteration pour retrouver la solution est : %d ",k);
legend(nb_iter);
hold off;

% Distance entre itérés en fonction de l'itération.
iteration = linspace(1,k,k);                    % axe des abscisse 
distance_iteres = zeros(k,1);                   % initialiser le tableau d'iteration 
for i = 1:k
   v1 = [a_k(i) b_k(i)] ;
   v2 = [a_k(i + 1) b_k(i + 1)];
   distance_iteres(i) = abs(norm(v2) - norm(v1));
end

figure(20);
plot(iteration, distance_iteres);
legend('Évolution de la distance entre iteres en fonction de l itération','location','northeast');
xlabel('iteration'); ylabel('distance entre iteres');
grid();

% Évolution de la fonction de coût et de la norme du gradient en fonction de l'itération.

iteration = linspace(1,k,k);           % abscisse
y_k_fonction_cout = zeros(k,1);        % valeurs de la fonction cout 
y_k_norme_grad = zeros(k,1);           % valeurs de la norme du gradient de la fonction 

for i = 1:k
    y_k_fonction_cout(i) = fonction_cout(a_k(i),b_k(i), data.x,data.y_noisy,1);      % appliquer le fonction cout a chaque iteres
    y_k_norme_grad(i) = norm(gradient_fonction(a_k(i),b_k(i),data.x,data.y_noisy));      % calculer le gradiant a chaque iteres
end

figure(21);
subplot(2,1,1);
plot(iteration, y_k_fonction_cout);
legend('Évolution de la fonction de coût en fonction de l itération');
xlabel('iteration'); ylabel('fonction cout');
grid()

subplot(2,1,2);
plot(iteration, y_k_norme_grad);
legend('Évolution de la norme du gradient en fonction de l itération');
xlabel('iteration'); ylabel('norme du gradiant');
grid()

% Distance à la solution trouvée en fonction de l'itération
iteration = linspace(1,k,k);
distances_k = zeros(k,1);

v_k = [a_k(k) b_k(k)];
for i = 1:k
    v_i = [a_k(i) b_k(i)];
    distances_k(i) = abs(norm(v_k) - norm(v_i));
end

figure(22);
plot(iteration, distances_k);
legend('la distance à la solution finale en fonction de l\itération');
xlabel('iteration'); ylabel('distance');
grid()

%% Point proche
x_0 = [3 -1];             
[a_k,b_k, k] = plus_forte_pente(x_0, data.x, data.y_noisy, epsilon);

figure(23);
contour(A,B,fonction_d_cout,20),colorbar;
title('methode des plus fortes pente (point proche)');axis([2 4 -2 0]);
xlabel('a'); ylabel('b');
hold on;
plot(a_k, b_k, 'r-');
nb_iter = sprintf("Le nombre d\'iteration pour retrouver la solution est : %d ",k);
legend(nb_iter);
hold off;

% Distance entre itérés en fonction de l'itération.
iteration = linspace(1,k,k);                    % axe des abscisse 
distance_iteres = zeros(k,1);                   % initialiser le tableau d'iteration 
for i = 1:k
   v1 = [a_k(i) b_k(i)] ;
   v2 = [a_k(i + 1) b_k(i + 1)];
   distance_iteres(i) = abs(norm(v2) - norm(v1));
end

figure(24);
plot(iteration, distance_iteres);
legend('Évolution de la distance entre iteres en fonction de l itération','location','northeast');
xlabel('iteration'); ylabel('distance entre iteres');
grid();

% Évolution de la fonction de coût et de la norme du gradient en fonction de l'itération.
sigma = 1;
iteration = linspace(1,k,k);           % abscisse
y_k_fonction_cout = zeros(k,1);        % valeurs de la fonction cout 
y_k_norme_grad = zeros(k,1);           % valeurs de la norme du gradient de la fonction 

for i = 1:k
    y_k_fonction_cout(i) = fonction_cout(a_k(i),b_k(i), data.x,data.y_noisy,1);      % appliquer le fonction cout a chaque iteres
    y_k_norme_grad(i) = norm(gradient_fonction(a_k(i),b_k(i),data.x,data.y_noisy));      % calculer le gradiant a chaque iteres
end

figure(25);
subplot(2,1,1);
plot(iteration, y_k_fonction_cout);
legend('Évolution de la fonction de coût en fonction de l itération');
xlabel('iteration'); ylabel('fonction cout');
grid()

subplot(2,1,2);
plot(iteration, y_k_norme_grad);
legend('Évolution de la norme du gradient en fonction de l itération');
xlabel('iteration'); ylabel('norme du gradiant');
grid()

% Distance à la solution trouvée en fonction de l'itération
iteration = linspace(1,k,k);
distances_k = zeros(k,1);

v_k = [a_k(k) b_k(k)];
for i = 1:k
    v_i = [a_k(i) b_k(i)];
    distances_k(i) = abs(norm(v_k) - norm(v_i));
end

figure(26);
plot(iteration, distances_k);
legend('la distance à la solution finale en fonction de l itération');
xlabel('iteration'); ylabel('distance');
grid()

% Malgré un conditionnement assez bon, et bien que la méthode reste
% puissante, on a quand même eu besoin de 91 itérations pour arriver au
% même résultat.

%% test avec un point de fort gradiant
% on récupère un point d'une itération qui est "partie" d'un point loin et
% on prend un point proche de la valeur finale.
x_0 = [3.168 -1.067];             
[a_k,b_k, k] = plus_forte_pente(x_0, data.x, data.y_noisy, epsilon);

figure(23);
contour(A,B,fonction_d_cout,20),colorbar;
title('methode des plus fortes pente (point proche)');axis([2 4 -2 0]);
xlabel('a'); ylabel('b');
hold on;
plot(a_k, b_k, 'r-');
nb_iter = sprintf("Le nombre d\'iteration pour retrouver la solution est : %d ",k);
legend(nb_iter);
hold off;

% Distance entre itérés en fonction de l'itération.
iteration = linspace(1,k,k);                    % axe des abscisse 
distance_iteres = zeros(k,1);                   % initialiser le tableau d'iteration 
for i = 1:k
   v1 = [a_k(i) b_k(i)] ;
   v2 = [a_k(i + 1) b_k(i + 1)];
   distance_iteres(i) = abs(norm(v2) - norm(v1));
end

figure(24);
plot(iteration, distance_iteres);
legend('Évolution de la distance entre iteres en fonction de l itération','location','northeast');
xlabel('iteration'); ylabel('distance entre iteres');
grid();

% Évolution de la fonction de coût et de la norme du gradient en fonction de l'itération.
sigma = 1;
iteration = linspace(1,k,k);           % abscisse
y_k_fonction_cout = zeros(k,1);        % valeurs de la fonction cout 
y_k_norme_grad = zeros(k,1);           % valeurs de la norme du gradient de la fonction 

for i = 1:k
    y_k_fonction_cout(i) = fonction_cout(a_k(i),b_k(i), data.x,data.y_noisy,1);      % appliquer le fonction cout a chaque iteres
    y_k_norme_grad(i) = norm(gradient_fonction(a_k(i),b_k(i),data.x,data.y_noisy));      % calculer le gradiant a chaque iteres
end

figure(25);
subplot(2,1,1);
plot(iteration, y_k_fonction_cout);
legend('Évolution de la fonction de coût en fonction de l itération');
xlabel('iteration'); ylabel('fonction cout');
grid()

subplot(2,1,2);
plot(iteration, y_k_norme_grad);
legend('Évolution de la norme du gradient en fonction de l itération');
xlabel('iteration'); ylabel('norme du gradiant');
grid()

% Distance à la solution trouvée en fonction de l'itération
iteration = linspace(1,k,k);
distances_k = zeros(k,1);

v_k = [a_k(k) b_k(k)];
for i = 1:k
    v_i = [a_k(i) b_k(i)];
    distances_k(i) = abs(norm(v_k) - norm(v_i));
end

figure(26);
plot(iteration, distances_k);
legend('la distance à la solution finale en fonction de l itération');
xlabel('iteration'); ylabel('distance');
grid()

%% Question 12 : 
dbtype('quasi_newton.m');

%% Appliquez la méthode de quasi-Newton à cette fonction de coût.

epsilon = 10^(-3);
x_0 = [6 6]';

[solution, a_k,b_k, k] = quasi_newton(x_0, data.x, data.y_noisy, epsilon );

figure(27);
contour(A,B,fonction_d_cout,20);
title('methode de quasi-newton');
xlabel('a'); ylabel('b');
hold on;
plot(a_k, b_k, 'r-');
nb_iter = sprintf("Le nombre d''iteration pour retrouver la solution est : %d ",k);
legend(nb_iter);
hold off;

%% Distance entre itérés en fonction de l'itération.
iteration = linspace(1,k,k);                    % axe des abscisse 
distance_iteres = zeros(k,1);                   % initialiser le tableau d'iteration 
for i = 1:k-2
   v1 = [a_k(i) b_k(i)] ;
   v2 = [a_k(i + 1) b_k(i + 1)] ;
   distance_iteres(i) = abs(norm(v2) - norm(v1));
end

figure(28);
plot(iteration, distance_iteres,'r-');
legend('Évolution de la distance entre iteres en fonction de l itération','location','northeast');
xlabel('iteration'); ylabel('distance entre iteres');
grid();


%% Évolution de la fonction de coût et de la norme du gradient en fonction de l'itération.
iteration = linspace(1,k,k);           % abscisse
y_k_fonction_cout = zeros(k,1);        % valeurs de la fonction cout 
y_k_norme_grad = zeros(k,1);           % valeurs de la norme du gradient de la fonction 

for i = 1:k
    y_k_fonction_cout(i) = fonction_cout(a_k(i),b_k(i), data.x,data.y_noisy,1);      % appliquer le fonction cout a chaque iteres
    y_k_norme_grad(i) = norm(gradient_fonction(a_k(i),b_k(i),data.x,data.y_noisy));      % calculer le gradiant a chaque iteres
end

figure(29);
subplot(2,1,1);
plot(iteration, y_k_fonction_cout);
legend('Évolution de la fonction de coût en fonction de l itération');
xlabel('iteration'); ylabel('fonction cout');
grid()

subplot(2,1,2);
plot(iteration, y_k_norme_grad);
legend('Évolution de la norme du gradient en fonction de l itération');
xlabel('iteration'); ylabel('norme du gradiant');
grid()


%% Distance à la solution trouvée en fonction de l'itération
iteration = linspace(1,k,k);
distances_k = zeros(k,1);

v_k = [a_k(k) b_k(k)];
for i = 1:k
    v_i = [a_k(i) b_k(i)];
    distances_k(i) = abs(norm(v_k) - norm(v_i));
end

figure(30);
plot(iteration, distances_k);
legend('la distance à la solution finale en fonction de l\itération');
xlabel('iteration'); ylabel('distance');
grid()

% la méthode de quasi-Newton est beaucoup plus performante que
% la méthode des plus fortes pentes car elle permet en seulement 13 itérations
% de converger vers le minimum global.
% Le gradient tend très rapidement vers 0 aussi.  
%% avec le point loin
epsilon = 10^(-3);
x_0 = [-8 9]';

[solution, a_k,b_k, k] = quasi_newton(x_0, data.x, data.y_noisy, epsilon );

figure(27);
contour(A,B,fonction_d_cout,20);
title('methode de quasi-newton');
xlabel('a'); ylabel('b');
hold on;
plot(a_k, b_k, 'r-');
nb_iter = sprintf("Le nombre d''iteration pour retrouver la solution est : %d ",k);
legend(nb_iter);
hold off;

%% Distance entre itérés en fonction de l'itération.
iteration = linspace(1,k,k);                    % axe des abscisse 
distance_iteres = zeros(k,1);                   % initialiser le tableau d'iteration 
for i = 1:k-2
   v1 = [a_k(i) b_k(i)] ;
   v2 = [a_k(i + 1) b_k(i + 1)] ;
   distance_iteres(i) = abs(norm(v2) - norm(v1));
end

figure(28);
plot(iteration, distance_iteres,'r-');
legend('Évolution de la distance entre iteres en fonction de l itération','location','northeast');
xlabel('iteration'); ylabel('distance entre iteres');
grid();


%% Évolution de la fonction de coût et de la norme du gradient en fonction de l'itération.
iteration = linspace(1,k,k);           % abscisse
y_k_fonction_cout = zeros(k,1);        % valeurs de la fonction cout 
y_k_norme_grad = zeros(k,1);           % valeurs de la norme du gradient de la fonction 

for i = 1:k
    y_k_fonction_cout(i) = fonction_cout(a_k(i),b_k(i), data.x,data.y_noisy,1);      % appliquer le fonction cout a chaque iteres
    y_k_norme_grad(i) = norm(gradient_fonction(a_k(i),b_k(i),data.x,data.y_noisy));      % calculer le gradiant a chaque iteres
end

figure(29);
subplot(2,1,1);
plot(iteration, y_k_fonction_cout);
legend('Évolution de la fonction de coût en fonction de l itération');
xlabel('iteration'); ylabel('fonction cout');
grid()

subplot(2,1,2);
plot(iteration, y_k_norme_grad);
legend('Évolution de la norme du gradient en fonction de l itération');
xlabel('iteration'); ylabel('norme du gradiant');
grid()


%% Distance à la solution trouvée en fonction de l'itération
iteration = linspace(1,k,k);
distances_k = zeros(k,1);

v_k = [a_k(k) b_k(k)];
for i = 1:k
    v_i = [a_k(i) b_k(i)];
    distances_k(i) = abs(norm(v_k) - norm(v_i));
end

figure(30);
plot(iteration, distances_k);
legend('la distance à la solution finale en fonction de l\itération');
xlabel('iteration'); ylabel('distance');
grid()
%% Question 13 :
sigma = 1;
[A,B] = meshgrid(-10:0.5:10, -10:0.5:10);

fonction_d_cout = fonction_cout(A,B,data.x,data.y_noisy,sigma);

x_0 = [6.9585 -2.3803];             
[a_k,b_k, k] = plus_forte_pente(x_0, data.x, data.y_noisy, epsilon);

X = linspace(min(data.x),max(data.x),90);
Y = a_.* X + b_;
Yn = a_k(size(a_k,1)) * X + b_k(size(b_k,1));

figure(31);
hold on;
plot(data.x,data.y_noisy,'or');
plot(X,Y,'-g');
plot(X,Yn);
legend('Mesures bruitées','ajustement moindres carrés','ajustement robuste', 'Location', 'northwest');
title('Comparaison entre modele lineaire et modèle robuste 1');
xlabel('x');
ylabel('y noisy')
hold off;
grid();

%% avec a = -8, b = 9
x_0 = [-9 9];

[a_k,b_k, k] = plus_forte_pente(x_0, data.x, data.y_noisy, epsilon);

Yn = a_k(size(a_k,1)) * X + b_k(size(b_k,1));

figure(32);
hold on;
plot(data.x,data.y_noisy,'or');
plot(X,Y,'-g');
plot(X,Yn);
legend('Mesures bruitées','ajustement moindres carrés','ajustement robuste', 'Location', 'northwest');
title('Comparaison entre modele lineaire et modèle robuste 2');
xlabel('x');
ylabel('y noisy')
hold off;
grid();

%La méthode de quasi-newton converge correctement vers la solution pour
%différents valeurs de a et b

%% étudiez l’influence du paramètres σ de la pénalisation de Cauchy.

% Nous traçons la fonction pour des résidus valant de -100 à 100 et avec un
% facteur de pénalisation unitaire.
X = linspace(-100,100,200);

fonction_penalisation0 = penalisation(X,0.1);
fonction_penalisation1 = penalisation(X,1);
fonction_penalisation30 = penalisation(X,30);

fonction_d_cout0 = fonction_cout(A,B,data.x,data.y_noisy,0.1);
fonction_d_cout1 = fonction_cout(A,B,data.x,data.y_noisy,1);
fonction_d_cout30 = fonction_cout(A,B,data.x,data.y_noisy,30);

figure(33);
subplot(1,2,1);
contour(A,B,fonction_d_cout0,15); axis equal
title('Representation 2D de la fonction cout avec sigma=0.1');
xlabel('a'); ylabel('b');
hold on 
subplot(1,2,2);
plot(X,fonction_penalisation0); 
xlabel('Résidus');
ylabel('fonction de pénalisation');
legend('Pénalisation de Cauchy en fonction du résidu pour sigma = 0.1', 'Location','northwest');
grid();
hold off

figure(34);
subplot(1,2,1);
contour(A,B,fonction_d_cout1,15); axis equal
title('Representation 2D de la fonction cout avec sigma=1');
xlabel('a'); ylabel('b');
hold on 
subplot(1,2,2);
plot(X,fonction_penalisation1); 
xlabel('Résidus');
ylabel('fonction de pénalisation');
legend('Pénalisation de Cauchy en fonction du résidu pour sigma = 1', 'Location','northwest');
grid();
hold off

figure(35);
subplot(1,2,1);
contour(A,B,fonction_d_cout30,15); axis equal
title('Representation 2D de la fonction cout avec sigma=30');
xlabel('a'); ylabel('b');
hold on 
subplot(1,2,2);
plot(X,fonction_penalisation30); 
xlabel('Résidus');
ylabel('fonction de pénalisation');
legend('Pénalisation de Cauchy en fonction du résidu pour sigma = 30', 'Location','northwest');
grid();
hold off

%Plus sigma augmente, plus la pente est faible et aplatie proche du zéro
%et avec des pénalisations en sortie plus faible.

%% Question 15 (bonus)
% Algorithme RANSAC itérations = 1000, epsilon = 1 et alpha = 1/2
epsilon = 10^(-3);
x_0 = [-8 9]';

[solution, a_k,b_k, k] = quasi_newton(x_0, data.x, data.y_noisy, epsilon );

X = linspace(min(data.x),max(data.x),90);
Y = solution(1).* X + solution(2);

[e_moy,a,b] = ransac(data.x, data.y_noisy, 1000, 1, 1/2);
Yn = a * X + b;

figure(32);
hold on;
plot(data.x,data.y_noisy,'or');
plot(X,Y,'-g');
plot(X,Yn);
legend('Mesures bruitées','ajustement robuste','ajustement ransac', 'Location', 'northwest');
title('Comparaison entre modele lineaire et modèle ransac');
xlabel('x');
ylabel('y noisy')
hold off;
grid();
%% Conclusion 

% Le modèle des moindre carrés est un modèle lineaire donc moin prècis car
% il prends en compte toutes les variables dont les points aberants. Les
% methodes d'estimation robuste tel que le quasi-newton et la méthode des
% plus fortes pente evitent le decalage en haut de la courbe induit par ces
% valeurs aberantes puisqu'elles ne les prennent pas 
% compte.Il en résulte un modèle qui est très proche de nos valeurs.

