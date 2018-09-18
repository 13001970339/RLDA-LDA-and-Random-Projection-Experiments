%This function generates the 2-class training data according to protocol 1. It also
%returns the means, the common covariance matrix of the two classes, and the
%number of samples of each class computed based on the provided alpha0.
%It takes p, n, alpha0, alpha1 and the squared Mahalanobis distance
%and based on this, computes the mean of each class. The classes are
%sampled from multivariate Gaussian distributions with these means and a
%common covariance matrix defined as specified in protocol 1.
%Class 0 samples are contained in the columns of X0 and class 1 samples are
%contained in the columns of X1

function [mu0,mu1,Sigma,X0,X1,n0,n1]=trainingSampleGenerator(p,n,alpha0,delta2)
   %compute the common covariance matrix
    Sigma=ones(p)*0.1+eye(p)*0.9; %diagonal entries are 1 and off-diagonal entries are 0.1
%     Sigma=eye(p);
    
    %compute the class means
    one=ones(p,1);
    a=sqrt(delta2/(4*one'*inv(Sigma)*one));
    mu0=a*one;
    mu1=-mu0;
    
    %generate training data
    n0=ceil(alpha0*n); %according to the paper, this is how you choose n0 and n1 for a given n when using stratified sampling 
    n1=n-n0;
    X0=mvnrnd(mu0,Sigma,n0)';
    X1=mvnrnd(mu0,Sigma,n1)';
end