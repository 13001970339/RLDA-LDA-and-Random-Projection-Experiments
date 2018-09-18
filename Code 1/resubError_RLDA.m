%This function computes the resubstitution error of RLDA, i.e. the error
%rate obtained when RLDA classification is applied to the training data
%(same training data as test data)

function e=resubError_RLDA(xBar0,xBar1,H,X0,X1,n0,n1,n,c,kappa)
    e=classifierRLDA(xBar0,xBar1,H,X0,X1,n0,n1,n,c,kappa);
end