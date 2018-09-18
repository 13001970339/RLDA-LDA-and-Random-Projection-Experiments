%This defines the D function in equation (10) 

function D=functionD(xBar0,xBar1,V,U)
    D=(xBar0-xBar1)'*V*U*V*(xBar0-xBar1);
end