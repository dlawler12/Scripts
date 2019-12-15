%Run after a seg file is loaded

[~,z] = size(Tracks);
counter = 0;
for i = 1:z
temp = mean(Tracks(i).Size);
counter = counter+temp;
end
counter = counter/z