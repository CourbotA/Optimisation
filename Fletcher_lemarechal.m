function [alpha] = Fletcher_lemarechal(f,df,x,dk)
% initialiasation
alphal=0;alphar=3; alphai = 0.001 ;
lambda = 20; beta1 =0.3 ; beta2= 0.5; 
    gamma = -beta1*df(x)'*dk ;  
    
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

        while ~( CW1(alphai) && CW2(alphai) )
            % deux contions respectées : STOP
           
            if (CW1(alphai)) %Pas trop court
                alphal=alphai;
                alphai=(alphal+alphar)/2 ; 
                if alphar > 100
                    alphai=lambda*alphai;
                end
            else %Pas trop Long
                alphar=alphai;
                alphai=(alphal+alphar)/2;
            end  
        end
         alpha = alphai ; 
end

