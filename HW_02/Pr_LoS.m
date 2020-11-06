function [P_los] = Pr_LoS(scenario, h_ut, d_2D)

% The function is used to calculate the LoS probability of the data links.
% LoS Probability refers to 36.777 P.26 (Table B-1) and 38.901 P.27 (Table 7.4.2-1)
% Function Pr_LoS
% Key parameters >> input  : scenario, h_ut, d_2D    
%                   output : P_los

% Detailed explanation

    if (h_ut < 1.5)
        h_ut = 1.5;    
    end
    
    switch scenario
        case {'UMi'}
            if (h_ut <= 22.5)                                     % 1.5m <= h_ut <= 22.5m
                if d_2D > 18
                    P_los = (18/d_2D)+exp(-d_2D/36)*(1-(18/d_2D));
                else
                   P_los = 1; 
                end    
            else                                                  % 22.5m < h_ut <= 700m  
                p1 = 233.98*log10(h_ut)-0.95;
                d1 = max(294.05*log10(h_ut)-432.94, 18);
                if d_2D > d1
                    P_los = (d1/d_2D)+exp(-d_2D/p1)*(1-(d1/d_2D));
                else
                    P_los = 1; 
                end           
            end  

        case {'UMa'}
            if (h_ut <= 22.5)                                     % 1.5m <= h_ut <= 22.5m
                if h_ut <= 13
                    C_p = 0;
                else 
                    C_p = ((h_ut-13)/10)^1.5;
                end      
                if d_2D > 18
                    P_los = ((18/d_2D)+exp(-d_2D/63)*(1-(18/d_2D)))*(1+(C_p*5/4*((d_2D/100)^3)*exp(-d_2D/150)));
                else
                   P_los = 1; 
                end    
            elseif (h_ut > 22.5)                  % 22.5m < h_ut
                p1 = 4300*log10(h_ut)-3800;
                d1 = max(460*log10(h_ut)-700, 18);
                if d_2D > d1
                    P_los = (d1/d_2D)+exp(-d_2D/p1)*(1-(d1/d_2D));
                else
                    P_los = 1; 
                end           
            else (h_ut > 400)
                P_los = 1; 
            end  

        case {'RMa'}
            if (h_ut <= 10)                                     % 1.5m <= h_ut <= 10m
                if d_2D > 10
                    P_los = exp((10-d_2D)/1000);
                else
                   P_los = 1; 
                end    
            elseif (h_ut > 10) && (h_ut <= 40)                  % 10m < h_ut <= 40m
                p1 = max(15021*log10(h_ut)-16053, 1000);
                d1 = max(1350.8*log10(h_ut)-1602, 18);
                if d_2D > d1
                    P_los = (d1/d_2D)+exp(-d_2D/p1)*(1-(d1/d_2D));
                else
                    P_los = 1; 
                end            
            else (h_ut > 40)                                    % 40m < h_ut 
                P_los = 1; 
            end  

    end % switch
  
end % function

