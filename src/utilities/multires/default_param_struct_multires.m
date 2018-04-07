function param_struct = default_param_struct_multires()
%DEFAULT_PARAM_STRUCT_MULTIRES create default param_struct for ease-of-use

    % number of samples to be used for training
    param_struct.no_of_training_samples = 1E5;

    % threshold for intensities in target (no negative intensities in foreground)
    param_struct.threshold = 0;

    % patch sizes for double downsampled, downsampled, and original
    param_struct.N = {[3,3,3], [3,3,3], [3,3,3]};
    % for iterped downsampled and interpd original, respectively
    param_struct.N2 = {[1,1,1], [1,1,1]};

    % context patch parameters
    param_struct.r1 = {2, 2, 4};
    param_struct.r2 = {4, 4, 8};
    param_struct.r3 = {8, 8, 16};
    param_struct.r4 = {16, 16, 32};

    param_struct.w1 = {[1, 1, 1],[3, 3, 3],[3, 3, 3]};
    param_struct.w2 = {[3, 3, 3],[5, 5, 5],[5, 5, 5]};
    param_struct.w3 = {[5, 5, 5],[7, 7, 7],[7, 7, 7]};
    param_struct.w4 = {[7, 7, 7],[9, 9, 9],[9, 9, 9]};

    % number of trees
    param_struct.nTrees = {60, 60, 60};
    
    % gaussian kernel size
    param_struct.gaussian_kernel_size = [5,5,5];
    
    % do WM peak normalization or not
    param_struct.wm_peak_normalize = true;
    
    % use fuzzy c-means for WM peak normalization or not
    param_struct.fcmeans = false;
end

