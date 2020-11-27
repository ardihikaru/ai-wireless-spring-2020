function [channel] = Channel_Model_3D(scenario, h_ut, d_2D, fc)

% the function is used to calculate the 3D channel model
% a key parameter >>> input  : scenario, h_ut, d_2D, fc
%                     output : channel


% Detailed explination

channel = Path_LoSS_LOS(scenario, h_ut, d_2D, fc)*Pr_LoS(scenario, h_ut, d_2D)+...
          Path_LoSS_NLOS(scenario, h_ut, d_2D, fc)*(1-Pr_LoS(scenario, h_ut, d_2D))+...
          Shadow_Fading_LOS(scenario, h_ut, d_2D)*Pr_LoS(scenario, h_ut, d_2D)+...
          Shadow_Fading_NLOS(scenario, h_ut, d_2D)*(1-Pr_LoS(scenario, h_ut, d_2D));

end                                                                        % end function


