function normLAB=Lab_norm(Lab)

L=Lab(:,1);
A=Lab(:,2);
B=Lab(:,3);

L=(L-min(L(:)))/( max(L(:))-min(L(:)) );
A=(A-min(A(:)))/( max(A(:))-min(A(:)) );
B=(B-min(B(:)))/( max(B(:))-min(B(:)) );

normLAB(:,1)=L;
normLAB(:,2)=A;
normLAB(:,3)=B;
end