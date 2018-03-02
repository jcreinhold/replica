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
    if param_struct.synthT2 == 1
        [test_patches, dim, fg] = t2_predict_patches(subject_struct, ...
                                                     param_struct);
    elseif param_struct.synthFLAIR == 1
        [test_patches, dim, fg] = flair_predict_patches(subject_struct, ...
                                                        param_struct);
    else
        error(['param_struct.synthFLAIR or param_struct.synthT2', ...
               'needs to be set to 1']);
    end
    
    % predict the values of the synthesized image
    test_Y = predict(replica_rf, test_patches(:, :)');
    
    % Save the generated image
    synth = save_synth(test_Y, param_struct, dim, fg);
end