function synth = replica_predict(subject_struct, param_struct, replica_rf)
%REPLICA_PREDICT takes in the trained REPLICA random forests and predicts 
%   the synthetic image for an input subject image set.
%
%   Args:
%       subject_struct: Has filenames for input subject images
%       params_struct: Has the parameter set with which REPLICA was trained
%       replica_rfs: trained REPLICA random forest
%
%   Output:
%       synth: predicted synthetic subject image

    % extract the patches on which to do regression
    fprintf('getting patches for subject\n');
    [test_patches, dim, fg] = predict_patches(subject_struct, param_struct);
    
    % predict the values of the synthesized image
    fprintf('synthesizing %s image\n', param_struct.target);
    test_Y = predict(replica_rf, test_patches(:, :)');
    
    % Save the generated image
    synth = save_synth(test_Y, subject_struct, ...
                       param_struct.w4, param_struct.r4, ...
                       dim, fg);
end