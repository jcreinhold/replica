%% Example use case of REPLICA multiresolution 

%% Set training parameters

param_struct = default_param_struct_multires();
param_struct.wm_peak_normalize = false;
param_struct.fcmeans = false;

%% Create atlas from example data

% populate the atlas struct
atlas_struct.source{1} = 'tests/test_data/test.nii';
atlas_struct.target{1} = 'tests/test_data/test.nii';
atlas_struct.brainmasks{1} = '';

%% Train the random forest

[replica_rfs, dim] = replica_train_multires(atlas_struct, param_struct);

%% Synthesize subject data using the trained random forest

subject_struct.source = 'tests/test_data/test_small.nii';
subject_struct.brainmask = '';
out = 'tests/test_data/test_out_small.nii';
subject_struct.output_filename = out;
replica_predict_multires(subject_struct, param_struct, replica_rfs, 'train_dim', dim);

%% Clean up result from test
%delete(out)