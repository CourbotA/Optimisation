close all ; clearvars ; 
load('data.mat');
%% Question 1-2: coût des moindres carrés.
fc= zeros();
f=@(a,b) sum( (a.*x + b -y_noisy).^2 ) ;
amin = -50 ; bmin = -50;
i=1;j=1;
fc(i,j)=f(amin,bmin);
Resultmin = f(amin,bmin);
for a = -49:0.1:50
    i+=1;
    for b = -49:0.1:50
       j+=1;
        if( f(a,b) <= Resultmin)
            Resultmin = f(a,b) ;
            amin = a;
            bmin = b;
        end
        f(i,j)=f(a,b);
    end
end


%% Question 3

%mise sous forme quadratique du problème précédent
Q = 2*[ sum(x.^2) sum(x)
    sum(x) 30 ];
B = [ -2*sum(x.*y_noisy)
        -sum(2*y_noisy)];
    C= sum(y_noisy.^2);

%recherche de solution  x* = -Q^-1*b    
x2 = -inv(Q)*B ; 
amin3 = x2(1) ; bmin3 = x2(2) ; 

%% Question 4 

%% Question 5
y3 = amin3*x + bmin3 ; 
scatter(x,y_noisy)
hold on;
plot(x,y3);
 %l'estimateur est très sensible au bruit 
 
%% Question 6
