%This function computes the pooled covariance matrix C defined in (3) given
%the training samples, sample means, and number of samples of each class.

function C=pooledSampleCovariance(X0,X1,xBar0,xBar1,n0,n1)
    C0=1/(n0-1)*(X0-xBar0)*(X0-xBar0)';
    C1=1/(n1-1)*(X1-xBar1)*(X1-xBar1)';
    C=((n0-1)*C0+(n1-1)*C1)/(n0+n1-2);
end