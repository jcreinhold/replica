function synth = replica_predict_multires_low_memory(subject_struct, param_struct, replica_rfs, varargin)
%REPLICA_PREDICT_MULTIRES takes in the trained REPLICA random forests and 
% predicts the synthetic image for an input subject image set using
% multiresolution features
%
%   Args:
%       subject_struct: Has filenames for input subject images
%       params_struct: Has the parameter set with which REPLICA was trained
%       replica_rfs: cell array of trained REPLICA random forest
%       train_dim: dimension (size) of the training images, test images
%           will be resized to that dimension w/ bicubic interp and AA
%
%   Output:
%       synth: predicted synthetic subject image

    % let the user *not* input train_dim at their own discretion
    p = inputParser;
    p.addParameter('train_dim', [], @isnumeric);
    p.addParameter('seed', 999, @isinteger);
    p.parse(varargin{:})
    params = p.Results;
    
    % set the random seed for reproducability
    rng(params.seed)
    
    % rename for convenience, since this is used all over
    ps = param_struct;

    % initialize some parameters
    n_training_samples = ps.no_of_training_samples;
    n_subject_brains = length(subject_struct.source);
    ps.n_training_samples_per_brain = ...
        round(n_training_samples/n_subject_brains);
    H = fspecial3('gaussian', ps.gaussian_kernel_size);

    % resolutions over which to calculate rfs
    resolutions = {'low', 'intermediate', 'high'};

    % open source image with or w/o brainmask for WM peak normalization
    [subject, dim, dim_orig] = get_img(subject_struct, ps, params.train_dim);

    % given a warning to user when the geometry of the image will change beyond
    % a threshold value
    if sum(abs(diff(unique(dim ./ dim_orig)))) > 1e-3
        warning(['the training image and test images are of different' ...
                 'enough dimensions that the geometry of the test images will' ...
                 'substantially change, continue at your own discretion']);
    end

    % get the multiresolution patches and predict/synthesize image
    for r=1:3
        fprintf('getting patches for %s resolution\n', resolutions{r});
        [src, g] = multiresolution_low_memory(subject, H, r);
        if r > 1
            rs_src = interp3(synth, 1);
            rs_src = interp3(rs_src, g{1}, g{2}, g{3});
            [p, fg] = predict_patches_multires(src, ps, r, rs_src);
        else
            [p, fg] = predict_patches_multires(src, ps, r, []);
        end
        fprintf('predict %s resolution image\n', resolutions{r});
        y = predict(replica_rfs{r}, p(:,:)');
        % fill in image with predicted values for next level
        synth = zeros(size(src));
        synth(fg) = y;
    end
    % Save the synthesized image
    synth = save_synth(synth, subject_struct, ps.w4{3}, ps.r4{3}, dim, fg, dim_orig);
end


function [subject, dim, dim_orig] = get_img(subject_struct, ps, train_dim)
% get the subject image for processing
    [subject, dim, dim_orig] = open_atlas(subject_struct.source, ...
                                ps.w4{3}, ps.r4{3}, ...
                                'isT1', true, ...
                                'BrainMask', subject_struct.brainmask, ...
                                'WMPeakNormalize', ps.wm_peak_normalize, ...
                                'fcmeans', ps.fcmeans, ...
                                'train_img_dim', train_dim);
end