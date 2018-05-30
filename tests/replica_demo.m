%% Example use case of REPLICA

%% Set training parameters

param_struct = default_param_struct();
param_struct.target = 'flair';
param_struct.wm_peak_normalize = true;

%% Create atlas from example data

% populate the atlas struct
training_dir = '../REPLICA_release_v01/data/';

% use data from 2 subjects for training
training_subjects_list = {'01', '02'};

for iter = 1:length(training_subjects_list)
    atlas_dir = [training_dir, 'training',  training_subjects_list{iter}, '/'];
    output_dir = [atlas_dir, 'training', training_subjects_list{iter}];
    atlas_t1w_file = [output_dir, '_01_mprage_pp.nii'];
    atlas_t2w_file = [output_dir, '_01_t2_pp.nii'];
    atlas_pdw_file = [output_dir, '_01_pd_pp.nii'];
    atlas_flair_file = [output_dir, '_01_flair_pp.nii'];
    atlas_lesionmask_file = [output_dir, '_01_mask1.nii'];
    
    atlas_struct.t1w{iter} = atlas_t1w_file;
    atlas_struct.t2w{iter} = atlas_t2w_file;
    atlas_struct.pdw{iter} = atlas_pdw_file;
    atlas_struct.flair{iter} = atlas_flair_file;
    atlas_struct.lesionmask{iter} = atlas_lesionmask_file;
end

%% Train the random forest

replica_rfs = replica_train(atlas_struct, param_struct);

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
    subject_t2w_file = [sub_dir, '_01_t2_pp.nii'];
    subject_pdw_file = [sub_dir, '_01_pd_pp.nii'];
    subject_flair_file = [sub_dir, '_01_flair_pp.nii'];
    
    subject_struct.t1w = subject_t1w_file;
    subject_struct.t2w = subject_t2w_file;
    subject_struct.pdw = subject_pdw_file;

    subject_struct.output_filename = [out_dir, '_01_synthflair_pp.nii'];
    
    subject_synth_trg = replica_predict(subject_struct, param_struct, replica_rfs);
end