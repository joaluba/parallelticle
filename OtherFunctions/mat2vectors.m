function [row, col, val]=mat2vectors(mIn)

[N M]=size(mIn)
row=[];
col=[]
val=[];

for m=1:M
    for n=1:N
        rowtemp(n)=n;
        coltemp(n)=m;
        valtemp(n)=mIn(n,m);
    end
    row=[row rowtemp];
    col=[col coltemp];
    val=[val valtemp];
end

end

