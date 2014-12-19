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
2
2
1
2
1
2
2
1
1
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
1
1
1
2
1
2
2
2
1
2
1
2
2
1
2
1
2
1
1
2    
];
%times of upload
x_1= [
0.135255
0.250046
0.523778
2.484468
4.202920
6.277756
7.960210
8.308576
8.783131
10.208552
12.119156
13.589959
14.125145
15.816267
16.282269
16.487400
16.574942
16.694985
18.267444
19.603203
20.207768
21.158824
21.374026
22.452790
24.232357
26.299476
28.338366
30.222522
32.141645
33.813922
34.181871
35.140988
36.298595
37.769759
38.411432
40.177453
42.424442
44.184987
45.934554
46.453582
46.82652
46.984738
47.211247
48.359230
49.787628
50.180704
50.680666
50.794438
52.158735
53.824861
54.19797
55.142046
56.461643
58.305650
59.832877]; 
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
3176.14717377
3242.23004808
3286.63263742
1434.18462267
1689.8360023 
3050.94201953
3066.35675663
3193.65083236
3192.8527481 
1506.08381346
3039.86089173
3324.97358287
3076.72064939
3324.37444909
3250.54144029
3255.38026392
3179.73835679
3192.69016291
3217.52994771
3235.84628299
1689.44683872
1739.29868555
1726.6655705 
1637.95780099
1557.02419212
3007.74674679
3060.35719227
1584.17893446
2820.29030146
3084.96076449
1516.70420423
1578.89563359
3316.035294
3324.66841977
1872.64521714
3025.98027085
1888.39223468
3091.31637189
3213.33331225
1783.7301654 
1789.00771181
1756.33761046
1689.89447551
3022.31213458
3025.94084271
3191.17491321
3309.43098987
3270.08686845
2824.70411911
3096.32792648
1541.042321
1604.0405916 
1867.06933628
3191.11207514
3202.29339003
];

hold on
%threshold_values=[0 198 1470 3101];
time_slot_3=[0:2:60]

stairs(time_slot_3,y_3,'Linewidth',2,'Color',[1 0 0]);
stairs(x_4,y_4,'Color','k','Linewidth',2);

line([0 60],[3101 3101],'LineStyle','--','Linewidth',2,'Color','b');
line([0 60],[1470 1470],'LineStyle','--','Linewidth',2,'Color','c');
line([0 60],[198 198],'LineStyle','--','Linewidth',2,'Color','g');

title('Bandwidth estimation, network speed from 200Kb/s to 3500Kb/s');
xlabel('Time (s)');
ylabel('Bandwidth (Kb/s)');
legend('Simulated Bandwidth','Estimated Bandwidth','Threshold Layer 3','Threshold Layer 2','Threshold Layer 1');

%%















