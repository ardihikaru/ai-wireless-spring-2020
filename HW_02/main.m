close all;
clear all;
clc

% System area 120m x 120m
width = 120;
high = 120;

%Channel
W = 10*10^6; % 10MHz;
N0 = 10^(-174/10-10)/1000; % -174 dBm/Hz
    
%Channel environmental parameters for Urban
fc=2; %GHz

%Power
Pt = 1; % Small cell 30dBm = 1W
P0 = 6.8; %Small  cell : 6.8W
Delta = 4; %Small  cell : 4W
P_active = P0+Delta*Pt; %Active mode
Standby_sleep = 4.3; %Sleep mode

%Drone Data
H = 10; %High(m)

%User Data
% Homework: 12 UAVs and 60 UEs
group = 12; %The number of user mobile pattern
num_per_group = 5; % UE per Group

ue_loc_total_x = csvread('ue_loc_total_x_DSC_12.csv');
ue_loc_total_y = csvread('ue_loc_total_y_DSC_12.csv');
ue_num = group * num_per_group;


%Simulation_time = 360; 
Simulation_time = 10; 
time_interval = 10; %Collect data every 10s
runtime = Simulation_time/time_interval;
for time_slot = 1 : runtime 
    %User Location 
    ue_loc_x = ue_loc_total_x(time_slot,:);
    ue_loc_y = ue_loc_total_y(time_slot,:);
    ue_loc = [ue_loc_x ; ue_loc_y];
    ue_loc = ue_loc.';
    
    %DSC Location 
    Drone_loc_intuitive = [];
    for pattern = 1 : group
      UE_postion = [];
      UE_postion = ue_loc([(pattern-1)*num_per_group+1 : pattern*num_per_group] , :);
      Drone_loc_intuitive(pattern,:) = [mean(UE_postion(:,1)) mean(UE_postion(:,2))];
    end  
    bs_loc_intuitive = [];
    bs_loc_intuitive_x = [];
    bs_loc_intuitive_y = []; 
    bs_loc_intuitive = Drone_loc_intuitive.';

    bs_loc_intuitive_x = bs_loc_intuitive(1,:);
    bs_loc_intuitive_y = bs_loc_intuitive(2,:);
    
    figure(1) ; % 12 pattern (12 ASC)
    plot(ue_loc_x,ue_loc_y, 'ko', bs_loc_intuitive_x,bs_loc_intuitive_y,'r^','LineWidth',1,'MarkerSize',5);  %正常sin圖+點
    ylabel('Y (m)')
    xlabel('X (m)');
    axis([0 width 0 high]);
    set(gca,'xtick',[0:10:width])
    set(gca,'ytick',[0:10:high])
    %hold on
    %axis equal
    grid on; 
       
    %All_on ; RSRP[ue_number, cell_number]
    RSRP_total_intuitive = zeros(length(ue_loc),length(bs_loc_intuitive));
    for j = 1:length(ue_loc)
        for i=1:length(bs_loc_intuitive)
            d_2d = sqrt((ue_loc_x(j)-bs_loc_intuitive_x(i))^2 + (ue_loc_y(j)-bs_loc_intuitive_y(i))^2) + 1;
            RSRP_total_intuitive(j,i) = RSRP_3D_UAV_UE(Pt, H, d_2d, fc); %fc(GHz)
        end
    end
    [Rx_signal_All,Rx_interfer_All,n] = Rx_signal_interference(ue_num, bs_loc_intuitive, RSRP_total_intuitive); % n: the # of served users per APC 
    [SINR_All(time_slot,:), datarate_All(time_slot,:), C_All(time_slot,:)] = All_Capacity(Rx_signal_All, Rx_interfer_All, ue_num, W, N0);     
    SINR_All_dB(time_slot,:) = 10*log10(SINR_All(time_slot,:));   
    
    % We hope you to build the code of APC power control and evaluate the performance (total system throughput) in this homework.
    %{
        Input parameter detail:
        `ue_num` represents as Total number of UEs; expected 60 UEs
        `length(bs_loc_intuitive)` represents as Total number of UAVs; expected 12 UAVs
        `Rx_signal_All` represents as Received UE signals in each UAV;
        `Rx_interfer_All` represents as Captured signal interferences in each UAV;
    %}
    apc = APC(ue_num, length(bs_loc_intuitive), Rx_signal_All, Rx_interfer_All);
    apc = apc.run(); % executes APC algorithm
    cluster_center = apc.get_cluster_center;
    normalized_rx_signal = apc.get_norm_rx_signal;
    normalized_rx_interfer = apc.get_norm_rx_interfer;
    similarity_matrix = apc.get_similarity_matrix;
%     normalized_rx_interfer = apc.get_norm_rx_interfer;
       
%     n(cluster_center) = 0; % n: the # of served users per cell 
%     bs_loc_intuitive_APC = bs_loc_intuitive(n ~= 0);
%     Rx_power_APC = RSRP_total_intuitive(:,n ~= 0); %只留有服務ue的cell
%     [Rx_signal_APC, Rx_interfer_APC,n_APC] = Rx_signal_interference(ue_num, bs_loc_intuitive_APC, Rx_power_APC); % n_APC : 每個cell服務的user數量
%     [SINR_APC(time_slot,:), datarate_APC(time_slot,:), C_APC(time_slot,:)] = All_Capacity(Rx_signal_APC, Rx_interfer_APC, ue_num, W, N0);    
%     SINR_APC_dB(time_slot,:) = 10*log10(SINR_APC(time_slot,:));
   
end

C_all_on_avg = mean(C_All); %baseline: total system throughput in average.
%C_APC_avg = mean(C_APC); %APC: total system throughput in average.


   