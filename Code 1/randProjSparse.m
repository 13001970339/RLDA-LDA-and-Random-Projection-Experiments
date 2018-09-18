%This function projects a given matrix onto a subspace of dimension r that is randomly
%generated according to the sparse matrix distrubution defined in the paper "Random projection in dimensionality reduction: Applications to image and text data"

function X_RP=randProjSparse(X,r)
    %Generate the random matrix
    [rows,~]=size(X);
    R=zeros(r,rows);
    
    for i=1:r
        for j=1:rows
            temp=rand;
            if(temp<1/6)%if temp lies in the range 0-1/6, i.e. w.p. 1/6, R(i,j)=sqrt(3)
                R(i,j)=sqrt(3);
            elseif(temp>5/6)%if temp lies in the range 5/6-1, i.e. w.p. 1/6, R(i,j)=-sqrt(3)
                R(i,j)=-sqrt(3);
            else%if temp lies in the range 1/6-5/6, i.e. w.p. 2/3, R(i,j)=0
                R(i,j)=0;
            end      
        end
    end
    
    X_RP=R*X;
end