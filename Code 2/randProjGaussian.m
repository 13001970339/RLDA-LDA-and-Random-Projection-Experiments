%This function projects a given matrix of samples onto a subspace of dimension r randomly
%generated according to a standard Gaussian distribution

function [R,U,r]=randProjGaussian(k,p,mu_diff)
    %generate a random matrix whose entries are independent Gaussian rv's
    %of zero mean and unit variance
    %%vec=mu_diff*sqrt(k);
    temp=randn(k,p);
    %%temp=[vec';temp];
    %Q=orth(temp');%orthogonalize the rows of temp
    %U=(Q./vecnorm(Q))';%normalize Q by the columns of Q (the rows of Q') and transpose to give U
    %r=rank(temp);
    R=temp/sqrt(k);%R has normalized variance
U=R;
r=rank(temp);
end
