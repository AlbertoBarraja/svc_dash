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
x_1= [
0.20    
0.591089
2.947842
4.665263
6.734869
8.763886
10.668080
12.581682
14.588852
16.740337
18.725965
20.676284
22.910938
24.691057
26.777560
28.796651
30.680435
32.599580
34.640984
36.758986
38.872107
40.638009
42.885815
44.646330
46.916527
48.822199
50.644137
52.621673
54.662007
56.926536
58.770982
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
set(hAxes(2),'ylim',[0 15],'YTick',layer_id);   %CHANGED
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
3105.58257121
1402.64212678
1585.66369468
3007.3528394 
3194.81746095
1458.27673925
2483.40277416
2552.74787535
3238.71113552
3187.74847441
1539.93383528
1637.29878615
1549.51921457
2732.57161448
3058.37810925
1587.40933279
2838.02885576
1517.9966112 
3306.65122283
1871.34290644
3021.47570776
1889.77694534
3105.01838119
1782.45229434
3017.45504584
3184.22365803
2851.76402263
1544.40284623
1866.39179005
3181.05335569
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















