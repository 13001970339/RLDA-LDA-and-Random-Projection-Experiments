%This function computes the proposed generalized (double asymptotic) consistent estimator
%of the true error according to (1) and (12)

function e=dasymEst(alpha0,alpha1,n0,n1,xBar0,xBar1,C,H,c,kappa,gamma)
    p=length(xBar0);
    delta=(p/(n0+n1-2)-trace(H)/(n0+n1-2))/(gamma*(1-p/(n0+n1-2)+trace(H)/(n0+n1-2)));
    eps0=normcdf((-functionG(xBar0,xBar0,xBar1,H)+(n0+n1-2)*delta/n0+c/kappa)/sqrt((1+gamma*delta)^2*functionD(xBar0,xBar1,H,C)));
    eps1=normcdf((functionG(xBar1,xBar0,xBar1,H)+(n0+n1-2)*delta/n1-c/kappa)/sqrt((1+gamma*delta)^2*functionD(xBar0,xBar1,H,C)));
    e=alpha0*eps0+alpha1*eps1;
end