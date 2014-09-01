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
y_1=[1 2 3 1 2 3 1 2 3 1 2 3 1 2 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 3];
%times of upload
x_1= [0.738389 0.773428 0.993158 1.740715 2.770017 6.000350 6.357782 6.522506 6.801895 8.044888 9.127642 11.164554 11.980218 14.218856 14.585642 14.691321 16.084316 16.816483 16.88429 17.248506 18.259713 18.302068 18.482647 20.267004 21.153195 21.583503 22.271042 22.524382 23.469982 24.678630]; 
%simulated bandwith values
y_3=[3189 3464 1740 3258 3201 1945 1522 3301 1657 3372 3325 3171 1857 0];
stackedbar = @(x, A) bar(x, A,'stack');
prettyline = @(x, y) stairs(x, y, 'k-o', 'LineWidth', 3,'Color','k');

time_slot_2=0:2:26;

[hAxes,hBar,hLine]=plotyy(time_slot_2,y_3,x_1,y_1, prettyline, stackedbar);
set(hAxes,'XTick',time_slot_2); % Change x-axis ticks
layer_id=[0 1 2 3 4 5];
bw=0:500:4000;
set(hAxes(2),'Ytick',layer_id);   %CHANGED
set(hAxes(1),'Ytick',bw);         % CHANGED
colormap summer;

line([0 26],[3101 3101],'LineStyle','--','Linewidth',2,'Color','b');
line([0 26],[1470 1470],'LineStyle','--','Linewidth',2,'Color','c');
line([0 26],[198 198],'LineStyle','--','Linewidth',2,'Color','g');

title('Layer selection, network speed from 200Kb/s to 3500Kb/s');
xlabel('Time (s)');
ylabel(hAxes(2),'Layer ID');    %cHANGED
ylabel(hAxes(1), 'Bandwidth (Kb/s)');   %CHANGED
legend(hAxes(2),'Layer ID','Simulated Bandwidth','Threshold Layer 3','Threshold Layer 2','Threshold Layer 1');
grid minor
hold off


%%
subplot(2,1,2);
%upload times
x_4= [0 0.738389 0.773428 0.993158 1.740715 2.770017 6.000350 6.357782 6.522506 6.801895 8.044888 9.127642 11.164554 11.980218 14.218856 14.585642 14.691321 16.084316 16.816483 16.88429 17.248506 18.259713 18.302068 18.482647 20.267004 21.153195 21.583503 22.271042 22.524382 23.469982 24.678630]; 
%estimated values of BW
y_4=[0 4632.71 10724.2616 4097.7056 14469.2539 5014.1115 2138.0898 582.5181 9219.9493 4530.1745 14463.3484 4518.008 2914.9546 882.5236 2511.3041 506.1794 6339.3299 3998.8371 160.5203 4117.9369 6055.1216 3083.3362 9126.2053 5822.2439 15628.2918 4879.1805 3117.6582 13536.657 6540.8239 4490.5654 10296.7655];
hold on
threshold_values=[0 198 1470 3101];
time_slot_3=[0:2:26]

stairs(time_slot_3,y_3,'Linewidth',2,'Color',[1 0 0]);
stairs(x_4,y_4,'Color','k','Linewidth',2);

line([0 26],[3101 3101],'LineStyle','--','Linewidth',2,'Color','b');
line([0 26],[1470 1470],'LineStyle','--','Linewidth',2,'Color','c');
line([0 26],[198 198],'LineStyle','--','Linewidth',2,'Color','g');

title('Bandwidth estimation, network speed from 200Kb/s to 3500Kb/s');
xlabel('Time (s)');
ylabel('Bandwidth (Kb/s)');
legend('Simulated Bandwidth','Estimated Bandwidth','Threshold Layer 3','Threshold Layer 2','Threshold Layer 1');

%%















