function param_struct = default_param_struct()
%DEFAULT_PARAM_STRUCT create a default param_struct for ease-of-use
% User will still need to specify the task for REPLICA by setting 
% target to 't2w', 'pdw', or 'flair'

    % set parameters for training the random forest
    param_struct.patch_size = [3,3,3];

    % number of samples to be used for training
    param_struct.no_of_training_samples = 1E5;

    % user needs to set to 't1w', 't2w', 'pdw', or 'flair'
    param_struct.target = '';

    % if you want to use a context patch in the feature set in addition
    % to the local patch
    param_struct.use_context_patch = 1;

    % threshold for intensities in target (no negative intensities in foreground)
    param_struct.threshold = 0;

    % set the context patch parameters
    param_struct.r1 = 4;
    param_struct.r2 = 8;
    param_struct.r3 = 16;
    param_struct.r4 = 32;

    param_struct.w1 = [3, 3, 3];
    param_struct.w2 = [5, 5, 5];
    param_struct.w3 = [7, 7, 7];
    param_struct.w4 = [9, 9, 9];

    % number of trees
    param_struct.nTrees = 30;

    % MinLeafSize for each tree
    param_struct.MinLeafSize = 5;
    
    % do WM peak normalization or not
    param_struct.wm_peak_normalize = false;
end

