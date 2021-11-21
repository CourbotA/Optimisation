function [alpha] = Fletcher_lemarechal(f,df,x,dk)
% initialiasation
alphal=0;alphar=inf; alphai = 0.0001 ;
lambda = 40; beta1 =1E-3 ; beta2= 0.99; 
 gamma = -beta1*df(x)'.*dk ; 
    
        function [bool] = CW1(alphai) %condition de wolf 1 
           
            bool = false ; 
                if (f(x + alphai*dk)<= f(x) - alphai*gamma )
                    bool = true;
                    
                end
        end


        function [bool] = CW2(alphai) %condition de wolf 2
            bool = false ;  
                if ( df(x+alphai*dk)'*dk <= df(x)'*dk*beta2 )
                    bool = true;
                end
        end
    sortir = false ; 
        boucle =1;
     % deux contions respectées : STOP
          while ( sortir == false ) 
           sortir =( CW1(alphai) && CW2(alphai) ) ;
         boucle = boucle +1;
         if (boucle>20)
            sortir = true ; 
         end
         if (CW1(alphai)) %Pas trop court
                 alphal=alphai;  
                if alphar < inf
                     alphai=(alphal+alphar)/2;
                else
                   alphai=lambda*alphai;
                end
                                      
            else %Pas trop Long
                 alphar=alphai;
                alphai=(alphal+alphar)/2;
                end  
         end
         alpha = alphai ; 
end

