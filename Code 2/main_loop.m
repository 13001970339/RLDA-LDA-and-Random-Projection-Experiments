%this is main.m implemented as a loop for different values of k (the dimension of the projected subspace)


clear all
close all
clc

rng default 
p=200;%dimension of sample data
n=50;
delta2=9;%Mahalanobis distance squared
c=0;
kappa=1;
gamma=1;
alpha0=0.5;%because c=0 (see paper for how to compute this from c)
alpha1=1-alpha0;
M=100;

%specify the common covariance matrix
%Sigma=eye(p)*0.2; %diagonal entries are 1 and off-diagonal entries are 0.1
xr=[1:p]';
rho=0.5;
% eyematrix=eye(p);
% Xm=randn(p,round(sqrt(p)));
% Sigma=eyematrix+Xm*Xm'/p;
Sigma=2*eye(p);
% Sigma=0.01*Sigma;
% Sigma=rho.^(abs(xr*ones(1,p)-ones(p,1)*xr'));
% Sigma=eye(p);
% s=abs(randn(1,p))*10;
% Sigma=diag(s);
    
%generate the training data and compute the statistics (estimates) for training the RLDA classifier
[mu0,mu1,X0,X1,n0,n1]=trainingSampleGenerator(p,n,Sigma,alpha0,delta2);
xBar0=sum(X0,2)/n0; 
xBar1=sum(X1,2)/n1;
C=pooledSampleCovariance(X0,X1,xBar0,xBar1,n0,n1);
rankC=rank(C);
k=1:1:rank(C);%reduced dimension when applying random projection
H=inv(eye(p)+gamma*C);

error_RLDA=zeros(size(k));
error_LDA=zeros(size(k));
error_RPplusLDA=zeros(size(k));
error_RPplusLDAEnsemble=zeros(size(k));

%generate the test data
n_test=50000;%using stratified sampling as in the training data
n0_test=ceil(alpha0*n_test); %according to the paper, this is how you choose n0 and n1 for a given n when using stratified sampling 
n1_test=n_test-n0_test;
[X0_test,X1_test]=testSampleGenerator(p,n_test,n0_test,n1_test,mu0,mu1,Sigma,Sigma);%in this case I drew samples from the same distribution as the training data 

%h = waitbar(0,'Executing...');
parfor i=1:length(k)
    %project the training data and compute the statistics (estimates) for training the LDA classifier
    mu_diff=xBar0-xBar1;
%     [R,U,r]=randProjGaussian(k(i),p,mu_diff);
    ensemble=randn(k(i),p,M)/sqrt(k(i));%to store all of the random matrices
    R=ensemble(:,:,1);
    X0_RP=R*X0;%project both class training sets to the same subspace
    X1_RP=R*X1;
    xBar0_RP=sum(X0_RP,2)/n0; 
    xBar1_RP=sum(X1_RP,2)/n1;
    C_RP=pooledSampleCovariance(X0_RP,X1_RP,xBar0_RP,xBar1_RP,n0,n1);
%     H_RP=inv(C_RP*0.1+eye(k(i)));
    H_RP=inv(C_RP);
    %compute the misclassification rate for ensemble
    error_RPplusLDAEnsemble(i)=classifierEnsembleRPplusLDA(ensemble,X0,X1,X0_test,X1_test,k(i),p,M,mu_diff,n0,n1,n0_test,n1_test,n_test);%RP+LDA ensemble
    %project test data (using same projection) before applying the LDA classifier trained on projected data
    X0_test_RP=R*X0_test;
    X1_test_RP=R*X1_test;
    error_RPplusLDA(i)=classifierLDA(xBar0_RP,xBar1_RP,H_RP,X0_test_RP,X1_test_RP,n0_test,n1_test,n_test,c);%RP+LDA 
    %waitbar(i/length(k),h)
end
%compute the misclassification error rate for RLDA(doesn't change with k)
error_RLDA=error_RLDA+classifierRLDA(xBar0,xBar1,H,X0_test,X1_test,n0_test,n1_test,n_test,c,kappa);%RLDA
error_LDA=error_LDA+classifierLDA(xBar0,xBar1,pinv(C),X0_test,X1_test,n0_test,n1_test,n_test,c);%pinv(C) is the true inverse when C is invertible and the pseudoinverse when it is singular
figure
plot(k,error_LDA,k,error_RLDA,k,error_RPplusLDA,k,error_RPplusLDAEnsemble)
legend('LDA','RLDA','RP+LDA','RP+LDA ensemble')
xlabel('Projected subspace dimension k')
ylabel('Misclassification rate')