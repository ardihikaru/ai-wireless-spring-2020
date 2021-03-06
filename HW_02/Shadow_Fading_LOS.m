function [shadowingL] = Shadow_Fading_LOS(scenario, h_ut, d_2D) 

% the function is used to calculate the shadow fading standard deviation
% the model refers to 36.777 p.28 (Table B-3) and 38.901 p.25 (Table 7.4.1-1)
% a key parameter >>> input  : scenario, h_ut, d_2D
%                     output : LOS shadowing


% initialization

% h_ut                                                                     % UAV-BS flying height (m)
% h_bs                                                                     % base station height (m) 
% d_2D                                                                     % the projection of UAV-user distance on the ground (m) 
% d_bp = 2*pi*h_bs*h_ut*fc/c                                               % breakpoint distance (m)
constant = 0.01;                                                           % control the amplitude of the shadowind 


% Detailed explanation

    if (h_ut < 1.5)
        h_ut = 1.5;
    end
    
    if (d_2D < 10)
        d_2D = 10;    
    end
    
    switch scenario
        
        case {'RMa'}                                                       % RMa scenario
            % h_bs = 35;
            % d_bp = 2*pi*h_bs*h_ut*fc/c;
            if (h_ut < 10)                                                 % 1.5m <= h_ut < 10m
                if (10 <= d_2D) && (d_2D < d_bp)
                    shadowingL = constant*normrnd(0,4);
                else
                    if (d_bp <= d_2D) && (d_2D < 10^4)
                        shadowingL = constant*normrnd(0,6);
                    end
                end
            else 
                if (10 <= h_ut)                            % 10m <= h_ut <= 700m
                    if (10 <= d_2D) && (d_2D < 10^4)
                        shadowingL = constant*normrnd(0,4.2*exp(-0.0046*h_ut));
                    end    
                end
            end
            
        case {'UMa'}                                                       % UMa scenario
            % h_bs = 35;
            if (h_ut < 22.5)                                               % 1.5m <= h_ut < 22.5m
                if (10 <= d_2D) && (d_2D < 5000)
                    shadowingL = constant*normrnd(0,4);
                end    
            else 
                if (22.5 <= h_ut)                          % 22.5m <= h_ut <= 700m
                    if (10 <= d_2D) && (d_2D < 5000)
                        shadowingL = constant*normrnd(0,4.64*exp(-0.0066*h_ut));
                    end    
                end
            end
            
        case {'UMi'}                                                       % UMi scenario
            % h_bs = 10;
            if (h_ut < 22.5)                                               % 1.5m <= h_ut < 22.5m
                if (10 <= d_2D) && (d_2D < 5000)
                    shadowingL = constant*normrnd(0,4);
                end    
            else 
                if (22.5 <= h_ut)                         % 22.5m <= h_ut <= 700m
                    if (10 <= d_2D) && (d_2D < 5000)
                        shadowingL = constant*normrnd(0,max(5*exp(-0.01*h_ut),2));
                    end    
                end
            end        

    end                                                                    % end switch 

end                                                                        % end function

