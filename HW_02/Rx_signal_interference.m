function [Rx_signal_SC,Rx_interfer_SC,n] = Rx_signal_interference(user_num, UAV_loc, Rx_power_SC)

%Multiple Small Cell
SC_num = length(UAV_loc);

% Detailed explination
bs_of_ue_n = zeros(1, user_num); % 標示每個user的服務cell編號
n = zeros(1, SC_num); %每個cell服務的user數量
s1 = ones(SC_num,user_num); % 建立欄位值全為1的矩陣
s2 = zeros(SC_num,user_num); % 建立欄位值全為0的矩陣
    for j = 1 : user_num
        [~ , nearest] = max(Rx_power_SC(j,:)); %挑出RSRP最大值(選要給哪個BS服務)
        n(nearest) = n(nearest) + 1; %累計每個BS有n個User
        bs_of_ue_n(j) = nearest; %bs_of_ue是ue在哪個bs裡面
        s1(bs_of_ue_n(j),j) = 0; % 將連線的BS與User欄位值變成0，其餘1皆為干擾 
        s2(bs_of_ue_n(j),j) = 1; % 將連線的BS與User欄位值變成1，其餘0皆為干擾     
    end
s1 = s1.'; %轉置成ones(length(ue_loc),length(bs_loc))
s2 = s2.'; %轉置成zeros(length(ue_loc),length(bs_loc))

Rx_signal_SC = s2.* Rx_power_SC;
Rx_interfer_SC = s1.* Rx_power_SC; % 穿牆損耗5dB(服務的強度不損耗5dB;干擾的強度損耗5dB)

        
end                                                                        % end function
 