function [alpha] = Fletcher_lemarechal(f,df,x,dk)
% initialiasation
alpha_0 = 0.1;
beta_1 = 0.1;
beta_2 = 0.99;
alpha_i = alpha_0;
alpha_l = 0;
alpha_r = 1/0;
lambda = 20;
    
        function [bool] = CW1(alpha_i) %condition de wolf 1 
           gamma = - beta_1 * df(x)' .* dk;
            bool = false ; 
                if ( f(x + alpha_i.*dk) <= f(x) - alpha_i*gamma )
                    bool = true;
                end
        end


        function [bool] = CW2(alpha_i) %condition de wolf 2
            bool = false ;  
                if ( (df(x+alpha_i*dk)'* dk / (df(x)'*dk)) <= beta_2 )
                    bool = true;
                end
        end
i=1;
     % deux contions respectées : STOP
          while (( CW1(alpha_i) == false || CW2(alpha_i) == false ) || i<=20 )
               i = i+1 ; 
               if (CW1(alpha_i)) %Pas trop court
                  alpha_l = alpha_i;
                  if ( alpha_r < 1/0)
                        alpha_i = (alpha_l + alpha_r) / 2;
                  else
                        alpha_i = lambda * alpha_i;
                  end
                                      
               else %pas trop long
                    alpha_r = alpha_i;
                    alpha_i = (alpha_l + alpha_r) / 2;
                end
          end
alpha = alpha_i ; 
end

