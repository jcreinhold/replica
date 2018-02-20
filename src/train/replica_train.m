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
%       replica_rf: 

% Size of patch in the original highest resolution
patch_size = param_struct.patch_size;
L = patch_size(1) * patch_size(2) * patch_size(3);

no_of_training_samples = param_struct.no_of_training_samples;

r1_1 = param_struct.r1_1;
r2_1 = param_struct.r2_1;
r3_1 = param_struct.r3_1;
r4_1 = param_struct.r4_1;

w1_1 = param_struct.w1_1;
w2_1 = param_struct.w2_1;
w3_1 = param_struct.w3_1;
w4_1 = param_struct.w4_1;

r1_2 = param_struct.r1_2;
r2_2 = param_struct.r2_2;
r3_2 = param_struct.r3_2;
r4_2 = param_struct.r4_2;

w1_2 = param_struct.w1_2;
w2_2 = param_struct.w2_2;
w3_2 = param_struct.w3_2;
w4_2 = param_struct.w4_2;

r1_4 = param_struct.r1_4;
r2_4 = param_struct.r2_4;
r3_4 = param_struct.r3_4;
r4_4 = param_struct.r4_4;

w1_4 = param_struct.w1_4;
w2_4 = param_struct.w2_4;
w3_4 = param_struct.w3_4;
w4_4 = param_struct.w4_4;

p = gcp('nocreate'); % If no pool, do not create new one.
if isempty(p)
    poolsize = 0;
else
    poolsize = 8;
end

% This will hold all the training patches for the highest resolution
FinalAtlasPatches = [];
FinalAtlasY = [];

% load all images
% no of atlas brains

no_of_atlas_brains = length(atlas_struct.t1w);
no_of_training_samples_per_brain = round(no_of_training_samples/no_of_atlas_brains);

for iter = 1:no_of_atlas_brains
    
    % check if synthesizing T2 from T1
    if param_struct.synthT2 == 1
        tmp_atlas_src = load_untouch_nii(atlas_struct.t1w{iter});
        atlas_t1w = double(tmp_atlas_src.img);
        median_t1w = median(atlas_t1w(:));
        threshold_t1w = 0.001 * median_t1w;
        atlas_t1w = wm_peak_normalize_T1w(atlas_t1w, threshold_t1w);
        
        tmp_atlas_t2 = load_untouch_nii(atlas_struct.t2w{iter});
        atlas_t2w = double(tmp_atlas_t2.img);
        median_t2w = median(atlas_t2w(:));
        threshold_t2w = 0.001 * median_t2w;
        atlas_t2w = wm_peak_normalize_T2w(atlas_t2w, threshold_t2w);
        
        atlas_trg = atlas_t2w;
        
        atlas_t1w = padarray(atlas_t1w, 4*[w4_1(1) + r4_1, w4_1(2) + r4_1, w4_1(3) + r4_1]);
        atlas_trg = padarray(atlas_trg, 4*[w4_1(1) + r4_1, w4_1(2) + r4_1, w4_1(3) + r4_1]);
        
        % assumes that the background = 0 and tissue intensities are  > 0
        
        src_fg = atlas_t1w(atlas_t1w > 0);
        
        yq = quantile(src_fg, 100);
        yq = [0, yq];
        no_quantile_voxels = no_of_training_samples_per_brain / 100;
        all_training_idxs = [];
        for qiter = 2:length(yq)
            curr_idxs = find(atlas_t1w > yq(qiter-1) & ...
                             atlas_t1w <= yq(qiter) & ...
                             atlas_trg > param_struct.threshold);
            if isempty(curr_idxs)
                continue;
            end
            indices_idxs = randi(length(curr_idxs), no_quantile_voxels, 1);
            all_training_idxs = [all_training_idxs; curr_idxs(indices_idxs)];
        end
        curr_idxs = find(atlas_t1w > yq(qiter) & ...
                         atlas_t1w <= max(atlas_t1w(:)) & ...
                         atlas_trg > param_struct.threshold);
        indices_idxs = randi(length(curr_idxs), no_quantile_voxels, 1);
        all_training_idxs = [all_training_idxs; curr_idxs(indices_idxs)];
        no_of_training_samples = length(all_training_idxs);
        
        orig_1 = floor(size(atlas_t1w)/2);
        [I1, J1, K1] = ind2sub(size(atlas_t1w), all_training_idxs);
        
        if param_struct.use_context_patch == 0
            AtlasPatches = zeros(L, no_of_training_samples);
            AtlasY = zeros(1, no_of_training_samples);
            length(all_training_idxs)
            
            for viter = 1:length(all_training_idxs)
                i = I1(viter);
                j = J1(viter);
                k = K1(viter);
                ii = i-((patch_size(1) - 1) / 2):i+((patch_size(1) - 1) / 2);
                jj = j-((patch_size(2) - 1) / 2):j+((patch_size(2) - 1) / 2);
                kk = k-((patch_size(3) - 1) / 2):k+((patch_size(3) - 1) / 2);
                x = reshape(atlas_t1w(ii, jj, kk), [L, 1]);
                AtlasPatches(:, viter) = x;
                AtlasY(viter) = atlas_trg(i, j, k);
            end
        elseif param_struct.use_context_patch == 1
            AtlasPatches = zeros(L+32, no_of_training_samples);
            AtlasY = zeros(1, no_of_training_samples);
            length(all_training_idxs)
            
            for viter = 1:length(all_training_idxs)
                i = I1(viter);
                j = J1(viter);
                k = K1(viter);
                ii = i-((patch_size(1) - 1) / 2):i+((patch_size(1) - 1) / 2);
                jj = j-((patch_size(2) - 1) / 2):j+((patch_size(2) - 1) / 2);
                kk = k-((patch_size(3) - 1) / 2):k+((patch_size(3) - 1) / 2);
                x = reshape(atlas_t1w(ii, jj, kk), [L, 1]);
                
                z = extract_context_patch(atlas_t1w, i, j, k, ...
                                          r1_1, r2_1, r3_1, r4_1, ...
                                          w1_1, w2_1, w3_1, w4_1, orig_1);
                x = [x; z];
                AtlasPatches(:, viter) = x;
                AtlasY(viter) = atlas_trg(i, j, k);
            end
        end
        
        FinalAtlasPatches = [FinalAtlasPatches, AtlasPatches];
        size(FinalAtlasPatches)
        FinalAtlasY = [FinalAtlasY, AtlasY];
        
    elseif param_struct.synthFLAIR == 1
        tmp_atlas_src = load_untouch_nii(atlas_struct.t1w{iter});
        atlas_t1w = double(tmp_atlas_src.img);
        median_t1w = median(atlas_t1w(:));
        threshold_t1w = 0.001 * median_t1w;
        atlas_t1w = wm_peak_normalize_T1w(atlas_t1w, threshold_t1w);
        
        tmp_atlas_t2 = load_untouch_nii(atlas_struct.t2w{iter});
        atlas_t2w = double(tmp_atlas_t2.img);
        median_t2w = median(atlas_t2w(:));
        threshold_t2w = 0.001 * median_t2w;
        atlas_t2w = wm_peak_normalize_T2w(atlas_t2w, threshold_t2w);
        
        tmp_atlas_pdw = load_untouch_nii(atlas_struct.pdw{iter});
        atlas_pdw = double(tmp_atlas_pdw.img);
        median_pdw = median(atlas_pdw(:));
        threshold_pdw = 0.001 * median_pdw;
        atlas_pdw = wm_peak_normalize_T2w(atlas_pdw, threshold_pdw);
        
        tmp_atlas_flair = load_untouch_nii(atlas_struct.flair{iter});
        atlas_flair = double(tmp_atlas_flair.img);
        median_flair = median(atlas_flair(:));
        threshold_flair = 0.001 * median_flair;
        atlas_flair = wm_peak_normalize_T2w(atlas_flair, threshold_flair);     
        
        tmp_atlas_lesionmask = load_untouch_nii(atlas_struct.lesionmask{iter});
        atlas_lesionmask = double(tmp_atlas_lesionmask.img);
         
        atlas_trg = atlas_flair;
        
        atlas_t1w = padarray(atlas_t1w, 4*[w4_1(1) + r4_1, w4_1(2) + r4_1, w4_1(3) + r4_1]);
        atlas_t2w = padarray(atlas_t2w, 4*[w4_1(1) + r4_1, w4_1(2) + r4_1, w4_1(3) + r4_1]);
        atlas_pdw = padarray(atlas_pdw, 4*[w4_1(1) + r4_1, w4_1(2) + r4_1, w4_1(3) + r4_1]);
        atlas_lesionmask = padarray(atlas_lesionmask, 4*[w4_1(1) + r4_1, w4_1(2) + r4_1, w4_1(3) + r4_1]);
        
        atlas_trg = padarray(atlas_trg, 4*[w4_1(1) + r4_1, w4_1(2) + r4_1, w4_1(3) + r4_1]);
        
        
        % assumes that the background = 0 and tissue intensities are  > 0
        
        src_fg = atlas_t1w(atlas_t1w > 0);
        
        yq = quantile(src_fg, 100);
        yq = [0, yq];
        no_quantile_voxels = no_of_training_samples_per_brain / 100;
        all_training_idxs = [];
        for qiter = 2:length(yq)
            curr_idxs = find(atlas_t1w > yq(qiter-1) & ...
                             atlas_t1w <= yq(qiter) & ...
                             atlas_trg > param_struct.threshold);
            if isempty(curr_idxs)
                continue;
            end
            indices_idxs = randi(length(curr_idxs), no_quantile_voxels, 1);
            all_training_idxs = [all_training_idxs; curr_idxs(indices_idxs)];
            
        end
        
        curr_idxs = find(atlas_t1w > yq(qiter) & ...
                         atlas_t1w <= max(atlas_t1w(:)) & ...
                         atlas_trg > param_struct.threshold);
        indices_idxs = randi(length(curr_idxs), no_quantile_voxels, 1);
        all_training_idxs = [all_training_idxs; curr_idxs(indices_idxs)];
        
        lesion_idxs = find(atlas_lesionmask == 1);
        all_training_idxs = [all_training_idxs; lesion_idxs];
        
        orig_1 = floor(size(atlas_t1w)/2);
        [I1, J1, K1] = ind2sub(size(atlas_t1w), all_training_idxs);
        
        length(all_training_idxs)
        
        if param_struct.use_context_patch == 0
            AtlasPatches = zeros(3*L, length(all_training_idxs));
            
            for viter = 1:length(all_training_idxs)
                i = I1(viter);
                j = J1(viter);
                k = K1(viter);
                ii = i-((patch_size(1) - 1) / 2):i+((patch_size(1) - 1) / 2);
                jj = j-((patch_size(2) - 1) / 2):j+((patch_size(2) - 1) / 2);
                kk = k-((patch_size(3) - 1) / 2):k+((patch_size(3) - 1) / 2);
                x1 = reshape(atlas_t1w(ii, jj, kk), [L, 1]);
                x2 = reshape(atlas_t2w(ii, jj, kk), [L, 1]);
                x3 = reshape(atlas_pdw(ii, jj, kk), [L, 1]);
                x = [x1; x2; x3];
                AtlasPatches(:, viter) = x;
                AtlasY(viter) = atlas_trg(i, j, k);
            end
            
        elseif param_struct.use_context_patch == 1
            AtlasPatches = zeros(3*L+32, length(all_training_idxs));
            
            for viter = 1:length(all_training_idxs)
                i = I1(viter);
                j = J1(viter);
                k = K1(viter);
                ii = i-((patch_size(1) - 1) / 2):i+((patch_size(1) - 1) / 2);
                jj = j-((patch_size(2) - 1) / 2):j+((patch_size(2) - 1) / 2);
                kk = k-((patch_size(3) - 1) / 2):k+((patch_size(3) - 1) / 2);
                x1 = reshape(atlas_t1w(ii, jj, kk), [L, 1]);
                x2 = reshape(atlas_t2w(ii, jj, kk), [L, 1]);
                x3 = reshape(atlas_pdw(ii, jj, kk), [L, 1]);
                z = extract_context_patch(atlas_t1w, i, j, k, ...
                                          r1_1, r2_1, r3_1, r4_1, ...
                                          w1_1, w2_1, w3_1, w4_1, orig_1);
                x = [x1; x2; x3; z];
                AtlasPatches(:, viter) = x;
                AtlasY(viter) = atlas_trg(i, j, k);
            end
        end
        
        FinalAtlasPatches = [FinalAtlasPatches, AtlasPatches];
        size(FinalAtlasPatches)
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
