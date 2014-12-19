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
1
2
3
1
1
1
2
1
2
1
1
2
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
1
1
2
1
2
1
2
1
2
1
2
1
2
1
1
1
1
2
1
2
1
2
1
2
1
2
1
2
1
2
1
2
];
%times of upload
x_1= [
0.24304
0.35962
0.64339
2.59262
4.31015
6.38526
8.05265
8.41558
8.88965
10.31658
12.22613
13.69671
14.23188
15.92732
16.38931
16.59432
18.06111
18.37430
18.46224
18.85489
20.31406
20.53587
22.56105
24.33869
26.40476
27.83998
28.46583
29.06329
30.33453
30.60070
32.24515
34.09379
34.28575
35.30068
36.40202
37.94280
38.51490
40.28096
42.52841
44.28841
46.20128
46.55713
46.92991
48.46236
48.55621
50.28488
50.40292
52.26285
53.66027
54.30301
56.32707
56.56960
56.77072
58.41052
59.94352
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
1698];
stackedbar = @(x, A) bar(x, A,'stack');
prettyline = @(x, y) stairs(x, y, 'k-o', 'LineWidth', 3,'Color','k');

time_slot_2=0:2:60;

[hAxes,hBar,hLine]=plotyy(time_slot_2,y_3,x_1,y_1, prettyline, stackedbar);
set(hAxes,'XTick',time_slot_2); % Change x-axis ticks
layer_id=[0 1 2 3 4 5];
bw=0:500:4000;
set(hAxes(2),'Ytick',layer_id);   %CHANGED
set(hAxes(1),'Ytick',bw);         % CHANGED
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
3151.1044388 
3187.68783553
3169.44429877
1430.30464425
1687.18810973
3043.2559525 
3093.90750302
3193.18441945
3195.53622678
1491.7001266 
3022.06931298
3325.5204286 
3078.43836818
3315.89285574
3245.24017866
3256.41520789
3251.35687807
3191.38189999
3162.56221659
3220.53527351
1681.20688205 
1725.83056217
1625.66917079
1545.91297967
3001.58976167
3011.51500051
2782.91373301
2768.97105187
1478.2991944 
1395.51578681
2823.19152804
2790.5863374 
1506.72786715
1492.07294555
3314.3232285 
3174.02994583
1870.16746132
3001.97843779
1889.3054197 
3092.65371195
2938.85262154
1781.88254306
1790.02580131
3021.46169637
2963.46654371
3177.66613548
3246.33328812
2821.36266274
3094.3531397 
1528.56702518
1615.19356002
1847.42347912
1847.39167781
3182.54878877
3007.5732377 
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















