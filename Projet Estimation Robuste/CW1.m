function [ result ] = CW1(x_k, alpha_k, beta_1, direction_k, data_x, data_y)


gamma = - beta_1 * gradient_fonction(x_k(1),x_k(2),data_x,data_y)' * direction_k;
terme_g = fonction_cout( x_k(1) + alpha_k * direction_k(1),x_k(2) + alpha_k * direction_k(2), data_x, data_y ,1) - fonction_cout( x_k(1), x_k(2),data_x, data_y,1);
% terme_g = c_moindres_carres( x_k(1) + alpha_k * direction_k(1),x_k(2) + alpha_k * direction_k(2), data_x, data_y ) - c_moindres_carres( x_k(1), x_k(2),data_x, data_y);
terme_d = - alpha_k * gamma;

if (terme_g <= terme_d)
    result = true;
else
    result = false;
end

end