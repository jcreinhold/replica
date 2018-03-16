%% Example use case of REPLICA multiresolution 

%% Set training parameters

param_struct = default_param_struct_multires();

%% Create atlas from example data

% populate the atlas struct
training_dir = '../REPLICA_release_v01/data/';

% use data from 2 subjects for training
training_subjects_list = {'01', '02'};

for iter = 1:length(training_subjects_list)
    atlas_dir = [training_dir, 'training',  training_subjects_list{iter}, '/'];
    output_dir = [atlas_dir, 'training', training_subjects_list{iter}];
    atlas_t1w_file = [output_dir, '_01_mprage_pp.nii'];
    atlas_flair_file = [output_dir, '_01_flair_pp.nii'];
    
    atlas_struct.source{iter} = atlas_t1w_file;
    atlas_struct.target{iter} = atlas_flair_file;
end

%% Train the random forest

replica_rfs = replica_train_multires(atlas_struct, param_struct);
save('replica_rfs.mat', 'replica_rfs', 'training_dir', 'param_struct');

%% Synthesize subject data using the trained random forest

% specify the subject data
test_subjects_list = {'03'};%, '04', '05'};
test_dir = training_dir; % same as training dir in this case.

for iter = 1:length(test_subjects_list)
    subject_dir = [test_dir, 'training', test_subjects_list{iter}, '/'];
    output_dir = [subject_dir, 'synth/'];
    mkdir(subject_dir, 'synth')
    sub_dir = [subject_dir, 'training', test_subjects_list{iter}];
    out_dir = [output_dir, 'training', test_subjects_list{iter}];
    
    subject_t1w_file = [sub_dir, '_01_mprage_pp.nii'];
    
    subject_struct.source = subject_t1w_file;

    subject_struct.output_filename = [out_dir, '_01_synthflair_pp_multires.nii'];
    
    subject_synth_trg = replica_predict_multires(subject_struct, param_struct, replica_rfs);
end