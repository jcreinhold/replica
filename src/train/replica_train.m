function replica_rf = replica_train(atlas_struct, param_struct, varargin)
%REPLICA_TRAIN outputs a trained REPLICA random forest given a set of 
%   atlases and parameters for training
%
%   Args:
%       atlas_struct: Refer to replica_demo.m to specify parameters in this
%                     struct
%       param_struct: A struct containing the parameters for training.
%          (see utilities/singleres/default_param_struct.m for an example 
%           of the parameters)
%   Output:
%       replica_rf: replica random forest regressor

    % parse arguments to account for optional args
    p = inputParser;
    p.addParameter('seed', 999, @isinteger);
    p.parse(varargin{:})
    params = p.Results;
    
    % set the random seed for reproducability
    rng(params.seed)
    
    % initialize some parameters
    n_training_samples = param_struct.no_of_training_samples;
    n_atlas_brains = length(atlas_struct.t1w);
    param_struct.n_training_samples_per_brain = ...
        round(n_training_samples/n_atlas_brains);

    % extract patches and values from atlases for regression training
    all_atlas_patches = [];
    all_atlas_Y = [];

    for i = 1:n_atlas_brains
        fprintf('getting patches for atlas %d\n', i);
        [atlas_patches, atlas_Y] = train_patches(atlas_struct, param_struct, i);
        all_atlas_patches = [all_atlas_patches, atlas_patches];
        all_atlas_Y = [all_atlas_Y, atlas_Y];
    end

    % train the regression random forest and return it
    fprintf('training random forest\n');
    options = statset('UseParallel', 'always');
    min_leaf_size = param_struct.MinLeafSize;
    replica_rf = TreeBagger(param_struct.nTrees, all_atlas_patches(:, 1:end)', ...
                    all_atlas_Y(:, 1:end)', 'method', 'regression', ...
                    'MinLeafSize', min_leaf_size, 'Options', options);
end
