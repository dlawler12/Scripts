close all
onoff=Smooth20_N2_OnOffFlow;
onoffminutebin = zeros(720,1);
for i = 1:720
onoffminutebin(i)=1-(mean(mean(onoff(60*(i-1)+1:60*i,:))));
end

figure

subplot(14,1,1:2)
plot((1:720)/60,onoffminutebin)
box off
% xlabel('Hour')
% ylabel('Sleep Fraction')
ylim([0 1])
yticks(0:0.5:1)
xticks(0:2:12)

colormap gray
subplot(14,1,5:14)
h = heatmap(transpose(onoff));

figure
subplot(14,1,1:2)
noflow = Smooth20_N2_NoFlow;
nominute = zeros(720,1);
for i = 1:720
    nominute(i) = 1-(mean(mean(noflow(60*(i-1)+1:60*i,:))));
end

plot((1:720)/60,nominute)
box off
% xlabel('Hour')
% ylabel('Sleep Fraction')
ylim([0 1])
yticks(0:0.5:1)
xticks(0:2:12)

subplot(14,1,5:14)
colormap gray
h = heatmap(transpose(noflow));