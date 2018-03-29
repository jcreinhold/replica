%% Example use case of REPLICA multiresolution 

%% Set training parameters

param_struct = default_param_struct_multires();

%% Create atlas from example data

% populate the atlas struct
atlas_struct.source{1} = 'tests/test_data/test.nii';
atlas_struct.target{1} = 'tests/test_data/test.nii';
atlas_struct.brainmasks{1} = '';

%% Train the random forest

replica_rfs = replica_train_multires(atlas_struct, param_struct);

%% Synthesize subject data using the trained random forest

subject_struct.source = 'tests/test_data/test.nii';
subject_struct.output_filename = 'tests/test_data/test_out.nii';
subject_struct.brainmask = '';
replica_predict_multires(subject_struct, param_struct, replica_rfs);

%% Clean up result from test
delete(subject_struct.output_filename)