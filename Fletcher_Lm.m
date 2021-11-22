function [alpha] = Fletcher_Lm(f, grad_f, x_k, alpha_i)
    alpha=alpha_i;
    d_k = - grad_f(x_k);
    infini = 1e15;
    beta_1 = 1e-3;
    beta_2 = 0.99;
    alpha_r = infini;
    alpha_l = 0;
    gamma = - beta_1 * ( grad_f(x_k) )' * d_k;
    lambda = 20;
    
    Imax = 200; %Iterations max
    
    value_find = false;
    i = 0;
    
    %CW1 = @() f(x_k + alpha_i * d_k) <= f(x_k) - alpha_i * gamma;
    %CW2 = @() ( (grad_f(x_k + alpha_i * d_k)).' * d_k ) / ( (grad_f(x_k)).' * d_k ) <= beta_2; 
    
    while(~value_find && i<=Imax)
        if( f(x_k + alpha * d_k) <= f(x_k) - alpha * gamma )
            if( ( (grad_f(x_k + alpha * d_k)).' * d_k ) / ( (grad_f(x_k)).' * d_k ) <= beta_2 )
                value_find = true;
            else
                alpha_l = alpha;
                if (alpha_r < infini)
                    alpha = ( alpha_l + alpha_r )/2;
                else
                    alpha = lambda * alpha;
                end
                
            end
        else
            alpha_r = alpha;
            alpha = ( alpha_l + alpha_r )/2;
        end
        i = i + 1;
    end
    
end