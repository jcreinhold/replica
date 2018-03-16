function synth = replica_predict_multires(subject_struct, param_struct, replica_rfs)
%REPLICA_prediction: This function takes in the trained REPLICA random forests and predicts the synthetic image for an input subject image set.
%   subject_struct: Has filenames for input subject images
%   params_struct: Has the parameter set with which REPLICA was trained
%   replica_rfs: A cell array that has the trained REPLICA random forests
%   for each scale (starting from coarsest in 1 to finest in 3)

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

[subject, dim] = open_atlas(subject_struct.source, ps, true);
for r=1:3
    fprintf('getting patches for %s resolution\n', resolutions{r});
    [src, g] = multiresolution(subject, H, r);
    if r > 1
        rs_src = interp3(synth, 1);
        rs_src = interp3(rs_src, g{1}, g{2}, g{3});
        [p, fg] = multires_predict_patches(src, ps, r, rs_src);
    else
        [p, fg] = multires_predict_patches(src, ps, r, []);
    end
    fprintf('predict %s resolution image\n', resolutions{r});
    y = predict(replica_rfs{r}, p(:,:)');
    % fill in image with predicted values for next level
    synth = zeros(size(src));
    synth(fg) = y;
end

% Save the synthesized image
synth = save_synth(y, subject_struct, ps.w4{1}, ps.r4{1}, dim, fg);
end

