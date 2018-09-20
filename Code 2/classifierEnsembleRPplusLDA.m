%This function numerically computes the misclassification error of the randomly
%projected LDA classifier ensemble defined in "Random Projections as Regularizers:
%Learning a Linear Discriminant Ensemble from Fewer Observations than Dimensions"
%The same training data is randomly projected into M random subspaces. An
%LDA classifier is trained on each of the projected data sets. 

function e=classifierEnsembleRPplusLDA(ensemble,X0,X1,X0_test,X1_test,k,p,M,mu_diff,n0,n1,n0_test,n1_test,n_test)
    sumC0=zeros(1,n0_test);
    sumC1=zeros(1,n1_test);
    %for each random matrix in the ensemble, project the training data,
    %train the classifier, project the test data, compute the discriminant for each test point, and add the contributions to sumC0 and sumC1
    %of that particular point
    for i=1:M
        R=ensemble(:,:,i);
        X0_RP=R*X0;%project both class training sets to the same subspace
        X1_RP=R*X1;
        xBar0_RP=sum(X0_RP,2)/n0; 
        xBar1_RP=sum(X1_RP,2)/n1;
        C_RP=pooledSampleCovariance(X0_RP,X1_RP,xBar0_RP,xBar1_RP,n0,n1);
        H_RP=inv(C_RP);
        %project test points
        X0_test_RP=R*X0_test;
        X1_test_RP=R*X1_test;
        %test points
        for q=1:n0_test%discriminant assumes c=0
            sumC0(q)=sumC0(q)+(X0_test_RP(:,q)-(xBar0_RP+xBar1_RP)/2)'*H_RP*(xBar0_RP-xBar1_RP);
        end
        for q=1:n1_test
            sumC1(q)=sumC1(q)+(X1_test_RP(:,q)-(xBar0_RP+xBar1_RP)/2)'*H_RP*(xBar0_RP-xBar1_RP);
        end
    end
    
    %average discriminants to obtain ensemble discriminants and classify
    ensembleDiscriminants_X0_test=1/M*sumC0;%each entry is the ensemble discriminant for a test point
    ensembleDiscriminants_X1_test=1/M*sumC1;
    
    decisions_X0_test=ensembleDiscriminants_X0_test<=0;%decide C1 if negative otherwise decide C0
    decisions_X1_test=ensembleDiscriminants_X1_test<=0;
    
    
    %compute the misclassification rate
    totalErrors=sum(decisions_X0_test)+sum(1- decisions_X1_test);
    e=totalErrors/n_test;
    
end