%{
  Input parameters:
    - Total number of UEs is denoted as `ue_num`; expected 60 UEs
    - Total number of UAVs is denoted as `uav_num`; expected 12 UAVs
    - Received UE signals in each UAV is denoted as `Rx_signal_All`;
    - Captured signal interferences in each UAV is denoted as `Rx_interfer_All`;

  Output parameters:
    - cluster_center
%}

classdef APC
    properties
        ue_num;
        uav_num;
        Rx_signal_All;
        Rx_interfer_All;
        cluster_center = [];
    end
    methods
        function self = APC(ue_num, uav_num, Rx_signal_All, Rx_interfer_All)
            % class constructor
            self.ue_num          = ue_num;
            self.uav_num         = uav_num;
            self.Rx_signal_All   = Rx_signal_All;
            self.Rx_interfer_All = Rx_interfer_All;
        end
        
        function self = run(self)
            % This function executes calculation of APC algorithm
            self.cluster_center = [1, 2, 5];
        end
        
        function cluster_center = get_cluster_center(self)
            cluster_center = self.cluster_center;
        end
    end
end

