%This function returns the plugin error of RLDA according to equations (1)
%and (14)
function e=pluginErrorRLDA(alpha0,alpha1,xBar0,xBar1,C,H,c,kappa)
    eps0=normcdf((-functionG(xBar0,xBar0,xBar1,H)+c/kappa)/sqrt(functionD(xBar0,xBar1,H,C)));
    eps1=normcdf((functionG(xBar1,xBar0,xBar1,H)-c/kappa)/sqrt(functionD(xBar0,xBar1,H,C)));
    e=alpha0*eps0+alpha1*eps1;
end