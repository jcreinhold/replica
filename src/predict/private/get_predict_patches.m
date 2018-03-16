function [test_patches, fg] = get_predict_patches(subject_images, ps)
%GET_PREDICT_PATCHES 
%
%   Args:
%       subject_images: cell array of all subject contrasts
%       ps: Has the parameter set with which REPLICA was trained
%
%   Output:
%       test_patches: patches to do regression on
%       fg: foreground indices, for saving synthesized image

    subject_t1w = subject_images{1};  % T1w-image will always be first element
    
    patch_size = ps.patch_size;
    L = patch_size(1) * patch_size(2) * patch_size(3);
    
    patch_size_multiplier = length(subject_images);
    
    [I, J, K, orig, n, fg] = get_predict_params(subject_t1w, ps);

    if ps.use_context_patch == 0
        test_patches = zeros(patch_size_multiplier*L, n);     
    elseif ps.use_context_patch == 1
        test_patches = zeros(patch_size_multiplier*L+32, n);
    else
        error('param_struct.use_context_patch needs to be 0 or 1');
    end
    
    parfor viter = 1:n
        i = I(viter);
        j = J(viter);
        k = K(viter);
        patches = get_patch(subject_images, i, j, k, orig, L, ps);
        test_patches(:, viter) = patches;
    end
end

