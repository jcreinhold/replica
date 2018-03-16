function replica_rf = replica_train_multires(atlas_struct, param_struct)
%REPLICA_training trains a multiresolution REPLICA random forest
% avoid using this function if you can, try skull-stripping and using the
% single resolution version before venturing down this path.

% rename for convenience, since this is used all over
ps = param_struct;

% this func pulls out all required vars and assigns them in workspace
get_param_struct_params(ps)

% initialize some parameters
n_training_samples = ps.no_of_training_samples;
n_atlas_brains = length(atlas_struct.source);
ps.n_training_samples_per_brain = ...
    round(n_training_samples/n_atlas_brains);
H = fspecial3('gaussian', ps.gaussian_kernel_size);

% Holds all the training patches for the lowest resolution
FinalAtlasPatchessub4  =[];
FinalAtlasYsub4 = [];

% Holds all the training patches for the intermediate resolution
FinalAtlasPatchessub2  =[];
FinalAtlasYsub2 = [];

% Holds all the training patches for the highest resolution
FinalAtlasPatches  =[];
FinalAtlasY = [];

for iter=1:n_atlas_brains

    % open the source and target images
    [atlas_src, ~] = open_atlas_multires(atlas_struct.source{iter}, ps.w4{1}, ps.r4{1});
    [atlas_trg, ~] = open_atlas_multires(atlas_struct.target{iter}, ps.w4{1}, ps.r4{1});
    
    % resample images - high, intermediate, and low resolution
    fprintf('Creating multiresolution images on iter: %d\n', iter);
    [atlas_trg, atlas_trg_sub2, atlas_trg_sub4, ~, ~, ~] = multiresolution(atlas_trg, H);
    [atlas_src, atlas_src_sub2, atlas_src_sub4, g1, g2, ~] = multiresolution(atlas_src, H);
    
    % Get patches for the lowest resolution images
    fprintf('Getting patches for sub4 resolution on iter: %d\n', iter);
    [I, J, K, orig, n, ~] = get_params_multires(atlas_src_sub4, ps);
    
    AtlasPatchessub4 = zeros(Lsub4+32, n);
    AtlasYsub4 = zeros(1,n);
    
    for viter=1:n
        i = I(viter);
        j = J(viter);
        k = K(viter);
        
        [ii, jj, kk] = patch_indices(i, j, k, Nsub4);
        x = reshape(atlas_src_sub4(ii,jj,kk), [Lsub4 1]);
        z3 = extract_context_patch(atlas_src_sub4, i, j, k, ...
                                   r1_4, r2_4, r3_4, r4_4, ...
                                   w1_4, w2_4, w3_4, w4_4, orig);
        
        x = [x;z3];
        AtlasPatchessub4(:,viter) = x;
        AtlasYsub4(viter) = atlas_trg_sub4(i,j,k);      
    end
    
    FinalAtlasPatchessub4 = [FinalAtlasPatchessub4,AtlasPatchessub4];
    FinalAtlasYsub4 = [FinalAtlasYsub4,AtlasYsub4];
    
    % get patches for the intermediate resolution images
    fprintf('Getting patches for sub2 resolution on iter: %d\n', iter);
    
    res_atlas_trg_sub4  = interp3(atlas_trg_sub4, 1);
    res_atlas_trg_sub4 = interp3(res_atlas_trg_sub4, g2{1}, g2{2}, g2{3});
    [I, J, K, orig, n, ~] = get_params_multires(atlas_src_sub2, ps);
    
    AtlasPatchessub2 = zeros(Lsub2+L2sub2+32,n);
    AtlasYsub2 = zeros(1,n);
    
    for viter=1:n
        i = I(viter);
        j = J(viter);
        k = K(viter);
        
        [ii, jj, kk] = patch_indices(i, j, k, Nsub2);
        [ii2, jj2, kk2] = patch_indices(i, j, k, N2sub2);
        x = reshape(atlas_src_sub2(ii, jj, kk), [Lsub2, 1]);
        z1 = reshape(res_atlas_trg_sub4(ii2, jj2, kk2), [L2sub2, 1]);
        z3 = extract_context_patch(atlas_src_sub2, i, j, k, ...
                                   r1_2, r2_2, r3_2, r4_2, ...
                                   w1_2, w2_2, w3_2, w4_2, orig);
                             
        x = [x;z3;z1];
        AtlasPatchessub2(:,viter) = x;
        AtlasYsub2(viter) = atlas_trg_sub2(i,j,k);
    end
    
    FinalAtlasPatchessub2 = [FinalAtlasPatchessub2,AtlasPatchessub2];
    FinalAtlasYsub2 = [FinalAtlasYsub2,AtlasYsub2];
    
    % Get patches for the highest resolution image
    fprintf('Getting patches for full resolution on iter: %d\n', iter);
    
    % below is a hack to make there be 9000 no_quantile_voxels 
    % (replicates old code behavior)
    ps.n_training_samples_per_brain = 9000 * 100;
    [I, J, K, orig, n] = get_train_params(atlas_src, atlas_trg, ps);
    res_atlas_trg_sub2 = interp3(atlas_trg_sub2, 1);
    res_atlas_trg_sub2  = interp3(res_atlas_trg_sub2, g1{1}, g1{2}, g1{3});
    
    AtlasPatches = zeros(L+L2+32,n);
    AtlasY = zeros(1,n);
    
    for viter=1:n
        i = I(viter);
        j = J(viter);
        k = K(viter);
        
        [ii, jj, kk] = patch_indices(i, j, k, N);
        [ii2, jj2, kk2] = patch_indices(i, j, k, N2);
        x = reshape(atlas_src(ii, jj, kk), [L, 1]);
        z1 = reshape(res_atlas_trg_sub2(ii2, jj2, kk2), [L2, 1]);
        z3 = extract_context_patch(atlas_src, i, j, k, ...
                                   r1_1, r2_1, r3_1, r4_1, ...
                                   w1_1, w2_1, w3_1, w4_1, orig);
                             
        x = [x;z3;z1];
        AtlasPatches(:,viter) = x;
        AtlasY(viter) = atlas_trg(i,j,k); 
    end
    
    FinalAtlasPatches = [FinalAtlasPatches,AtlasPatches];
    FinalAtlasY = [FinalAtlasY,AtlasY];
    
end

disp('Training for sub4 resolution');
options = statset('UseParallel', 'always');
nssub4 = TreeBagger(ps.nTrees4, FinalAtlasPatchessub4(:,1:end)', ...
                    FinalAtlasYsub4(:,1:end)','method','regression', ...
                    'Options', options);
replica_rf{1} = nssub4;


disp('Training for sub2 resolution');
nssub2 = TreeBagger(ps.nTrees2, FinalAtlasPatchessub2(:,1:end)', ...
                    FinalAtlasYsub2(:,1:end)','method','regression', ...
                    'Options', options);
replica_rf{2} = nssub2;

disp('Training for full resolution');
min_leaf_size = ps.MinLeafSize;
ns = TreeBagger(ps.nTrees, FinalAtlasPatches(:,1:end)', ...
                FinalAtlasY(:,1:end)','method','regression', ...
                'MinLeafSize', min_leaf_size, 'Options', options);
replica_rf{3} = ns;

end