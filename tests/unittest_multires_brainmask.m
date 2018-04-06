%% Example use case of REPLICA multiresolution 

%% Set training parameters

param_struct = default_param_struct_multires();

%% Create atlas from example data

% populate the atlas struct
atlas_struct.source{1} = 'tests/test_data/test.nii';
atlas_struct.target{1} = 'tests/test_data/test.nii';
atlas_struct.brainmasks{1} = 'tests/test_data/mask.nii';

%% Train the random forest

replica_rfs = replica_train_multires(atlas_struct, param_struct);
% replica_rfs_lm = replica_train_multires_low_memory(atlas_struct, param_struct);

%% Synthesize subject data using the trained random forest

subject_struct.source = 'tests/test_data/test.nii';
subject_struct.brainmask = 'tests/test_data/mask.nii';
out = 'tests/test_data/test_out_bm.nii';
subject_struct.output_filename = out;
replica_predict_multires(subject_struct, param_struct, replica_rfs);
% out_lm = 'tests/test_data/test_out_lm_bm.nii';
% subject_struct.output_filename = out_lm;
% replica_predict_multires_low_memory(subject_struct, param_struct, replica_rfs_lm);

%% Clean up result from test
% delete(out)
% delete(out_lm)