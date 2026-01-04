function [value, isterminal, direction] = clutch_dl1(~, q)
    dl1 = q(9);  
    value = dl1;
    isterminal = 1;  
    direction = 0;
end