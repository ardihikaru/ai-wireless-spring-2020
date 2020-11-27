function [SINR, User_Rate, Capacity] = All_Capacity(Rx_signal, Rx_interference, All_user_num, Bandwidth, N0)

% Detailed explination

SINR = zeros(1, All_user_num);
 for j = 1 : All_user_num
   S = sum(Rx_signal(j,:));
   SUM_I = sum(Rx_interference(j,:));
   serve_cell = find(Rx_signal(j,:)~=0);
   user_num = length(Rx_signal(find(Rx_signal(:,serve_cell)~=0),1));
   SINR(j) = S/(SUM_I+(Bandwidth/user_num)*N0);
   User_Rate(j) = log2(1+SINR(j))./user_num.*Bandwidth*10^(-6); %Mbps
 end
 
Capacity = sum(User_Rate);
end                                                                        % end function
 