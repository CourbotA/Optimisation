function[grad_a] = gradient_a(a,b,data_x,data_y)
    data_size = size(data_x,1);
    grad_a = sum( (data_x(1:data_size).*(a.*data_x(1:data_size)+b-data_y(1:data_size))) ./ ((1+(a.*data_x(1:data_size)+b-data_y(1:data_size)).^2)) );

end