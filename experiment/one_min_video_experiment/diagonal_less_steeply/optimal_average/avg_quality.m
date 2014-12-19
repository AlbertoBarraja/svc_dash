clear all;
close all;

%%
%plot(X,Y);
%estimated values of BW
y=[
1.0666    
1.0666  
1.0666  
1.0666  
1.0666  
1.0666
2.0333
2.0333
2.0333
2.0666
3
];

hold on
%threshold_values=[0 198 1470 3101];
time_slot=[
0
10
20
30
40
50
60
70
80
90
100
];

line(time_slot,y,'Linewidth',2,'Color',[1 0 0]);
%line(x_4,y_4,'Color','k','Linewidth',2);
ylim([1 4])
line([0 170],[1 1],'LineStyle','--','Linewidth',2,'Color','b');
line([0 170],[2 2],'LineStyle','--','Linewidth',2,'Color','c');
line([0 170],[3 3],'LineStyle','--','Linewidth',2,'Color','g');
title('Average quality estimation, network speed from 200Kb/s to 3500Kb/s');
xlabel('Time (s)');
ylabel('Layer Number');
set(gca,'ytick', [1 2 3 4]);
legend('Average quality','Base layer','Enhanced layer 1','Enhanced Layer 2');

%%