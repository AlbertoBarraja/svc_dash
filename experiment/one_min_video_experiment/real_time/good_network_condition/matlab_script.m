clear all;
close all;
% %%%% frame/segment 100, file size for seg0: lay0-97KB, lay1-691KB, lay2-708KB
% %%% fps is 25, 4 seconds per segment
% l1=[1 1 1 1 1];
% l2=[1 1 1 1 1];
% threshold1=[208.604 208.604 208.604 208.604 208.604 208.604 208.604 208.604 208.604 208.604];
% threshold2=[596.307 596.307 596.307 596.307 596.307 596.307 596.307 596.307 596.307 596.307];
% time_slot = 0:2:20;
% 
% %% calculate the selected layer for speed 200KB/s
% bd_200 = [200 204.499 349.135 106.823 267.960];%
% layer_200=[2 2 3 2 3];%0:1 16:2 32:3
% z_200=[l1' (layer_200-l1)' l1']
% %% plot figure1
% figure(1);
% 
% stackedbar = @(x, A) bar(x, A, 0.3,'stack');
% 
% prettyline = @(x, y) plot(x, y, 'k-o', 'LineWidth', 1);
% 
% [hAxes,hBar,hLine] = plotyy(time_slot,z_200,time_slot,bd_200,stackedbar,prettyline);
% set(hAxes,'XTick',time_slot); % Change x-axis ticks
% set(hAxes,'XTickLabel',time_slot); % Change x-axis ticks labels to desired values.
% set(hAxes,'NextPlot','add');
% plot(hAxes(2),time_slot,threshold1,'b-.o');
% axis(hAxes(2),[-2 18 0 500]);
% axis(hAxes(1),[-2 18 0 5]);
% 
% colormap summer;
% title('Layer selection, network speed from 200KB/s to 400KB/s');
% xlabel('Time (s)');
% ylabel(hAxes(1),'Layer ID');
% ylabel(hAxes(2), 'Bandwidth (KB/s)');
% legend(hAxes(1),'layer1','layer2','layer3');
% legend(hAxes(2),'Estimate Bandwidth','Switch threshold','Real Bandwidth');

%%

figure;
subplot(2,1,1);
hold on
%choose level to upload
y_1=[
0
1
2
3
1
1
2
3
1
2
1
1
2
1
2
3
1
2
3
1
2
1
2
1
2
3
1
1
2
3
1
2
1
1
2
3
1
2
3
1
2
3
1
2
1
2
1
2
3
1
1
2
3
1
1
1
2
3
1
2
3
1
2
3
1
1
2
];
%times of upload
x_1= [
00.10	
00.408942
00.524075
00.804454
02.756370
04.475412
05.351310
06.082850
06.549260
08.145523
08.579998
10.480597
10.915327
12.390829
12.476910
12.795483
14.397688
14.522940
14.925979
16.555653
17.882236
18.543199
19.055681
20.481292
20.696504
21.216913
22.730407
24.505048
25.457060
26.251788
26.570778
28.209824
28.609053
30.492869
30.904663
32.254314
32.411265
32.506851
32.848154
34.452476
34.706786
35.545507
36.569550
37.869877
38.681725
39.568130
40.447755
40.567337
40.854987
42.696737
44.456138
44.928353
45.322128
46.725718
48.630697
50.453566
50.655348
51.320040
52.431894
52.524390
52.864581
54.470126
54.717931
55.543264
56.735468
58.578061
59.095807
]; 
%simulated bandwith values
y_3=[
3451
1503
1817
3210
3363
1619
3485
3490
3416
3394
1826
1717
1672
3161
3219
1712
3237
1675
3485
1965
3307
1983
3369
1871
3176
3480
3247
1702
1957
3356
1881
];
stackedbar = @(x, A) bar(x, A,'stack');
prettyline = @(x, y) stairs(x, y, 'k-o', 'LineWidth', 3,'Color','k');

time_slot_2=0:2:60;

[hAxes,hBar,hLine]=plotyy(time_slot_2,y_3,x_1,y_1, prettyline, stackedbar);
set(hAxes,'XTick',time_slot_2); % Change x-axis ticks
layer_id=0:1:3;
bw=0:500:4000;
set(hAxes(1),'YTick',bw);         % CHANGED
set(hAxes(2),'ylim',[0 4],'YTick',layer_id);   %CHANGED
colormap summer;

line([0 60],[3101 3101],'LineStyle','--','Linewidth',2,'Color','b');
line([0 60],[1470 1470],'LineStyle','--','Linewidth',2,'Color','c');
line([0 60],[198 198],'LineStyle','--','Linewidth',2,'Color','g');

title('Layer selection, network speed from 200Kb/s to 3500Kb/s');
xlabel('Time (s)');
ylabel(hAxes(2),'Layer ID');    %cHANGED
ylabel(hAxes(1), 'Bandwidth (Kb/s)');   %CHANGED
legend(hAxes(2),'Layer ID','Simulated Bandwidth','Threshold Layer 3','Threshold Layer 2','Threshold Layer 1');
%grid minor
hold off


%%
subplot(2,1,2);
%upload times
x_4= x_1; 
%estimated values of BW
y_4=[
0
3100.38125589
3232.28412336
3208.78168439
1435.05306862
1684.62008634
1729.06782215
1727.95619704
3047.15720171
3063.53903877
3193.24186876
1499.19119396
1534.6155897 
3009.1328582 
3232.1712371 
3295.80092298
3062.46027915
3059.23430719
3327.25905364
3243.19375565
3258.1261312 
3144.80925422
3229.09508371
1671.05419987
1725.93599674
1727.57313209
1614.41670407
1553.45491853
1590.68487182
1590.4933257 
3008.6071969 
2983.48698236
3055.90939963
1584.52107579
1620.18603104
1632.03958431
2801.57670848
2908.54925257
3075.77085718
1515.47845434
1505.12394988
1598.0501266 
3311.66399302
3323.94785117
1874.4756883 
1866.13508705
3012.82447925
3109.13429973
3126.95787923
1881.76826996
3091.6341594
3207.96934668
3211.17000175
1782.47387338
3026.26492592
3172.40329608
3307.92285717
3314.7171597 
2753.1442235 
3006.15152604
3085.67106919
1543.71310492
1544.35496747
1623.86050963
1859.03327658
3188.52729634
3195.66089799
];

hold on
%threshold_values=[0 198 1470 3101];
time_slot_3=[0:2:60]

stairs(time_slot_3,y_3,'Linewidth',2,'Color',[1 0 0]);
line(x_4,y_4,'Color','k','Linewidth',2);

line([0 60],[3101 3101],'LineStyle','--','Linewidth',2,'Color','b');
line([0 60],[1470 1470],'LineStyle','--','Linewidth',2,'Color','c');
line([0 60],[198 198],'LineStyle','--','Linewidth',2,'Color','g');

title('Bandwidth estimation, network speed from 200Kb/s to 3500Kb/s');
xlabel('Time (s)');
ylabel('Bandwidth (Kb/s)');
legend('Simulated Bandwidth','Estimated Bandwidth','Threshold Layer 3','Threshold Layer 2','Threshold Layer 1');

%%















