%This function projects a given matrix of samples onto a subspace of dimension r randomly
%generated according to a standard Gaussian distribution

function X_RP=randProjGaussian(X,r)
    %generate a random matrix whose entries are independent Gaussian rv's
    %of zero mean and unit variance
    [rows,~]=size(X);
    R=randn(r,rows);
    
    %project onto the randomly generated subspace
    X_RP=R*X;
end