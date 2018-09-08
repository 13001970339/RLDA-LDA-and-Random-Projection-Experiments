%This defines the G function in equation (10) 

function G=functionG(mu,xBar0,xBar1,V)
    G=(mu-(xBar0+xBar1)/2)'*V*(xBar0-xBar1);
end