function Rex=Rex_Hyper(da,w1,di,fi,ki,r2i)
% calculate Rex HyperCEST solution for pool i
ka  =   ki*fi;
Rex =   -((ka.*ki.*w1.^2.*((-da+di).^2 + (r2i.*(da.^2 + (ka + ki).^2 + ki.*r2i + w1.^2))./ki))./...
        ((ka + ki).*(di.^2.*w1.^2 + ka.*r2i.*w1.^2) + ...
        (ka + ki).*((da.*di - ka.*r2i).^2 + (di.*ka + da.*(ki + r2i)).^2 + ...
        (ka + ki + r2i).^2.*w1.^2) + (ka + ki + r2i).*(da.^2.*w1.^2 + w1.^4)));
end
