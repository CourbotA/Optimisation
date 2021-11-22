function [a_approxi, b_approxi, k] = plus_forte_pente( x_0, data_x, data_y, epsilon )

x_k = x_0;
k = 0;
iter1 = true;                         % premiere iteration
a_approxi=[x_k(1)];                   % tableau des differentes solutions de a
b_approxi=[x_k(2)];                   % tableau des differentes solutions de b


while ((iter1 == true) || ( norm(gradient_fonction(x_k(1),x_k(2),data_x,data_y)) > epsilon) )
    iter1 = false;
    k = k + 1;
    d_k = - gradient_fonction(x_k(1), x_k(2),data_x, data_y);
    
    alpha_k = fletcher_lemarechal(x_k,d_k, data_x, data_y);

    x_k = x_k + alpha_k * d_k';
    
    a_approxi=[a_approxi;x_k(1)];
    b_approxi=[b_approxi;x_k(2)];
end

