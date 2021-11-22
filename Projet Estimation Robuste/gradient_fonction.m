function[grad] = gradient_fonction(a,b,x,y)
    grad_a = gradient_a(a,b,x,y);
    grad_b = gradient_b(a,b,x,y); 
    grad = [grad_a;grad_b];
%     X = ones(size(x,1), 2);
%     X(:,1) = x;
%     grad = 2 * X' * ( X* [a b]' - y);
end