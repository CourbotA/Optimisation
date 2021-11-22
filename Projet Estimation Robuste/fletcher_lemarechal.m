function [ alpha_approxi ] = fletcher_lemarechal(x_k, direction_k, data_x, data_y)


alpha_0 = 0.1;
beta_1 = 0.1;
beta_2 = 0.99;
alpha_i = alpha_0;
alpha_l = 0;
alpha_r = 1/0;
lambda = 20;

while ( (CW1(x_k, alpha_i, beta_1, direction_k, data_x, data_y) == false) || ((CW2(x_k, alpha_i, beta_2, direction_k, data_x, data_y) == false)) )

    if (CW1(x_k, alpha_i, beta_1, direction_k, data_x, data_y))
        alpha_l = alpha_i;
        if ( alpha_r < 1/0)
            alpha_i = (alpha_l + alpha_r) / 2;
        else
            alpha_i = lambda * alpha_i;
        end
    else
        alpha_r = alpha_i;
        alpha_i = (alpha_l + alpha_r) / 2;
    end
end
alpha_approxi = alpha_i;
end

