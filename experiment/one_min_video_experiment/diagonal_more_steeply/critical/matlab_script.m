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
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
];

%times of upload
x_1=[
0.354004
0.472213
0.747585
2.340902
5.063946
8.011095
9.571439
11.242387
13.80091
16.860490
17.069831
19.526133
21.267222
22.713356
25.383213
26.558186
28.247865
30.492952
32.802712
34.438793
36.018822
38.668568
40.344504
42.681403
44.397692
46.713816
48.300016
50.440820
52.859433
54.453998
57.188273
59.560117
]; 
%simulated bandwith values
y_3=[
3451
203
1817
210
3363
219
3485
240
216
3394
226
1717
222
3161
219
1712
237
1675
235
1965
207
1983
219
1871
226
3480
247
1702
207
3356
231
];
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
3042.79005704
3147.66959533
3266.16815666
191.363225187
1693.6721533 
777.424320215
3178.60870683
207.134606354
3032.75131698
216.702136818
362.534520685
3221.35530327
208.884230202
1631.53617248
202.817573663
3000.99955638
381.367205337
1416.7251635 
217.904473521
1521.99210047
377.461693003
1871.74996355
195.936877057
1889.60465792
203.29984634 
1768.20826987
19:56:05.300
374.362514892
2989.9267746 
199.444754215
1540.39655987
345.171707104
3184.32617297
];

hold on
threshold_values=[0 198 1470 3101];
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






























