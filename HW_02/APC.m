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
        norm_rx_signal;
        norm_rx_interfer;
        cluster_center = [];
        n_iters;
        
        % APC related parameters
        similarity_matrix = {};
        similarity_matrix_min = 999.0;  % default value
        
        % RESTful API endpoints
        url_apc_orig = "http://localhost:8085/algorithm/apc/original";
    end
    methods
        function self = APC(ue_num, uav_num, Rx_signal_All, Rx_interfer_All, n_iters)
            % class constructor
            self.ue_num          = ue_num;
            self.uav_num         = uav_num;
            self.Rx_signal_All   = Rx_signal_All;
            self.Rx_interfer_All = Rx_interfer_All;
            self.n_iters         = n_iters;
            
            % set default value 
            self.similarity_matrix{1, 1} = 0.0;
        end
        
        % This function executes calculation of APC algorithm
        function self = run(self)
            % Normalize values (easier to understand)
            self = self.normalize_rx_signal();
            self = self.normalize_rx_interfer();
            
            % Calculate similarity matrix
            self = self.calculate_similarity_matrix();
            
            % call Restful API
            self = self.send_post_request();
            
            % Calculate responsibility matrix
%             self = self.calculate_responsibility_matrix();
            
            % Calculate with original APC algorithm
%             self = self.perform_original_apc();
            
%             self.cluster_center = [1, 2, 5];
        end
        
        function self = send_post_request(self)
            options = weboptions('RequestMethod','post', 'MediaType','application/json');
%             Body = struct('similarity_matrix', cell2mat(self.similarity_matrix));
            Body = struct( ...
                "algorithm", "apc", ... 
                "n_iters", 100, ...
                "similarity_matrix", cell2mat(self.similarity_matrix) ...
            );
            response = webwrite(self.url_apc_orig, Body, options);
            col_wise_cluster_head = response.data;
            self.cluster_center = col_wise_cluster_head.';  % convert into row-wise array
            self.cluster_center
        end
        
        function self = calculate_similarity_matrix(self)
            disp("[1] Calculating Similarity Matrix");
            
            [row_num, col_num] = size(self.norm_rx_signal);
            
            % [1.1] Calculate non-diagonal values
            for col = 1:col_num
                ue_in_this_uav = [];
                for row = 1:row_num
                    % Denote source UAV to be compared with
                    % Get data in signal data in this record
                    signal_data = self.norm_rx_signal(row, col);
                    
                    if signal_data ~= 0
%                         disp("@Row=" + row + "; Col=" + col + "; Data=" + signal_data)
                        
                        % push list of UEs in this UAV cluster
                        ue_in_this_uav(end+1) = row;
                    end
                end
                
                % find any interference with other UAVs, 
                % then, calculate SUM of any interferences value
                self = self.calc_sum_interfer(ue_in_this_uav, col, col_num);
%                 disp("...")
            end
            
            % [1.2] Calculate diagonal values
            self = self.set_diagonal_values();
%             disp(" >>> FINAL self.similarity_matrix_min:" + self.similarity_matrix_min)
        end
        
        function self = set_diagonal_values(self)
            for diagonal_idx = 1:self.uav_num
                self.similarity_matrix{diagonal_idx, diagonal_idx} = self.similarity_matrix_min;
            end
        end
        
        function self = calc_sum_interfer(self, ue_in_this_uav, source_col, col_num)
            sum_interfer = 0;
            [~, this_ue_num] = size(ue_in_this_uav);
            % In each UAV cluster (cold), find each interfence (row)
            for col = 1:col_num
                for i = 1:this_ue_num
                    % Get `row` value
                    row = ue_in_this_uav(1, i);

                    % Get interfer_data in this UAV cluster
                    interfer_data = self.norm_rx_interfer(row, col);
%                     disp("@ row=" + row + "; col=" + col + "; Inter=" + interfer_data)

                    if interfer_data ~= 0
                        sum_interfer = sum_interfer + interfer_data;
                    end
                end
                
%                 disp("@ source_col=" + source_col + "; col=" + col + "; FINAL sum_interfer:" + sum_interfer)
                % push SUM interfence for this UAV (col)
                if sum_interfer ~= 0
                    if source_col == col
                        self.similarity_matrix{source_col, col} = 0.0;
                    else
                        self.similarity_matrix{source_col, col} = sum_interfer;
                        
                        % Calculate min. `sum_interfer` value
%                         disp(" --- self.similarity_matrix_min VS sum: " + self.similarity_matrix_min + " -- " + sum_interfer)
                        if self.similarity_matrix_min > sum_interfer
                            self.similarity_matrix_min = sum_interfer;
                        end
                    end
                end
            end
        end
        
        function cluster_center = get_cluster_center(self)
            cluster_center = self.cluster_center;
        end
        
        function self = normalize_rx_signal(self)
            [row_num, col_num] = size(self.Rx_signal_All);
            self.norm_rx_signal = zeros(row_num, col_num);
            
            for col = 1:col_num
                for row = 1:row_num
                    self.norm_rx_signal(row, col) = self.Rx_signal_All(row, col) * 10 ^ 18;
                end
            end
        end
        
        function self = normalize_rx_interfer(self)
            [row_num, col_num] = size(self.Rx_interfer_All);
            self.norm_rx_interfer = zeros(row_num, col_num);
            
            for col = 1:col_num
                for row = 1:row_num
                    self.norm_rx_interfer(row, col) = self.Rx_interfer_All(row, col) * 10 ^ 18;
                end
            end
        end
        
        function norm_rx_signal = get_norm_rx_signal(self)
            norm_rx_signal = self.norm_rx_signal;
        end
        
        function norm_rx_interfer = get_norm_rx_interfer(self)
            norm_rx_interfer = self.norm_rx_interfer;
        end
        
        function similarity_matrix = get_similarity_matrix(self)
            similarity_matrix = cell2mat(self.similarity_matrix);
        end
    end
end

