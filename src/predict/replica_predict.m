function subject_synthtrg = replica_predict(subject_struct, param_struct, replica_rfs)
%REPLICA_PREDICT takes in the trained REPLICA random forests and predicts 
%   the synthetic image for an input subject image set.
%
%   Args:
%       subject_struct: Has filenames for input subject images
%       params_struct: Has the parameter set with which REPLICA was trained
%       replica_rfs: A cell array that has the trained REPLICA random forests
%
%   Output:
%       subject_synthtrg: predicted synthetic subject image

r1 = param_struct.r1;
r2 = param_struct.r2;
r3 = param_struct.r3;
r4 = param_struct.r4;

w1 = param_struct.w1;
w2 = param_struct.w2;
w3 = param_struct.w3;
w4 = param_struct.w4;

% p = gcp('nocreate'); % If no pool, do not create new one.
% if isempty(p)
%     poolsize = 0;
% else
%     poolsize = 8
% end

N = param_struct.patch_size;

if param_struct.synthT2 == 1
    tmp_subject_src = load_untouch_nii(subject_struct.t1w);
    subject_t1w = double(tmp_subject_src.img);
    median_t1w = median(subject_t1w(:));
    threshold_t1w = 0.001 * median_t1w;
    subject_t1w = wm_peak_normalize_T2w(subject_t1w, threshold_t1w);
    
    dim_orig = size(subject_t1w);
    
    subject_t1w = padarray(subject_t1w, 4*[w4(1) + r4, w4(2) + r4, w4(3) + r4]);
    dim0 = size(subject_t1w);
    dim0rem = 1 - (dim0 / 2 - floor(dim0/2));
    orig_1 = floor(size(subject_t1w)/2);
    
    patch_size = param_struct.patch_size;
    L = patch_size(1) * patch_size(2) * patch_size(3);
    
    fg_idxs = find(subject_t1w > 0);
    
    [I1, J1, K1] = ind2sub(size(subject_t1w), fg_idxs);
    
    if param_struct.use_context_patch == 0
        TestPatches = zeros(L, length(fg_idxs));
        
        parfor viter = 1:length(fg_idxs)
            i = I1(viter);
            j = J1(viter);
            k = K1(viter);
            ii = i-((N(1) - 1) / 2):i+((N(1) - 1) / 2);
            jj = j-((N(2) - 1) / 2):j+((N(2) - 1) / 2);
            kk = k-((N(3) - 1) / 2):k+((N(3) - 1) / 2);
            x1 = reshape(subject_t1w(ii, jj, kk), [L, 1]);
            x = [x1];
            TestPatches(:, viter) = x;
        end
    elseif param_struct.use_context_patch == 1
        TestPatches = zeros(L+32, length(fg_idxs));
        
        parfor viter = 1:length(fg_idxs)
            i = I1(viter);
            j = J1(viter);
            k = K1(viter);
            ii = i-((N(1) - 1) / 2):i+((N(1) - 1) / 2);
            jj = j-((N(2) - 1) / 2):j+((N(2) - 1) / 2);
            kk = k-((N(3) - 1) / 2):k+((N(3) - 1) / 2);
            x1 = reshape(subject_t1w(ii, jj, kk), [L, 1]);
            z = extract_context_patch(subject_t1w, i, j, k, ...
                                      r1, r2, r3, r4, ...
                                      w1, w2, w3, w4, orig_1);
            x = [x1; z];
            TestPatches(:, viter) = x;
            
        end
    end
    ns = replica_rfs{1};
    
    testY = predict(ns, TestPatches(:, :)');
    
    % Save the generated image
    subject_synthtrg = zeros(size(subject_t1w));
    subject_synthtrg(fg_idxs) = testY;
    dimcurr = size(subject_synthtrg);
    dimcurr_rem = (dimcurr / 2 - floor(dimcurr/2));
    delta = dimcurr_rem - dim0rem;
    
    subject_synthtrg = subject_synthtrg(4*(w4(1) + r4)+1:4*(w4(1) + r4)+dim_orig(1), ...
                                        4*(w4(2) + r4)+1:4*(w4(2) + r4)+dim_orig(2), ...
                                        4*(w4(3) + r4)+1:4*(w4(3) + r4)+dim_orig(3));
    
    tmp_subject_src.img = subject_synthtrg;
    output_filename = subject_struct.output_filename;
    tmp_subject_src.fileprefix = output_filename;
    save_untouch_nii(tmp_subject_src, output_filename);
    
    
elseif param_struct.synthFLAIR == 1
    tmp_subject_src = load_untouch_nii(subject_struct.t1w);
    subject_t1w = double(tmp_subject_src.img);
    median_t1w = median(subject_t1w(:));
    threshold_t1w = 0.001 * median_t1w;
    subject_t1w = wm_peak_normalize_T2w(subject_t1w, threshold_t1w);
    dim_orig = size(subject_t1w);
    
    tmp_subject_t2 = load_untouch_nii(subject_struct.t2w);
    subject_t2w = double(tmp_subject_t2.img);
    median_t2w = median(subject_t2w(:));
    threshold_t2w = 0.001 * median_t2w;
    subject_t2w = wm_peak_normalize_T2w(subject_t2w, threshold_t2w);
    
    tmp_subject_pdw = load_untouch_nii(subject_struct.pdw);
    subject_pdw = double(tmp_subject_pdw.img);
    median_pdw = median(subject_pdw(:));
    threshold_pdw = 0.001 * median_pdw;
    subject_pdw = wm_peak_normalize_T2w(subject_pdw, threshold_pdw);
    
    subject_t1w = padarray(subject_t1w, 4*[w4(1) + r4, w4(2) + r4, w4(3) + r4]);
    subject_t2w = padarray(subject_t2w, 4*[w4(1) + r4, w4(2) + r4, w4(3) + r4]);
    subject_pdw = padarray(subject_pdw, 4*[w4(1) + r4, w4(2) + r4, w4(3) + r4]);
    
    dim0 = size(subject_t1w);
    dim0rem = 1 - (dim0 / 2 - floor(dim0/2));
    orig_1 = floor(size(subject_t1w)/2);
    
    patch_size = param_struct.patch_size;
    L = patch_size(1) * patch_size(2) * patch_size(3);
    
    fg_idxs = find(subject_t1w > 0);
    
    [I1, J1, K1] = ind2sub(size(subject_t1w), fg_idxs);
    if param_struct.use_context_patch == 0
        TestPatches = zeros(3*L, length(fg_idxs));
        
        parfor viter = 1:length(fg_idxs)
            i = I1(viter);
            j = J1(viter);
            k = K1(viter);
            ii = i-((N(1) - 1) / 2):i+((N(1) - 1) / 2);
            jj = j-((N(2) - 1) / 2):j+((N(2) - 1) / 2);
            kk = k-((N(3) - 1) / 2):k+((N(3) - 1) / 2);
            x1 = reshape(subject_t1w(ii, jj, kk), [L, 1]);
            x2 = reshape(subject_t2w(ii, jj, kk), [L, 1]);
            x3 = reshape(subject_pdw(ii, jj, kk), [L, 1]);
            x = [x1; x2; x3];
            TestPatches(:, viter) = x;
        end
        
    elseif param_struct.use_context_patch == 1
        TestPatches = zeros(3*L+32, length(fg_idxs));
        
        parfor viter = 1:length(fg_idxs)
            i = I1(viter);
            j = J1(viter);
            k = K1(viter);
            ii = i-((N(1) - 1) / 2):i+((N(1) - 1) / 2);
            jj = j-((N(2) - 1) / 2):j+((N(2) - 1) / 2);
            kk = k-((N(3) - 1) / 2):k+((N(3) - 1) / 2);
            x1 = reshape(subject_t1w(ii, jj, kk), [L, 1]);
            x2 = reshape(subject_t2w(ii, jj, kk), [L, 1]);
            x3 = reshape(subject_pdw(ii, jj, kk), [L, 1]);
            z = extract_context_patch(subject_t1w, i, j, k, ...
                                      r1, r2, r3, r4, ... 
                                      w1, w2, w3, w4, orig_1);
            x = [x1; x2; x3; z];
            TestPatches(:, viter) = x;
            
        end
    end
    
    ns = replica_rfs{1};
    testY = predict(ns, TestPatches(:, :)');
    
    % Save the generated image
    subject_synthtrg = zeros(size(subject_t1w));
    subject_synthtrg(fg_idxs) = testY;
    dimcurr = size(subject_synthtrg);
    dimcurr_rem = (dimcurr / 2 - floor(dimcurr/2));
    delta = dimcurr_rem - dim0rem;
    
    subject_synthtrg = subject_synthtrg(4*(w4(1) + r4)+1:4*(w4(1) + r4)+dim_orig(1), ...
                                        4*(w4(2) + r4)+1:4*(w4(2) + r4)+dim_orig(2), ...
                                        4*(w4(3) + r4)+1:4*(w4(3) + r4)+dim_orig(3));
    
    tmp_subject_src.img = subject_synthtrg;
    output_filename = subject_struct.output_filename;
    tmp_subject_src.fileprefix = output_filename;
    save_untouch_nii(tmp_subject_src, output_filename);
    
end