% clear all;
% close all;
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
y_1=[1 2 3 1 2 2 3 1 2 1];
y_2=[225 1700 3200 220 1750 1800 3250 210 1600 3300];
y_3=[200 1500 3150 250 200 200 3500 250 2000 250];
stackedbar = @(x, A) bar(x, A,'stack');
prettyline = @(x, y) plot(x, y, 'k-o', 'LineWidth', 3,'Color','k');
time_slot=2:2:20;
hold on
[hAxes,hBar,hLine]=plotyy(time_slot,y_1,time_slot,y_2,stackedbar,prettyline);
set(hAxes,'XTick',time_slot); % Change x-axis ticks
layer_id=[0 1 2 3 4];
bw=0:500:4000;
set(hAxes(1),'Ytick',layer_id);
set(hAxes(2),'Ytick',bw);
colormap summer;
title('Layer selection, network speed from 200Kb/s to 3500Kb/s');
xlabel('Time (s)');
ylabel(hAxes(1),'Layer ID');
ylabel(hAxes(2), 'Bandwidth (Kb/s)');
legend(hAxes(1),'Layer ID','Real Bandwidth');
grid minor


hold off

subplot(2,1,2);
hold on
threshold_values=[0 198 1470 3101];
time_slot_2=[0:2:18];
stairs(time_slot_2,y_3,'Linewidth',2,'Color',[1 0 0]);
plot(time_slot_2,y_2,'Color','k','Linewidth',2);
% set(hAxes,'Ytick',threshold_values);
line([0 20],[3101 3101],'LineStyle','--','Linewidth',2,'Color','b');
line([0 20],[1470 1470],'LineStyle','--','Linewidth',2,'Color','c');
line([0 20],[198 198],'LineStyle','--','Linewidth',2,'Color','g');

title('Layer selection, network speed from 200KB/s to 400KB/s');
xlabel('Time (s)');
ylabel('Bandwidth (KB/s)');
legend('Estimate Bandwidth','Real Bandwidth','Threshold Layer 3','Threshold Layer 2','Threshold Layer 1');
















