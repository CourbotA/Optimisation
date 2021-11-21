close all ; clearvars ; 
load('data.mat');

%% Question 1-2: coût des moindres carrés.

X = cat(2,x,ones(30,1));
Y = y_noisy;
fc= zeros();
f=@(t) (X*t-Y).'*(X*t-Y);
amin = -5 ; bmin = -5;
i=1;j=1;
fc(i,j)=f([amin;bmin]);
Resultmin = f([amin;bmin]);
for a = -5:0.1:10
    j = 1;
    for b = -5:0.1:10
        if( f([a;b]) <= Resultmin)
            Resultmin = f([a;b]) ;
            amin = a;
            bmin = b;
        end
        fc(i,j)=f([a;b]);
        j=j+1;
    end
    i = i+1;
end

[X1,Y1] = meshgrid(-5:0.1:10);

figure(1)
surf(X1,Y1,fc);

%% Question 3

%mise sous forme quadratique du problème précédent
Q = 2*(X.')*X;
B = -2*(Y.')*X;
C = (Y.')*Y;
Q1 = 2*[ sum(x.^2) sum(x)
    sum(x) 30 ];
B1 = [ -2*sum(x.*y_noisy)
        -sum(2*y_noisy)];
C1= sum(y_noisy.^2);

%recherche de solution  x* = -Q^-1*b    
x2 = -inv(Q)*B.' ; 
amin3 = x2(1) ; bmin3 = x2(2) ; 

%% Question 4 

figure(2)
a = linspace(-5,10,151);
b = linspace(-5,10,151);
contour(a,b,fc,151);
hold on;
plot3(bmin3, amin3, 1, 'r - *');
hold off;

%% Question 5
figure(3)
y3 = amin3*x + bmin3 ; 
scatter(x,y_noisy)
hold on;
plot(x,y3);axis on;

 %l'estimateur est très sensible au bruit 
 
%% Question 6
%Fletcher_lemarechal.m ; 
fp= @(t) 2*X.'*(X*t-Y);
x0 = [0;0];
[tmin,it] = Steepest_Descent(f,fp,x0,0.1); 


figure(2)
a = linspace(-5,10,151);
b = linspace(-5,10,151);
contour(a,b,fc,151);
hold on;
plot(it(2,:), it(1,:), 'r - ');
hold off;

%% Question 7
% Representation de la fonction de penalisation pour sigma = 1
penalisation=@(r) 0.5*log(1 + r^2);
dr_penalisation= @(r) 0.5*(2*r)/(1 + r^2) ;
dr2_pealisation= @(r) (1-r^2) / (1+r^2)^2 ; % Convexe pour |r| < 1

xp = [-10:10];
yp = zeros(1,21);
for k = -10:10
    yp(k+11)=penalisation(xp(k+11));
end

figure(4)
plot(xp,yp); title('fonction de penalisation');
%% Question 8 

frob =@(t) sum(arrayfun(penalisation, X*t-Y));
fcrob= zeros();
i=1;j=1;
fcrob(i,j)=frob([-5;-5]);
Resultmin = f([-5;10]);
for a = -5:0.1:10
    j = 1;
    for b = -5:0.1:10
        fcrob(i,j)=frob([a;b]);
        j=j+1;
    end
    i = i+1;
end

%affichage 3D
figure(6)
[X1,Y1] = meshgrid(-5:0.1:10);
figure
surf(X1,Y1,fcrob);

figure(5)
a = linspace(-5,10,151);
b = a;
contour(a,b,fcrob);

%% Question 9

<<<<<<< HEAD
%Pour quand j'aurai resolu le probleme du grad calcule a la main
gradCrob =@(a,b) [sum((x.*(a.*x+b-y_noisy))./(1+a.*x+b-y_noisy));sum((a.*x+b-y_noisy)./(1+a.*x+b-y_noisy))];
%g= zeros(10,10,2);
%i=1;j=1;
%g(i,j)=gradCrob([-3;-3]);
%for a = -3:0.1:7
%    j = 1;
%    for b = -3:0.1:7
%        g(i,j)=[g1,g2];
%        j=j+1;
%    end
%    i = i+1;
%end
=======
r_i =@(a,b) a.*x+b-y_noisy;
gradRobx =@(r) sum(x.*r ./ (1 + r.^2));
gradRoby =@(r) sum(r ./ (1 + r.^2));
gradRob =@(r) [gradRobx(r_i(r(1),r(2))); gradRoby(r_i(r(1),r(2)))];

%gradRob =@(t) GradRob(t,x,y_noisy);
gr = zeros(151,151,2);
gr1= zeros();
gr2= zeros();
i=1;j=1;
gr(i,j)=gradRob([-5;-5]);
for a = -5:0.1:10
    j = 1;
    for b = -5:0.1:10
        gr(i,j)=gradRob([a;b]);
        j=j+1;
    end
    i = i+1;
end

>>>>>>> 00a8ad3293b1a5ba669a5e5a4696fcde755726b9

[g1, g2] = gradient(fcrob);
figure(6)
a = linspace(-5,10,151);
b = linspace(-5,10,151);
quiver(a,b,gr1,gr2); 
hold on 
contour(a,b,fcrob,100); axis equal;
hold off
axis equal ;
%% Question 10

x0 = [0;0];
[tmin,it] = Steepest_Descent(frob,gradRob,x0,0.01); 


figure(2)
a = linspace(-5,10,151);
b = linspace(-5,10,151);
contour(a,b,fcrob,151);
hold on;
plot(it(2,:), it(1,:), 'r - '); axis equal
hold off;

