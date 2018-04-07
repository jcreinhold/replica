function replica_rfs = replica_train_multires_low_memory(atlas_struct, param_struct)
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

% save individual RF models to HD in temp files to free memory
rf_tmp = {[tempname '.mat'], [tempname '.mat'], [tempname '.mat']};

% resolutions over which to calculate rfs
resolutions = {'low', 'intermediate', 'high'};

for r=1:3
    % holds training patches, y for one resolution before cleared
    patches = [];
    ys = [];
    for iter=1:n_atlas_brains
        % open the source and target images
        [src0, trg0] = get_imgs(atlas_struct, ps, iter);
        fprintf('getting patches for %s resolution on iter %d\n', ...
                resolutions{r}, iter);
        [trg, ~] = multiresolution_low_memory(trg0, H, r);
        [src, g] = multiresolution_low_memory(src0, H, r);
        if r > 1
            [trg_prev, ~] = multiresolution_low_memory(trg, H, r-1);
            rs_trg = interp3(trg_prev, 1);
            rs_trg = interp3(rs_trg, g{1}, g{2}, g{3});
            [p, y] = train_patches_multires(src, trg, ps, r, rs_trg, ...
                                            src0, trg0, g);
        else
            [p, y] = train_patches_multires(src, trg, ps, r, [], [], [], []);
        end
        patches = [patches, p];
        ys = [ys, y];
    end
    fprintf('training for %s resolution\n', resolutions{r});
    replica_rf = TreeBagger(ps.nTrees{r}, patches(:,1:end)', ys(:,1:end)', ...
                            'method','regression', 'Options', opts);    
    save(rf_tmp{r}, 'replica_rf', '-v7.3'); 
    clearvars replica_rf patches ys src trg g
end

% manual memory management, since some of the objects get very large
clearvars -except rf_tmp

% holds trained random forests
replica_rfs = cell(3,1);

for r=1:3
    fn = rf_tmp{r};
    load(fn, 'replica_rf');
    replica_rfs{r} = replica_rf;
    % ensure temp files are deleted ASAP, since they are rather large
    delete(fn);
end

end


function [src, trg] = get_imgs(atlas_struct, ps, iter)
% get the source and target images for processing
    [src, dim] = open_atlas(atlas_struct.source{iter}, ...
                            ps.w4{3}, ps.r4{3}, ...
                            'isT1', true, ...
                            'BrainMask', atlas_struct.brainmasks{iter}, ...
                            'WMPeakNormalize', ps.wm_peak_normalize, ...
                            'fcmeans', ps.fcmeans);  
    [trg, ~] = open_atlas(atlas_struct.target{iter}, ...
                          ps.w4{3}, ps.r4{3}, ...
                          'isT1', false, ...
                          'BrainMask', atlas_struct.brainmasks{iter}, ...
                          'WMPeakNormalize', ps.wm_peak_normalize, ...
                          'fcmeans', ps.fcmeans, ...
                          'T1wNormImg', unpad(src, ps.w4{3}, ps.r4{3}, dim));
end