%This function returns the true error or plugin error of RLDA according to equations (1)
%and (9)
function e=trueErrorRLDA(alpha0,alpha1,mu0,mu1,Sigma,xBar0,xBar1,H,c,kappa)
    eps0=normcdf((-functionG(mu0,xBar0,xBar1,H)+c/kappa)/sqrt(functionD(xBar0,xBar1,H,Sigma)));
    eps1=normcdf((functionG(mu1,xBar0,xBar1,H)-c/kappa)/sqrt(functionD(xBar0,xBar1,H,Sigma)));
    e=alpha0*eps0+alpha1*eps1;
end