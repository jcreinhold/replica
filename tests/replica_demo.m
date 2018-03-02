%% Example use case of REPLICA

%% Set training parameters

% set parameters for training the random forest
param_struct.patch_size = [3,3,3];

% number of samples to be used for training
param_struct.no_of_training_samples = 1E5;

% 1 if task is to synthesize T2w images from T1w images
param_struct.synthT2 = 1;

% 1 if task is to synthesize FLAIR images from T1w, T2w, PDw
param_struct.synthFLAIR = 0;

% if you want to use a context patch in the feature set in addition
% to the local patch
param_struct.use_context_patch = 1;

% threshold for intensities in target (no negative intensities in foreground)
param_struct.threshold = 0;

% set the context patch parameters
param_struct.r1 = 4;
param_struct.r2 = 8;
param_struct.r3 = 16;
param_struct.r4 = 32;

param_struct.w1 = [3, 3, 3];
param_struct.w2 = [5, 5, 5];
param_struct.w3 = [7, 7, 7];
param_struct.w4 = [9, 9, 9];

% number of trees
param_struct.nTrees = 30;

% MinLeafSize for each tree
param_struct.MinLeafSize = 5;

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
    
    % fix the target
    atlas_struct.target{iter} = atlas_flair_file;
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