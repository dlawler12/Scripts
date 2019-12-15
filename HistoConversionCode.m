[~,animals] = size(Smooth20_Odr10_Diacetyl1);
newmat = zeros(43201,animals);
for i = 1:animals
    count = 0 ;
    for j = 1:43201
        if(Smooth20_Odr10_Diacetyl1(j,i)==0)
            newmat(j,i)=count+1;
            count=count+1;
        else
            count = 0;
        end
    end
end

maxs = zeros(43201,animals);
for i = 1:animals
    for j = 1:43200
        if(newmat(j+1,i)<newmat(j,i))
            maxs(j,i)=newmat(j,i);
        end
    end
end

j=43201;
for i = 1:animals
    maxs(j,i)=newmat(j,i);
end
maxs(maxs==0)=NaN;
bins = [-10,0,20,50,100,200,500,1000];
a = histcounts(maxs,bins);
% h.NumBins = 15;
% h.BinEdges = [0:1000];
