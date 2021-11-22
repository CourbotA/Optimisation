function[val_grad_a,val_grad_b] = gradient_fonction_cout(A,B,data_x,data_y)

a_size = size(A,1);                      % taille des valeurs de a
b_size = size(B,1);                      % taille des valeurs de b

val_grad_a = zeros(a_size,b_size);       % initialisation des valeurs du gradient_a
val_grad_b = zeros(a_size,b_size);       % initialisation des valeurs du gradient_a

% calcule de première composante du gradient :
for i = 1:a_size
    for j = 1:b_size
        val_grad_a(i,j) = gradient_a(A(i,j),B(i,j),data_x,data_y);
    end
end

% calcule de la deuxième composante du gradient :
for i = 1:a_size
    for j = 1:b_size
        val_grad_b(i,j) = gradient_b(A(i,j),B(i,j),data_x,data_y);
    end
end

end