function replica_rfs = replica_train_multires(atlas_struct, param_struct)
%REPLICA_training trains a multiresolution REPLICA random forest
%   given atlases and parameters for training
%
%   Args:
%       atlas_struct: Refer to replica_demo.m to specify parameters in this
%                     struct
%       param_struct: A struct containing the parameters for training
%           (see utilities/multires/default_param_struct_multires.m for
%            an example of the parameters)
%
%   Output:
%       replica_rf: replica random forest regressor

% rename for convenience, since this is used all over
ps = param_struct;

% initialize some parameters
n_training_samples = ps.no_of_training_samples;
n_atlas_brains = length(atlas_struct.source);
ps.n_training_samples_per_brain = ...
    round(n_training_samples/n_atlas_brains);
H = fspecial3('gaussian', ps.gaussian_kernel_size);
opts = statset('UseParallel', 'always');

% holds training patches for low, itermediate, high resolution
patches = {[], [], []};
ys = {[], [], []};

% rf temp filenames
rf_tmp = {tempname, tempname, tempname};

% resolutions over which to calculate rfs
resolutions = {'low', 'intermediate', 'high'};

for r=1:3
    for iter=1:n_atlas_brains
        % open the source and target images
        [atlas_src, ~] = open_atlas(atlas_struct.source{iter}, ps.w4{3}, ps.r4{3}, true);
        [atlas_trg, ~] = open_atlas(atlas_struct.target{iter}, ps.w4{3}, ps.r4{3}, false);
        fprintf('getting patches for %s resolution on iter %d\n', ...
                resolutions{r}, iter);
        [trg, ~] = multiresolution(atlas_trg, H, r);
        [src, g] = multiresolution(atlas_src, H, r);
        if r > 1
            rs_trg = interp3(trg, 1);
            rs_trg = interp3(rs_trg, g{1}, g{2}, g{3});
            [p, y] = train_patches_multires(src, trg, ps, r, rs_trg);
        else
            [p, y] = train_patches_multires(src, trg, ps, r, []);
        end
        patches{r} = [patches{r}, p];
        ys{r} = [ys{r}, y];
    end
    fprintf('training for %s resolution\n', resolutions{r});
    replica_rf = TreeBagger(ps.nTrees{r}, p(:,1:end)', y(:,1:end)', ...
                            'method','regression', 'Options', opts);
               
    save([rf_tmp{r} '.mat'], 'replica_rf'); 
    clearvars replica_rf patches ys trg src g
end

% manual memory management, since some of the objects get very large
clearvars -except rf_tmp

% holds trained random forests
replica_rfs = cell(3,1);

for r=1:3
    load(rf_tmp{r});
    replica_rfs{r} = replica_rf;
end

end