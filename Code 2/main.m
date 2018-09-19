%This script finds the misclassifation rates (numerically) of RLDA and RP+LDA for a randomly generated training set on newly generated test data

clear all
close all
clc

rng default
p=200;%dimension of sample data
n=1000;
k=100;%reduced dimension when applying random projection
delta2=9;%Mahalanobis distance squared
c=0;
kappa=1;
gamma=1;
alpha0=0.5;%because c=0 (see paper for how to compute this from c)
alpha1=1-alpha0;

%specify the common covariance matrix
% Sigma=ones(p)*0.1+eye(p)*0.9; %diagonal entries are 1 and off-diagonal entries are 0.1
Sigma=2*eye(p);
% s=abs(randn(1,p))*10;
% Sigma=diag(s);
    
%generate the training data and compute the statistics (estimates) for training the RLDA classifier
[mu0,mu1,X0,X1,n0,n1]=trainingSampleGenerator(p,n,Sigma,alpha0,delta2);
xBar0=sum(X0,2)/n0; 
xBar1=sum(X1,2)/n1;
C=pooledSampleCovariance(X0,X1,xBar0,xBar1,n0,n1);
H=inv(eye(p)+gamma*C);

%project the training data and compute the statistics (estimates) for training the LDA classifier
[R,U,r]=randProjGaussian(k,p);
X0_RP=R*X0;%project both class training sets to the same subspace
X1_RP=R*X1;
xBar0_RP=sum(X0_RP,2)/n0; 
xBar1_RP=sum(X1_RP,2)/n1;
C_RP=pooledSampleCovariance(X0_RP,X1_RP,xBar0_RP,xBar1_RP,n0,n1);


%generate the test data
n_test=10000;%using stratified sampling as in the training data
n0_test=ceil(alpha0*n_test); %according to the paper, this is how you choose n0 and n1 for a given n when using stratified sampling 
n1_test=n_test-n0_test;
[X0_test,X1_test]=testSampleGenerator(p,n_test,n0_test,n1_test,mu0,mu1,Sigma,Sigma);%in this case I drew samples from the same distribution as the training data 
  
%compute the misclassification rate for each classifier
e_RLDA=classifierRLDA(xBar0,xBar1,H,X0_test,X1_test,n0,n1,n,c,kappa);
X0_test_RP=R*X0_test;%project test data (using same projection) before applying the LDA classifier trained on projected data
X1_test_RP=R*X1_test;
e_RPplusLDA=classifierLDA(xBar0_RP,xBar1_RP,C_RP,X0_test_RP,X1_test_RP,n0_test,n1_test,n_test,c);


