%% Example use case of REPLICA multiresolution 

%% Set training parameters

param_struct = default_param_struct();
param_struct.target = 'flair';

%% Create atlas from example data

% populate the atlas struct
atlas_struct.t1w{1} = 'tests/test_data/test.nii';
atlas_struct.flair{1} = 'tests/test_data/test.nii';

%% Train the random forest

replica_rfs = replica_train(atlas_struct, param_struct);

%% Synthesize subject data using the trained random forest

subject_struct.t1w = 'tests/test_data/test.nii';
subject_struct.output_filename = 'tests/test_data/test_out.nii';
replica_predict(subject_struct, param_struct, replica_rfs);

%% Clean up result from test
delete(subject_struct.output_filename)