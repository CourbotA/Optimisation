function [solution,approxi_a,approxi_b, k]=quasi_newton(approxi,data_x,data_y,epsilon)

% configuration initiale

I=eye(size(approxi,1));
invH=I;                        % approximation de A
approxi_a=approxi(1);          % tableau des valeurs de a 
approxi_b=approxi(2);          % tableau des valeurs de b
k=1;


while(norm(gradient_fonction(approxi(1),approxi(2),data_x,data_y))>=epsilon)
direction=-invH*gradient_fonction(approxi(1),approxi(2),data_x,data_y);
alpha=fletcher_lemarechal(approxi,direction, data_x,data_y);
approxi=approxi+alpha.*direction;

approxi_a=[approxi_a;approxi(1)];
approxi_b=[approxi_b;approxi(2)];

k=k+1;
y=gradient_fonction(approxi_a(k),approxi_b(k),data_x,data_y)-gradient_fonction(approxi_a(k-1),approxi_b(k-1),data_x,data_y);
d(1,1)=approxi_a(k)-approxi_a(k-1);
d(2,1)=approxi_b(k)-approxi_b(k-1);

invH=((I-((d*y')./(d'*y)))*invH*(I-((y*d')./(d'*y))))+(((d*d')./(d'*y)));
end 
solution=approxi;