clear all;
close all;

%%
%plot(X,Y);

%time
time_slot_less=[ 0 10 20 30 40 50 60 70];
time_slot_more=[ 0 10 20 30 40 50 60 ];
time_slot_horizontal=[ 0 10 20 30 40 50 60 70 80 90];
time_slot_realtime=[ 0 10 20 30 40 50 60 70 80];
time_slot_vertical=[0 10 20]


% average quality diagonal less steeplty 
y_diag_less=[3 5 1 1 2 2 2 0];

% average quality diagonal more steeplty 
y_diag_more=[ 1 3 1 2 2 1 1 ];

% average quality pure horizontal
y_horizontal=[ 0 0 0 1 1 1 1 2 1 0];

% average quality real time
y_realtime=[20 20 19 17 17 15 8 2 0];

% average quality real time
y_vertical=[ 14 7 0];

hold on

line(time_slot_less,y_diag_less, 'LineStyle','-','Linewidth',2,'Color',[0 0 0]);
line(time_slot_more,y_diag_more, 'LineStyle','--','Linewidth',2,'Color',[0 0 0]);
line(time_slot_horizontal,y_horizontal,'LineStyle',':','Linewidth',6,'Color',[0 0 0]);
line(time_slot_realtime,y_realtime, 'LineStyle','-.','Linewidth',4,'Color',[0 1 0]);
line(time_slot_vertical,y_vertical, 'LineStyle','--','Linewidth',2,'Color',[1 0 0]);


%line(x_4,y_4,'Color','k','Linewidth',2);
ylim([0 22])
title('Quality switches estimation, network speed from 200Kb/s to 3500Kb/s');
xlabel('Time (s)');
ylabel('Layer Number');
%set(gca,'ytick', [1 2 3 4]);
legend('diagonal less steeply policy','diagonal more steeply policy','pure horizontal policy','realtime policy', 'pure vertical policy');

grid minor;

%%