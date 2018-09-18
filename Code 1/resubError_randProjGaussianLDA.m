%This function performs a random projection on sample data followed by LDA.
%The return argument is the resubstitution error.
 
function e=resubError_randProjGaussianLDA(r,X0,X1,n0,n1,n,c)
    %project both class data sets to the same subspace
    X=[X0,X1]; 
    X_RP=randProjGaussian(X,r);
    X0_RP=X_RP(:,1:n0);
    X1_RP=X_RP(:,n0+1:end);
    
    %determine statistic estimates
    xBar0=sum(X0_RP,2)/n0; 
    xBar1=sum(X1_RP,2)/n1;
    C=pooledSampleCovariance(X0_RP,X1_RP,xBar0,xBar1,n0,n1);
    
    %perform LDA on the projected sample data to estimate the error
    e=classifierLDA(xBar0,xBar1,C,X0_RP,X1_RP,n0,n1,n,c);
end