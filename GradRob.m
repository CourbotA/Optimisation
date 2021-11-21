function [g1,g2] = GradRob(t,x,y_noisy)
    a = t(1);
    b = t(2);
    g1 = 0;
    g2 = 0;
    for i=1:size(x)
    g1 = g1 + (x(i).*(a.*x(i)+b-y_noisy(i)))./(1+(a.*x(i)+b-y_noisy(i))^2);
    g2 = g2 + (a.*x(i)+b-y_noisy(i))./(1+(a.*x(i)+b-y_noisy(i))^2);
    end
end
