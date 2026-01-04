function [value, isterminal, direction] = enddouble(t, q)
global odetimes;
    [~, lambda] = rimless_double(t, q);
    value(1) = lambda(4);
	isterminal(1) = 1;
	direction(1) = -1;
    if odetimes<10
          value(1) =1000;
    end
end