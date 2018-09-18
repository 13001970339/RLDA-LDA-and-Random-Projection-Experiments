%This script generates 'noTrainingSets' number of training sample sets (for each value in a set of values of n) for which the
%following error estimators for RLDA error (in addition to the true error) are computed:
%RLDA plug-in error estimator, RLDA resubstitution error, and the proposed generalized consistent error
%estimator for RLDA. In addition, we have the resubstitution error estimator for random projection follwed by LDA. 
%The deviation variance and expectation of each estimator are computed based on the
%1000 trials and plotted separately.
%This generates a single plot (corresponding to a single p and Mahalanobis distance) of error metric against n from Figure 1. 

%%%%%%The error metrics are relative to the RLDA true error%%%%%%

close all
clear all
clc
rng default

p=150;%dimension of sample data
r=10;%reduced dimension when applying random projection
vector_n=[30 50 70 90 110 130 150]';%vector of varying total number of samples
noTrainingSets=1000;%we will estimate error over these training sets
delta2=9;%Mahalanobis distance squared
c=0;
kappa=1;
gamma=1;
alpha0=0.5;%because c=0 (see paper for how to compute this from c)
alpha1=1-alpha0;


vector_trueErrorRLDA=zeros(noTrainingSets,1);
vector_pluginErrorRLDA=zeros(noTrainingSets,1);
vector_dasymEst=zeros(noTrainingSets,1);
vector_resubError_RLDA=zeros(noTrainingSets,1);
vector_resubError_randProjGaussianLDA=zeros(noTrainingSets,1);
vector_expectedError=zeros(length(vector_n),5);
vector_variance=zeros(length(vector_n),5);
vector_devVariance=zeros(length(vector_n),4);%this does not apply to true error
vector_bias=zeros(length(vector_n),4);%this does not apply to true error
vector_RMS=zeros(length(vector_n),4);%this does not apply to true error

for i=1:length(vector_n)
   for trainingSetNo=1:noTrainingSets
       [mu0,mu1,Sigma,X0,X1,n0,n1]=trainingSampleGenerator(p,vector_n(i),alpha0,delta2); %generate training samples and determine their statistics
       
       %compute mean and covariance matrix estimates
       xBar0=sum(X0,2)/n0; 
       xBar1=sum(X1,2)/n1;
       C=pooledSampleCovariance(X0,X1,xBar0,xBar1,n0,n1);
       H=inv(eye(p)+gamma*C);
       
       %compute true error of RLDA
       vector_trueErrorRLDA(trainingSetNo)=trueErrorRLDA(alpha0,alpha1,mu0,mu1,Sigma,xBar0,xBar1,H,c,kappa);
       %compute plug-in error of RLDA
       vector_pluginErrorRLDA(trainingSetNo)=pluginErrorRLDA(alpha0,alpha1,xBar0,xBar1,C,H,c,kappa);
       %compute generalized consistent estimator (double asymptotic) 
       vector_dasymEst(trainingSetNo)=dasymEst(alpha0,alpha1,n0,n1,xBar0,xBar1,C,H,c,kappa,gamma);
       %compute resubstitution error of RLDA
       vector_resubError_RLDA(trainingSetNo)=resubError_RLDA(xBar0,xBar1,H,X0,X1,n0,n1,vector_n(i),c,kappa);
       %compute the resubstitution error of random projection with a
       %Gaussian matrix followed by lDA
       vector_resubError_randProjGaussianLDA(trainingSetNo)=resubError_randProjGaussianLDA(r,X0,X1,n0,n1,vector_n(i),c);
       
   end
   vector_expectedError(i,1)=mean(vector_trueErrorRLDA); %rows correspond to specific n values while columns correspond to specific estimators
   vector_expectedError(i,2)=mean(vector_pluginErrorRLDA);
   vector_expectedError(i,3)=mean(vector_dasymEst);
   vector_expectedError(i,4)=mean(vector_resubError_RLDA);
   vector_expectedError(i,5)=mean(vector_resubError_randProjGaussianLDA);
   vector_bias(i,1)=vector_expectedError(i,2)-vector_expectedError(i,1);
   vector_bias(i,2)=vector_expectedError(i,3)-vector_expectedError(i,1);
   vector_bias(i,3)=vector_expectedError(i,4)-vector_expectedError(i,1);
   vector_bias(i,4)=vector_expectedError(i,5)-vector_expectedError(i,1);
   
   vector_variance(i,1)=var(vector_trueErrorRLDA);%rows correspond to specific n values while columns correspond to specific estimators
   vector_variance(i,2)=var(vector_pluginErrorRLDA);
   vector_variance(i,3)=var(vector_dasymEst);
   vector_variance(i,4)=var(vector_resubError_RLDA);
   vector_variance(i,5)=var(vector_resubError_randProjGaussianLDA);
   cov12=corr(vector_trueErrorRLDA,vector_pluginErrorRLDA)*sqrt(vector_variance(i,1)*vector_variance(i,2));
   cov13=corr(vector_trueErrorRLDA,vector_dasymEst)*sqrt(vector_variance(i,1)*vector_variance(i,3));
   cov14=corr(vector_trueErrorRLDA,vector_resubError_RLDA)*sqrt(vector_variance(i,1)*vector_variance(i,4));
   cov15=corr(vector_trueErrorRLDA,vector_resubError_randProjGaussianLDA)*sqrt(vector_variance(i,1)*vector_variance(i,5));
   
   vector_devVariance(i,1)=vector_variance(i,1)+vector_variance(i,2)-2*cov12;%note that the true error column is omitted here
   vector_devVariance(i,2)=vector_variance(i,1)+vector_variance(i,3)-2*cov13;
   vector_devVariance(i,3)=vector_variance(i,1)+vector_variance(i,4)-2*cov14;
   vector_devVariance(i,4)=vector_variance(i,1)+vector_variance(i,5)-2*cov15;
   vector_RMS(i,1)=sqrt(vector_bias(i,1)^2+vector_devVariance(i,1)^2);
   vector_RMS(i,2)=sqrt(vector_bias(i,2)^2+vector_devVariance(i,2)^2);
   vector_RMS(i,3)=sqrt(vector_bias(i,3)^2+vector_devVariance(i,3)^2);
   vector_RMS(i,4)=sqrt(vector_bias(i,4)^2+vector_devVariance(i,4)^2);
end

plot(repmat(vector_n,1,5),vector_expectedError)
title('Expected error')
legend('true error','plug-in','dasym-est','resub-RLDA','resub-RPgaussLDA')
figure
plot(repmat(vector_n,1,4), vector_devVariance)
title('Deviation variance')
legend('plug-in','dasym-est','resub-RLDA','resub-RPgaussLDA')
figure
plot(repmat(vector_n,1,4),vector_RMS)
title('RMS')
legend('plug-in','dasym-est','resub-RLDA','resub-RPgaussLDA')
