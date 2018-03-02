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

% enable parallel processing if desired
p = gcp('nocreate'); % If no pool, do not create new one.
if isempty(p)
    poolsize = 0;
else
    poolsize = 8;
end

n_training_samples = param_struct.no_of_training_samples;
n_atlas_brains = param_struct.n_atlas_brains
n_training_samples_per_brain = ...
    round(n_training_samples/n_atlas_brains);

% This will hold all the training patches for the highest resolution
FinalAtlasPatches = [];
FinalAtlasY = [];

for i = 1:n_atlas_brains
    
    % check if synthesizing T2 from T1
    if param_struct.synthT2 == 1
        t1_fn = atlas_struct.t1w{i};
        t2_fn = atlas_struct.t2w{i};
        [AtlasPatches, AtlasY] = synth_t2_train(t1_fn, t2_fn);
        FinalAtlasPatches = [FinalAtlasPatches, AtlasPatches];
        FinalAtlasY = [FinalAtlasY, AtlasY];
        
    elseif param_struct.synthFLAIR == 1
        t1_fn = atlas_struct.t1w{i};
        t2_fn = atlas_struct.t2w{i};
        pd_fn = atlas_struct.pdw{i};
        fl_fn = atlas_struct.flair{i};
        lm_fn = atlas_struct.lesionmask{i};
        [AtlasPatches, AtlasY] = synth_t2_train(t1_fn, t2_fn, pd_fn, ...
                                                fl_fn, lm_fn, param_struct);
        FinalAtlasPatches = [FinalAtlasPatches, AtlasPatches];
        FinalAtlasY = [FinalAtlasY, AtlasY];
        
    end
end

tic;
options = statset('UseParallel', 'always');
min_leaf_size = param_struct.MinLeafSize;
ns = TreeBagger(param_struct.nTrees, FinalAtlasPatches(:, 1:end)', ...
                FinalAtlasY(:, 1:end)', 'method', 'regression', ...
                'MinLeafSize', min_leaf_size, 'Options', options);
toc;
replica_rf{1} = ns;
