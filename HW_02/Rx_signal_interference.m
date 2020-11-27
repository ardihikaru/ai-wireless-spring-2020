function [Rx_signal_SC,Rx_interfer_SC,n] = Rx_signal_interference(user_num, UAV_loc, Rx_power_SC)

%Multiple Small Cell
SC_num = length(UAV_loc);

% Detailed explination
bs_of_ue_n = zeros(1, user_num); % �ХܨC��user���A��cell�s��
n = zeros(1, SC_num); %�C��cell�A�Ȫ�user�ƶq
s1 = ones(SC_num,user_num); % �إ����ȥ���1���x�}
s2 = zeros(SC_num,user_num); % �إ����ȥ���0���x�}
    for j = 1 : user_num
        [~ , nearest] = max(Rx_power_SC(j,:)); %�D�XRSRP�̤j��(��n������BS�A��)
        n(nearest) = n(nearest) + 1; %�֭p�C��BS��n��User
        bs_of_ue_n(j) = nearest; %bs_of_ue�Oue�b����bs�̭�
        s1(bs_of_ue_n(j),j) = 0; % �N�s�u��BS�PUser�����ܦ�0�A��l1�Ҭ��z�Z 
        s2(bs_of_ue_n(j),j) = 1; % �N�s�u��BS�PUser�����ܦ�1�A��l0�Ҭ��z�Z     
    end
s1 = s1.'; %��m��ones(length(ue_loc),length(bs_loc))
s2 = s2.'; %��m��zeros(length(ue_loc),length(bs_loc))

Rx_signal_SC = s2.* Rx_power_SC;
Rx_interfer_SC = s1.* Rx_power_SC; % ����l��5dB(�A�Ȫ��j�פ��l��5dB;�z�Z���j�׷l��5dB)

        
end                                                                        % end function
 