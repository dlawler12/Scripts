%% Load all data
clear all
close all
clc
% cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\IndividualAnimalsFig2\AnalysisData')
% load('Raw_Fig2')
% load('Smooth20_Fig2')
cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\NewAnalysisData\SummedData')
load('Raw')
load('SmoothedData')

%% Calculate raw known decisions and known sleep decisions
% for t = 0:11
    clearvars -except t fig1 fig2 fig3 fig4
    close all
    clc
    % cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\IndividualAnimalsFig2\AnalysisData')
    % load('Raw_Fig2')
    % load('Smooth20_Fig2')
    cd('Z:\Dan Lawler\Projects\Sleep\BehaviorDataGroups\NewAnalysisData\SummedData')
    load('Raw')
    load('SmoothedData')
    outlier = 1/12; %Exclude all data with less than x of behavior data
%     hourstart = t;
%     hourend = t+1;
    hourstart = 0;
    hourend = 12;
    starting = hourstart*3600+1;
    ending = hourend*3600+1;

    N2_Ind(:,1) = sum(Raw_N2Comparison(starting:ending,:)  > 1);
    N2_Ind(:,2) = sum(Smooth20_N2Comparison(starting:ending,:) == 0);
    N2_Ind(N2_Ind(:,1)<((ending-starting)*outlier),:) = [];
    val1 = N2_Ind(:,2)./N2_Ind(:,1);
%     val5 = N2_Ind(end-122:end,2)./N2_Ind(end-122:end,1);

    N2_Dia_Ind(:,1) = sum(Raw_N2_CombinedTestOnly_Diacetyl10e_7(starting:ending,:)  > 1);
    N2_Dia_Ind(:,2) = sum(Smooth20_N2_CombinedTestOnly_Diacetyl10e_7(starting:ending,:) == 0);
    N2_Dia_Ind(N2_Dia_Ind(:,1)<((ending-starting)*outlier),:) = [];
    val6 = N2_Dia_Ind(:,2)./N2_Dia_Ind(:,1);

    DiacetylCombined_Ind(:,1) = sum(Raw_CombinedDiacetyl190129(starting:ending,:)  > 1);
    DiacetylCombined_Ind(:,2) = sum(Smooth20_CombinedDiacetyl190129(starting:ending,:) == 0);
    DiacetylCombined_Ind(DiacetylCombined_Ind(:,1)<((ending-starting)*outlier),:) = [];
    val4 = DiacetylCombined_Ind(:,2)./DiacetylCombined_Ind(:,1);

    Mec4_Dia_Ind(:,1) = sum(Raw_Mec4_Diacetyl10e_7(starting:ending,:)  > 1);
    Mec4_Dia_Ind(:,2) = sum(Smooth20_Mec4_Diacetyl10e_7(starting:ending,:) == 0);
    Mec4_Dia_Ind(Mec4_Dia_Ind(:,1)<((ending-starting)*outlier),:) = [];
    val7 = Mec4_Dia_Ind(:,2)./Mec4_Dia_Ind(:,1);

    Food_Ind(:,1) = sum(Raw_N2_NA22_OD600_0(starting:ending,:)  > 1);
    Food_Ind(:,2) = sum(Smooth20_N2_NA22_OD600_0(starting:ending,:) == 0);
    Food_Ind(Food_Ind(:,1)<((ending-starting)*outlier),:) = [];
    val2 = Food_Ind(:,2)./Food_Ind(:,1);

    Sero_Ind(:,1) = sum(Raw_N2_Serotonin10uM(starting:ending,:)  > 1);
    Sero_Ind(:,2) = sum(Smooth20_N2_Serotonin10uM(starting:ending,:) == 0);
    Sero_Ind(Sero_Ind(:,1)<((ending-starting)*outlier),:) = [];
    val3 = Sero_Ind(:,2)./Sero_Ind(:,1);

    Ate_Ind(:,1) = sum(Raw_N2_SodiumSulfate30mM(starting:ending,:)  > 1);
    Ate_Ind(:,2) = sum(Smooth20_N2_SodiumSulfate30mM(starting:ending,:) == 0);
    Ate_Ind(Ate_Ind(:,1)<((ending-starting)*outlier),:) = [];
    val11 = Ate_Ind(:,2)./Ate_Ind(:,1);

    Odr10_Dia_Ind(:,1) = sum(Raw_Odr10_Diacetyl10e_7(starting:ending,:)  > 1);
    Odr10_Dia_Ind(:,2) = sum(Smooth20_Odr10_Diacetyl10e_7(starting:ending,:) == 0);
    Odr10_Dia_Ind(Odr10_Dia_Ind(:,1)<((ending-starting)*outlier),:) = [];
    val9 = Odr10_Dia_Ind(:,2)./Odr10_Dia_Ind(:,1);

    Ite_Ind(:,1) = sum(Raw_SodiumSulfite30mM4CoreWithoutCorrection(starting:ending,:)  > 1);
    Ite_Ind(:,2) = sum(Smooth20_SodiumSulfite30mM4CoreWithoutCorrection(starting:ending,:) == 0);
    Ite_Ind(Ite_Ind(:,1)<((ending-starting)*outlier),:) = [];
    val10 = Ite_Ind(:,2)./Ite_Ind(:,1);

    Tax4_Dia_Ind(:,1) = sum(Raw_Tax4_Diacetyl10e_7(starting:ending,:)  > 1);
    Tax4_Dia_Ind(:,2) = sum(Smooth20_Tax4_Diacetyl10e_7(starting:ending,:) == 0);
    Tax4_Dia_Ind(Tax4_Dia_Ind(:,1)<((ending-starting)*outlier),:) = [];
    val8 = Tax4_Dia_Ind(:,2)./Tax4_Dia_Ind(:,1);
    
    N2All(:,1) = sum(Raw_N2_All(starting:ending,:) >1);
    N2All(:,2) = sum(Smooth20_N2_All(starting:ending,:) == 0);
    N2All(N2All(:,1)<((ending-starting)*outlier),:) = [];
    val12 = N2All(:,2)./N2All(:,1);
    
    N2OnOff(:,1) = sum(Raw_N2_OnOffFlow(starting:ending,:) >1);
    N2OnOff(:,2) = sum(Smooth20_N2_OnOffFlow(starting:ending,:) == 0);
    N2OnOff(N2OnOff(:,1)<((ending-starting)*outlier),:) = [];
    val13 = N2OnOff(:,2)./N2OnOff(:,1);



    %% Pre-calculate sleep fractions and variables for loop
    binsize = 2; %value in decimal points
    spacing = 0.03;
    center = 1;


    for i = 1:13
        if i ~=5
            eval(['val',int2str(i),' = round(val',int2str(i),',binsize);']);
            eval(['val',int2str(i),' = sort(val',int2str(i),');']);
            eval(['counter',int2str(i),' = 0;']);
            eval(['maximum',int2str(i),' = length(val',int2str(i),');']);
            eval(['scatterrange',int2str(i),' = zeros(maximum',int2str(i),',2);']);
            eval(['scatterrange',int2str(i),'(:,2) = val',int2str(i),';']);
        end
    end

    %% Create even scatter plot spacing

    number=zeros(1,13);

    for i = 0:100
        for j = 1:13
            if j ~=5
                eval(['number(j) = sum(val',int2str(j),' == i/100);']);

                if(number(j)==1)
                    array = 1;
                    eval(['scatterrange',int2str(j),'(counter',int2str(j), ...
                        '+1:counter',int2str(j),'+number(j),1) = array;']);
                elseif(number(j)>1)
                    array = [(center+spacing/2)-number(j)*(spacing/2):spacing:(center+spacing/2)+(number(j)/2-1)*spacing];
                    eval(['scatterrange',int2str(j),'(counter',int2str(j), ...
                        '+1:counter',int2str(j),'+number(j),1) = array;']);
                end

                eval(['counter',int2str(j),' = counter',int2str(j),' + number(j);']);
            end
        end
    end


    %% Arrange scatter plot data from all plots onto one

    scatterrange2(:,1)=scatterrange2(:,1)+1;
    scatterrange3(:,1)=scatterrange3(:,1)+2;
    scatterrange4(:,1)=scatterrange4(:,1)+3;
%     scatterrange5(:,1)=scatterrange5(:,1)+4;

    ovscatter1=[scatterrange1;scatterrange2;scatterrange3;scatterrange4];

    scatterrange7(:,1)=scatterrange7(:,1)+3;
    scatterrange8(:,1)=scatterrange8(:,1)+2;
    scatterrange9(:,1)=scatterrange9(:,1)+1;

    ovscatter2=[scatterrange6;scatterrange9;scatterrange8;scatterrange7];

%     scatterrange5(:,1)=scatterrange5(:,1)-3;
    scatterrange10(:,1)=scatterrange10(:,1)+1;
    scatterrange11(:,1)=scatterrange11(:,1)+2;

    ovscatter3=[scatterrange1;scatterrange10;scatterrange11];

    scatterrange10(:,1)=scatterrange10(:,1)-1;
    scatterrange11(:,1)=scatterrange11(:,1)-1;

    ovscatter4=[scatterrange10;scatterrange11];
    
    scatterrange4(:,1)=scatterrange4(:,1)-2;
    
    ovscatter5=[scatterrange1;scatterrange4];
    
    scatterrange13(:,1)=scatterrange13(:,1)+1;
    
    ovscatter6=[scatterrange12;scatterrange13];

    %% Plot scatter plot and boxplot so they're on top of each other
    figure
    hold on
    scatter(ovscatter1(:,1),ovscatter1(:,2),5,'filled','k')

    group1 = [ones(size(val1));2*ones(size(val2));3*ones(size(val3));4*ones(size(val4))];
    boxplot([val1;val2;val3;val4],group1)

    figure
    hold on
    scatter(ovscatter2(:,1),ovscatter2(:,2),5,'filled','k')

    group2 = [ones(size(val6));2*ones(size(val7));3*ones(size(val8));4*ones(size(val9))];
    boxplot([val6;val7;val8;val9],group2)

    figure
    hold on
    scatter(ovscatter3(:,1),ovscatter3(:,2),5,'filled','k')

    group3 = [ones(size(val1));2*ones(size(val10));3*ones(size(val11))];
    boxplot([val1;val10;val11],group3)

    figure
    hold on
    scatter(ovscatter4(:,1),ovscatter4(:,2),5,'filled','k')

    group4 = [ones(size(val10));2*ones(size(val11))];
    boxplot([val10;val11],group4)
    
    figure
    hold on
    scatter(ovscatter5(:,1),ovscatter5(:,2),5,'filled','k')

    group5 = [ones(size(val1));2*ones(size(val4))];
    boxplot([val1;val4],group5)

    figure
    hold on
    scatter(ovscatter6(:,1),ovscatter6(:,2),5,'filled','k')

    group6 = [ones(size(val12));2*ones(size(val13))];
    boxplot([val12;val13],group6)

    %% Put original values back in for all sets
    totalmax = max([maximum1 maximum2 maximum3 maximum4]);
    totalmax1 = max([maximum1 maximum9]);
    totalmax2 = max([maximum6 maximum7 maximum8 maximum9]);
    totalmax3 = max([maximum1 maximum10 maximum11]);
    totalmax4 = max([maximum10 maximum11]);
    totalmax5 = max([maximum1 maximum4]);
    totalmax6 = max([maximum12 maximum13]);

    % After plot put original values back
    val1 = N2_Ind(:,2)./N2_Ind(:,1);
    val1 = sort(val1);

    val2 = Food_Ind(:,2)./Food_Ind(:,1);
    val2 = sort(val2);

    val3 = Sero_Ind(:,2)./Sero_Ind(:,1);
    val3 = sort(val3);

    val4 = DiacetylCombined_Ind(:,2)./DiacetylCombined_Ind(:,1);
    val4 = sort(val4);

%     val5 = N2_Ind(end-122:end,2)./N2_Ind(end-122:end,1);
%     val5 = sort(val5);

    val6 = N2_Dia_Ind(:,2)./N2_Dia_Ind(:,1);
    val6 = sort(val6);

    val7 = Mec4_Dia_Ind(:,2)./Mec4_Dia_Ind(:,1);
    val7 = sort(val7);

    val8 = Tax4_Dia_Ind(:,2)./Tax4_Dia_Ind(:,1);
    val8 = sort(val8);

    val9 = Odr10_Dia_Ind(:,2)./Odr10_Dia_Ind(:,1);
    val9 = sort(val9);

    val10 = Ite_Ind(:,2)./Ite_Ind(:,1);
    val10 = sort(val10);

    val11 = Ate_Ind(:,2)./Ate_Ind(:,1);
    val11 = sort(val11);
    
    val12 = N2All(:,2)./N2All(:,1);
    val12 = sort(val12);
    
    val13 = N2OnOff(:,2)./N2OnOff(:,1);
    val13 = sort(val13);

    %% Create one sleep fraction dataset with NaN for non-values for statistical comparison
    vals = NaN(totalmax,4);
    vals(1:length(val1),1)=val1;
    vals(1:length(val2),2)=val2;
    vals(1:length(val3),3)=val3;
    vals(1:length(val4),4)=val4;
    % vals(1:length(val5),5)=val5;

    [p,~,stats] = anova1(vals);
    [results,means] = multcompare(stats,'CType','bonferroni')
    
    %% Testing N2 SB vs Odr-10 Diacetyl
    
    vals1 = NaN(totalmax1,2);
    vals1(1:length(val1),1)=val1;
    vals1(1:length(val9),2)=val9;
    
    [p1,~,stats1] = anova1(vals1);
    [results1,means1] = multcompare(stats1,'CType','bonferroni')

    %% Group2
    vals2 = NaN(totalmax2,4);
    vals2(1:length(val6),1)=val6;
    vals2(1:length(val9),2)=val9;
    vals2(1:length(val8),3)=val8;
    vals2(1:length(val7),4)=val7;

    [p2,~,stats2] = anova1(vals2);
    [results2,means2] = multcompare(stats2,'CType','bonferroni')

    % %% Group3 (previous)
    % vals3 = NaN(totalmax3,3);
    % vals3(1:length(val1),1)=val1;
    % % vals3(1:length(val5),2)=val5;
    % vals3(1:length(val10),2)=val10;
    % vals3(1:length(val11),3)=val11;
    % 
    % [p3,~,stats3] = anova1(vals3);
    % [results3,means3] = multcompare(stats3,'CType','bonferroni')
   

    %% Group 4 (new 3)
    vals4 = NaN(totalmax4,2);
    vals4(1:length(val10),1)=val10;
    vals4(1:length(val11),2)=val11;
    
    [p4,~,stats4] = anova1(vals4);
    [results4,means4] = multcompare(stats4,'CType','bonferroni')
    %% Group 5
    vals5 = NaN(totalmax5,2);
    vals5(1:length(val1),1)=val1;
    vals5(1:length(val4),2)=val4;

    [p5,~,stats5] = anova1(vals5);
    [results5,means5] = multcompare(stats5,'CType','bonferroni')
    %% Group 6
    vals6 = NaN(totalmax6,2);
    vals6(1:length(val12),1)=val12;
    vals6(1:length(val13),2)=val13;

    [p6,~,stats6] = anova1(vals6);
    [results6,means6] = multcompare(stats6,'CType','bonferroni')   

    

    fig1(:,1:2) = results(:,1:2);
    fig1(:,end+1)=results(:,6);

    fig2(:,1:2) = results2(:,1:2);
    fig2(:,end+1)=results2(:,6);

    fig3(:,1:2) = results4(:,1:2);
    fig3(:,end+1)=results4(:,6);
    
    fig4(:,1:2) = results1(:,1:2);
    fig4(:,end+1)=results1(:,6);
    
    fig5(:,1:2) = results5(:,1:2);
    fig5(:,end+1)=results5(:,6);
    
    fig6(:,1:2) = results6(:,1:2);
    fig6(:,end+1)=results6(:,6);
    
% end

close all