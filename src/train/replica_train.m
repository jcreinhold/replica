function replica_rf = replica_train(atlas_struct, param_struct)
%REPLICA_TRAIN outputs a trained REPLICA random forest given a set of 
%   atlases and parameters for training
%
%   Args:
%       atlas_struct: Refer to replica_demo.m to specify parameters in this
%                     struct
%       param_struct: A struct containing the parameters for training.
%
%   Output:
%       replica_rf: replica random forest regressor

n_training_samples = param_struct.no_of_training_samples;
n_atlas_brains = length(atlas_struct.t1w);
param_struct.n_training_samples_per_brain = ...
    round(n_training_samples/n_atlas_brains);

% This will hold all the training patches for the highest resolution
all_atlas_patches = [];
all_atlas_Y = [];

for i = 1:n_atlas_brains
    if param_struct.synthT2 == 1
        t1_fn = atlas_struct.t1w{i};
        t2_fn = atlas_struct.t2w{i};
        [atlas_patches, atlas_Y] = t2_train_patches(t1_fn, t2_fn);
        all_atlas_patches = [all_atlas_patches, atlas_patches];
        all_atlas_Y = [all_atlas_Y, atlas_Y];
    elseif param_struct.synthFLAIR == 1
        t1_fn = atlas_struct.t1w{i};
        t2_fn = atlas_struct.t2w{i};
        pd_fn = atlas_struct.pdw{i};
        fl_fn = atlas_struct.flair{i};
        lm_fn = atlas_struct.lesionmask{i};
        [atlas_patches, atlas_Y] = flair_train_patches(t1_fn, t2_fn, pd_fn, ...
                                                fl_fn, lm_fn, param_struct);
        all_atlas_patches = [all_atlas_patches, atlas_patches];
        all_atlas_Y = [all_atlas_Y, atlas_Y];
    else
        error(['param_struct.synthFLAIR or param_struct.synthT2', ...
               'needs to be set to 1']);
    end
end

options = statset('UseParallel', 'always');
min_leaf_size = param_struct.MinLeafSize;
ns = TreeBagger(param_struct.nTrees, all_atlas_patches(:, 1:end)', ...
                all_atlas_Y(:, 1:end)', 'method', 'regression', ...
                'MinLeafSize', min_leaf_size, 'Options', options, ...
                'NumPrint', false);
replica_rf{1} = ns;
