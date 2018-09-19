%This function generates the 2-class ttest data given the statistics of each class and their covariance matrices.
%The classes are sampled from multivariate Gaussian distributions with these means and covariances.
%Class 0 samples are contained in the columns of X0 and class 1 samples are
%contained in the columns of X1


function [X0,X1]=testSampleGenerator(p,n,n0,n1,mu0,mu1,Sigma1,Sigma2)
    %generate testing data
    X0=mvnrnd(mu0,Sigma1,n0)';
    X1=mvnrnd(mu1,Sigma2,n1)';
end