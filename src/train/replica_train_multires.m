function replica_rfs = replica_train_multires(atlas_struct, param_struct)
%REPLICA_training trains a multiresolution REPLICA random forest

% rename for convenience, since this is used all over
ps = param_struct;

% initialize some parameters
n_training_samples = ps.no_of_training_samples;
n_atlas_brains = length(atlas_struct.source);
ps.n_training_samples_per_brain = ...
    round(n_training_samples/n_atlas_brains);
H = fspecial3('gaussian', ps.gaussian_kernel_size);

% holds training patches for low, itermediate, high resolution
patches = {[], [], []};
ys = {[], [], []};

% holds trained random forests
replica_rfs = cell(3,1);

% resolutions over which to calculate rfs
resolutions = {'low', 'intermediate', 'high'};

for iter=1:n_atlas_brains
    % open the source and target images
    [atlas_src, ~] = open_atlas(atlas_struct.source{iter}, ps, true);
    [atlas_trg, ~] = open_atlas(atlas_struct.target{iter}, ps, false);
    for r=1:3
        fprintf('getting patches for %s resolution on iter %d\n', ...
                resolutions{r}, iter);
        [trg, ~] = multiresolution(atlas_trg, H, r);
        [src, g] = multiresolution(atlas_src, H, r);
        if r > 1
            rs_trg = interp3(trg, 1);
            rs_trg = interp3(rs_trg, g{1}, g{2}, g{3});
            [p, y] = multires_train_patches(src, trg, ps, r, rs_trg);
        else
            [p, y] = multires_train_patches(src, trg, ps, r, []);
        end
        patches{r} = [patches{r}, p];
        ys{r} = [ys{r}, y];
    end
end

% manual memory management, since some of the objects get very large
clearvars -except ps patches ys resolutions

opts = statset('UseParallel', 'always');
for r=1:3
    fprintf('training for %s resolution\n', resolutions{r});
    p = patches{r};
    y = ys{r};
    replica_rfs{r} = TreeBagger(ps.nTrees{r}, p(:,1:end)', y(:,1:end)', ...
                                'method','regression', 'Options', opts);
end

end