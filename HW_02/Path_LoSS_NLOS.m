function [pathlossN] = Path_LoSS_NLOS(scenario, h_ut, d_2D, fc)

% The function is used to calculate the pathloss.
% Pathloss refers to 36.777 P.27 (Table B-2) and 38.901 P.25 (Table 7.4.1-1)
% Function Path_Loss
% Key parameters >> input  : scenario, h_ut, d_2D    
%                   output : NLOS pathloss


% initialization

c = 3*10^8;                                                                % light speed (m/s)
% w                                                                        % street width (m)
h_us = 1.5;                                                                % user height (m)
% h_ut                                                                     % UAV-BS flying height (m)
% h_bs                                                                     % ground base station height (m)
% h_bd                                                                     % building height (m)
% fc                                                                       % carrier frequency (GHz)
% d_2D                                                                     % the projection of UAV-user distance on the ground (m) 
% d_3D = (d_2D^2+(h_ut-h_us)^2)^0.5                                        % 3D distance (m)
% scenario                                                                 %select the scenario
% eh_bs = h_bs-1                                                           % effective antenna height at BS (m)
% eh_ut = h_ut-1                                                           % effective antenna height at UT (m) 
% d_bp = 2*pi*h_bs*h_ut*fc/c                                               % breakpoint distance (m)
% d_bpUMa = 4*eh_bs*eh_ut*fc/c                                             % breakpoint distance for UMa (m)
% d_bpUMi = 4*eh_bs*eh_ut*fc/c                                             % breakpoint distance for UMi (m)


% Detailed explanation

    if (h_ut < 1.5)
        h_ut = 1.5;    
    end
    
    if (d_2D < 10)
        d_2D = 10;    
    end
    
    switch scenario
        
        case {'RMa'}                                                       % RMa scenario
            h_bs = 35;
            d_3D = (d_2D^2+(h_ut-h_us)^2)^0.5;
            d_bp = 2*pi*h_ut*h_bs*fc/c;
            h_bd = 5;                                                      % building height
            w = 20;                                                        % street width 
            if (h_ut < 10)                                                 % 1.5m <= h_ut < 10m
                if (10 <= d_2D) && (d_2D < 5000)
                    if (d_2D < d_bp)
                       pathlossa = 20*log10(40*pi*d_3D*fc/3)+min(0.03*h_bd^1.72,10)*log10(d_3D)-min(0.044*h_bd^1.72,14.77)+0.002*log10(h_bd)*d_3D;
                    else
                       pathlossa = 20*log10(40*pi*d_3D*fc/3)+min(0.03*h_bd^1.72,10)*log10(d_3D)-min(0.044*h_bd^1.72,14.77)+0.002*log10(h_bd)*d_3D+40*log10(d_3D/d_bp); 
                    end
                    pathlossb = 161.04-7.1*log10(w)+7.5*log10(h_bd)-(24.37-3.7*(h_bd/h_bs)^2)*log10(h_bs)+(43.42-3.1*log10(h_bs))*(log10(d_3D)-3)+20*log10(fc)-(3.2*(log10(11.75*h_ut))^2-4.97);
                    pathlossN = max(pathlossa,pathlossb);
                end    
            else                                                    
                if (10 <= h_ut) && (d_2D < 10^4)           % 10m <= h_ut <= 700m , d_2D < 10^4m  
                   pathlossN = max(max(23.9-1.8*log10(h_ut),20)*log10(d_3D)+20*log10(40*pi*fc/3),-12+(35-5.3*log10(h_ut))*log10(d_3D)+20*log10(40*pi*fc/3));
                end   
            end  
            
        case {'UMa'}                                                       % UMa scenario
            h_bs = 25;
            d_3D = (d_2D^2+(h_ut-h_us)^2)^0.5;
            eh_bs = h_bs-1;                                                % effective antenna height at BS
            eh_ut = h_ut-1;                                                % effective antenna height at UT
            d_bpUMa = 4*eh_bs*eh_ut*fc/c;                                  % breakpoint distance for UMa
            if (h_ut < 22.5)                                               % 1.5m <= h_ut < 22.5m
               if (10 <= d_2D) && (d_2D < 5000)
                    if (d_2D < d_bpUMa)
                       pathlossa = 28+22*log10(d_3D)+20*log10(fc);
                    else
                       pathlossa = 28+40*log10(d_3D)+20*log10(fc)-9*log10((d_bpUMa)^2+(h_us-h_ut)^2); 
                    end
                    pathlossb = 13.54+39.08*log10(d_3D)+20*log10(fc)-0.6*(h_ut-1.5);
                    pathlossN = max(pathlossa,pathlossb);
                end    
            else                                                    
                if (22.5 <= h_ut) && (d_2D < 4000)           % 22.5m <= h_ut <= 700m , d_2D < 4000m  
                   pathlossN = -17.5+(46-7*log10(h_ut))*log10(d_3D)+20*log10(40*pi*fc/3);
                end   
            end
       
            case {'UMi'}                                                   % UMi scenario
            h_bs = 10;
            d_3D = (d_2D^2+(h_ut-h_us)^2)^0.5;
            eh_bs = h_bs-1;                                                % effective antenna height at BS
            eh_ut = h_ut-1;                                                % effective antenna height at UT
            d_bpUMi = 4*eh_bs*eh_ut*fc/c;                                  % breakpoint distance for UMa
            if (h_ut < 22.5)                                               % 1.5m <= h_ut < 22.5m
                if (10 <= d_2D) && (d_2D < 5000)
                    if (d_2D < d_bpUMi)
                       pathlossa = 32.4+21*log10(d_3D)+20*log10(fc);
                    else
                       pathlossa = 32.4+40*log10(d_3D)+20*log10(fc)-9.5*log10((d_bpUMi)^2+(h_bs-h_ut)^2); 
                    end
                    pathlossb = 35.3*log10(d_3D)+22.4+21.3*log10(fc)-0.3*(h_ut-1.5);
                    pathlossN = max(pathlossa,pathlossb);
                end    
            else                                                    
                if (22.5 <= h_ut) && (d_2D < 4000)        % 22.5m <= h_ut <= 700m , d_2D < 4000  
                   pathlossN = max(max(20*log10(d_3D)+20*log10(fc)-27.55,30.9+(22.25-0.5*log10(h_ut))*log10(d_3D)+20*log10(fc)),32.4+(43.2-7.6*log10(h_ut))*log10(d_3D)+20*log10(fc));
                end   
            end

    end                                                                    % switch
  
end                                                                        % function
