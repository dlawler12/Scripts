close all
Sulfite=Smooth20_N2_SodiumSulfite30mM;
Sulfate=Smooth20_N2_SodiumSulfate30mM;
N2=Smooth20_N2_All;
atebin = zeros(720,1);
itebin = zeros(720,1);
n2bin = zeros(720,1);
for i = 1:720
	atebin(i)=1-(mean(mean(Sulfate(60*(i-1)+1:60*i,:))));
    itebin(i)=1-(mean(mean(Sulfite(60*(i-1)+1:60*i,:))));
    n2bin(i)=1-(mean(mean(N2(60*(i-1)+1:60*i,:))));
end

figure

subplot(14,1,1:2)
plot((1:720)/60,itebin)
box off
% xlabel('Hour')
% ylabel('Sleep Fraction')
ylim([0 1])
yticks(0:0.5:1)
xticks(0:2:12)

colormap gray
subplot(14,1,5:14)
h = heatmap(transpose(Sulfite));

figure

subplot(14,1,1:2)
plot((1:720)/60,atebin)
box off
% xlabel('Hour')
% ylabel('Sleep Fraction')
ylim([0 1])
yticks(0:0.5:1)
xticks(0:2:12)

subplot(14,1,5:14)
colormap gray
h = heatmap(transpose(Sulfate));

figure
subplot(14,1,1:2)
hold on
plot((1:720)/60,atebin-n2bin)
plot((1:720)/60,itebin-n2bin)
box off
ylim([-.25 .255])
yticks(-.25:0.1:.25)
xticks(0:2:12)
