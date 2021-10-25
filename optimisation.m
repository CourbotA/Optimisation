close all ; clearvars ; 
load('data.mat');

%% Question 1-2: coût des moindres carrés.

fc= zeros();
f=@(a,b) sum( (a.*x + b -y_noisy).^2 ) ;
amin = -3 ; bmin = -3;
i=1;j=1;
fc(i,j)=f(amin,bmin);
Resultmin = f(amin,bmin);
for a = -3:0.1:7
    j = 1;
    for b = -3:0.1:7
        if( f(a,b) <= Resultmin)
            Resultmin = f(a,b) ;
            amin = a;
            bmin = b;
        end
        fc(i,j)=f(a,b);
        j=j+1;
    end
    i = i+1;
end

[X1,Y1] = meshgrid(-3:0.1:7);

figure(1)
surf(X1,Y1,fc);

%% Question 3

%mise sous forme quadratique du problème précédent
X = cat(2,x,ones(30,1));
Y = y_noisy;
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
a = linspace(-10,10,101);
b = linspace(-10,10,101);
contour(a,b,fc,100);
hold on;
plot3(bmin3, amin3, 1, 'r - *');
hold off;

%% Question 5
y3 = amin3*x + bmin3 ; 
scatter(x,y_noisy)
hold on;
plot(x,y3);

 %l'estimateur est très sensible au bruit 
 
%% Question 6

