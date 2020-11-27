function [RSRP_total] = RSRP_3D_UAV_UE(Tx_power_UAV, h_ut, d_2D, fc)

channel = Channel_Model_3D('UMi', h_ut, d_2D, fc);
    
Gain = 1./(10.^(channel/10));
RSRP_total = (Tx_power_UAV.*Gain).';
        
end                                                                        % end function
 