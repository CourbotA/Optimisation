function [ result ] = CW2( x_k, alpha_k, beta_2, direction_k, data_x, data_y)

numerator = gradient_fonction(x_k(1) + alpha_k * direction_k(1), x_k(2) + alpha_k * direction_k(2), data_x,data_y)' * direction_k;
denominator = gradient_fonction(x_k(1), x_k(2), data_x,data_y)' * direction_k;

if ((numerator / denominator) <= beta_2)
    result = true;
else
    result = false;
end

end