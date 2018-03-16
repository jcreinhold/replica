function synth = replica_predict_multires(subject_struct, param_struct, replica_rfs)
%REPLICA_prediction: This function takes in the trained REPLICA random forests and predicts the synthetic image for an input subject image set.
%   subject_struct: Has filenames for input subject images
%   params_struct: Has the parameter set with which REPLICA was trained
%   replica_rfs: A cell array that has the trained REPLICA random forests
%   for each scale (starting from coarsest in 1 to finest in 3)

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

% open the source and target images
[subject_src, dim] = open_atlas_multires(subject_struct.source, ps.w4{1}, ps.r4{1});

disp('Get multiresolution resolution images');
% resample image - high, intermediate, and low resolution
[subject_src, subject_src_sub2, subject_src_sub4, g1, g2, ~] = multiresolution(subject_src, H);

% extract patches from the lowest resolution test data
disp('Get patches for lowest resolution image');
[I, J, K, orig, n, fg] = get_params_multires(subject_src_sub4, ps);

TestPatchessub4 = zeros(Lsub4+32,n);

for viter=1:n
    i = I(viter);
    j = J(viter);
    k = K(viter);
    
    [ii, jj, kk] = patch_indices(i, j, k, Nsub4);
    x = reshape(subject_src_sub4(ii,jj,kk), [Lsub4 1]);
    z3 = extract_context_patch(subject_src_sub4, i, j, k, ...
                               r1_4, r2_4, r3_4, r3_4, ...
                               w1_4, w2_4, w3_4, w4_4, orig);
    
    x = [x;z3];
    TestPatchessub4(:,viter) = x;
end

% run the random forest to predict the values from the patches
disp('Predict lowest resolution image');
nssub4 = replica_rfs{1};
testY_sub4 = predict(nssub4, TestPatchessub4(:,:)');

% fill in the lowest res image with predicted values
subject_synthtrg_sub2 = zeros(size(subject_src_sub4));
subject_synthtrg_sub2(fg) = testY_sub4;

% get patches for the intermediate resolution images (by upsampling?)
disp('Get patches for intermediate resolution image');

res_subject_synthtrg_sub4 = interp3(subject_synthtrg_sub2, 1);
res_subject_synthtrg_sub4 = interp3(res_subject_synthtrg_sub4, g2{1}, g2{2}, g2{3});

[I, J, K, orig, n, fg] = get_params_multires(subject_src_sub2, ps);

TestPatchessub2 = zeros(Lsub2+L2sub2+32,n);

for viter=1:n
    i = I(viter);
    j = J(viter);
    k = K(viter);
    
    [ii, jj, kk] = patch_indices(i, j, k, Nsub2);
    [ii2, jj2, kk2] = patch_indices(i, j, k, N2sub2);
    x = reshape(subject_src_sub2(ii, jj, kk), [Lsub2, 1]);
    z1 = reshape(res_subject_synthtrg_sub4(ii2, jj2, kk2), [L2sub2, 1]);
    z3 = extract_context_patch(atlas_src_sub2, i, j, k, ...
                               r1_2, r2_2, r3_2, r4_2, ...
                               w1_2, w2_2, w3_2, w4_2, orig);
                         
    x = [x;z3;z1];
    TestPatchessub2(:,viter) = x;
end

% run the random forest to predict the values from the patches
disp('Predict intermediate resolution image');
nssub2 = replica_rfs{2};
testY_sub2 = predict(nssub2,TestPatchessub2(:,:)');

% fill in the intermediate res image with predicted values
subject_synthtrg_sub2 = zeros(size(subject_src_sub2));
subject_synthtrg_sub2(fg) = testY_sub2;

% get patches for the highest resolution images (by upsampling?)
disp('Get patches for highest resolution image');

res_subject_synthtrg_sub2 = interp3(subject_synthtrg_sub2, 1);
res_subject_synthtrg_sub2 = interp3(res_subject_synthtrg_sub2, g1{1}, g1{2}, g1{3});

[I, J, K, orig, n, fg] = get_params_multires(subject_src_sub2, ps);

TestPatches = zeros(L+L2+32,n);

for viter=1:n
    i = I(viter);
    j = J(viter);
    k = K(viter);
    
    [ii, jj, kk] = patch_indices(i, j, k, N);
    [ii2, jj2, kk2] = patch_indices(i, j, k, N2);
    x = reshape(subject_src(ii, jj, kk), [L, 1]);
    z1 = reshape(res_subject_synthtrg_sub2(ii2, jj2, kk2), [L2, 1]);
    z3 = extract_context_patch(atlas_src, i, j, k, ...
                               r1_1, r2_1, r3_1, r4_1, ...
                               w1_1, w2_1, w3_1, w4_1, orig);
    x = [x;z3;z1];
    TestPatches(:,viter) = x;
    
end

disp('Predict highest resolution image');
ns = replica_rfs{3};
testY = predict(ns,TestPatches(:,:)');

% Save the synthesized image
synth = save_synth(testY, subject_struct, ps, dim, fg);
end

