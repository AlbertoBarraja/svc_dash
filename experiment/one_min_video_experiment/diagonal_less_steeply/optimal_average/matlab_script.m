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
x_1= [
0.311101
0.492467
0.926903
2.494204
4.317360
6.506019
8.566860
10.313574
12.272570
14.282008
16.528934
18.513893
20.327877
22.516862
24.340769
26.526903
28.588533
30.334757
32.292317
34.300811
36.547242
38.520536
40.343606
42.534229
44.356687
46.544738
48.604400
50.351184
52.311009
54.318561
56.565835
58.537657]; 
%simulated bandwith values
y_3=[
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
2168
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
1880.16777324
2049.29175626
2069.90380346
2065.98338082
2012.87154964
2063.72072391
2067.6563315 
2003.06749844
1936.72502646
1954.57517829
2069.17299636
1973.09385462
1992.51790818
2065.70593223
1998.18794333
2066.83072604
2065.56004192
2004.64748157
1925.67669505
1953.09162977
2066.81755824
2050.09649462
2010.3749736 
2059.80820003
2010.95939128
2064.32665234
2067.38857359
2005.41255106
1858.25903304
1948.71185571
2065.16753233
2064.63711892
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















