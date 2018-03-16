function param_struct = default_param_struct_multires()
%DEFAULT_PARAM_STRUCT_MULTIRES create default param_struct for ease-of-use
% User will still need to specify the task for REPLICA by setting 
% target to 't2w', 'pdw', or 'flair'

    % number of samples to be used for training
    param_struct.no_of_training_samples = 1E5;

    % threshold for intensities in target (no negative intensities in foreground)
    param_struct.threshold = 0;

    % patch sizes?
    param_struct.Nsub4 = [3,3,3];
    param_struct.Nsub2 = [3,3,3];
    param_struct.N = [3,3,3];
    param_struct.N2sub2 = [1,1,1];
    param_struct.N2 = [1,1,1];
    param_struct.M = 1E5;

    % context patch parameters for highest level
    param_struct.r1 = {4, 2, 2};
    param_struct.r2 = {8, 4, 4};
    param_struct.r3 = {16, 8, 8};
    param_struct.r4 = {32, 16, 16};

    param_struct.w1 = {[3, 3, 3],[3, 3, 3],[1, 1, 1]};
    param_struct.w2 = {[5, 5, 5],[5, 5, 5],[3, 3, 3]};
    param_struct.w3 = {[7, 7, 7],[7, 7, 7],[5, 5, 5]};
    param_struct.w4 = {[9, 9, 9],[9, 9, 9],[7, 7, 7]};

    % number of trees
    param_struct.nTrees4 = 60;
    param_struct.nTrees2 = 60;
    param_struct.nTrees = 60;
    param_struct.MinLeafSize = 5;
    
    % gaussian kernel size
    param_struct.gaussian_kernel_size = [5,5,5];
end

