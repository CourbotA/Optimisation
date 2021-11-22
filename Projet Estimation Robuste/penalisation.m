function [res] = penalisation(r, sigma)           % fonction qui prend en entree un reel r et le paramètre de la pénalisation sigma
res = (1/2) .* log(1 + ((r .* r) /(sigma .* sigma)));
end