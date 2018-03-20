function synth = replica_predict_multires(subject_struct, param_struct, replica_rfs)
%REPLICA_PREDICT_MULTIRES takes in the trained REPLICA random forests and 
% predicts the synthetic image for an input subject image set using
% multiresolution features
%
%   Args:
%       subject_struct: Has filenames for input subject images
%       params_struct: Has the parameter set with which REPLICA was trained
%       replica_rfs: cell array of trained REPLICA random forest
%
%   Output:
%       synth: predicted synthetic subject image

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

[subject, dim] = open_atlas(subject_struct.source, ps.w4{3}, ps.r4{3}, true);
for r=1:3
    fprintf('getting patches for %s resolution\n', resolutions{r});
    [src, g] = multiresolution(subject, H, r);
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
synth = save_synth(y, subject_struct, ps.w4{3}, ps.r4{3}, dim, fg);
end

