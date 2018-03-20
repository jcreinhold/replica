---------------------------------------------------------------------------
REPLICA: An MRI image synthesis algorithm
---------------------------------------------------------------------------

The files included implement the algorithm described in [1]. Given a set of
training images of different contrasts (an atlas), train a random forest 
regressor to output values of a target contrast. Can use single resolution
or multiresolution features 
(although the inputs to either pathway are different!)
 
This code has been tested on MATLAB 2017b.

Code Author: Amod Jog (v1)
             Jacob Reinhold (v2) (jacob.reinhold@jhu.edu)

---------------------------------------------------------------------------
References
---------------------------------------------------------------------------

[1] A. Jog, et al., ``Random forest regression for magnetic resonance
    image synthesis'', Medical Image Analysis, 35:475-488, 2017.

---------------------------------------------------------------------------
Project Structure
---------------------------------------------------------------------------
replica
|
|---src (source code)
|   |   
|   |---io (holds code to read in and output files)
|   |   |   nii (external module to handle NifTI files)
|   |   |   open_atlas (open nifti image and preprocess it)
|   |   |   open_lesionmask (open lesionmask and preprocess it)
|   |   |   save_synth (save/output synthesized image)
|   |   
|   |---predict (functions for aligning speech parameters)
|   |   |   replica_predict (apply the trained random forest and synthesize images)
|   |   |   replica_predict_multires (same, but w/ multires features)
|   |
|   |---train (functions for automatically aligning and synthesizing speech)
|   |   |   replica_train (extract features and train the random forest for REPLICA)
|   |   |   replica_train_multires (same, but w/ multires features)
|   |
|   |---utilities (miscellaneous functions used in processing)
|   |   |   extract_context_patch (extract a context descriptor, see [1])
|   |   |   wm_peak_normalize_T1w (scale T1w images by fixing the WM hist peak to 1000)
|   |   |       [not sure if this is actually for T1w, or just an old version]
|   |   |   wm_peak_normalize_T2w (scale T2w images by fixing the WM hist peak to 1000)
|   |   |   peakdet (detect local minima and maxima in a vector)
|   |   |   patch_indices (get indices that comprise a patch)
|   |   |   pad (pads the input image according to some specification)
|   |   |   wm_ref_normalize (routine [not used] for normalizing an image to a reference)
|   |   |   wm_peak_normalize_fcm (routine [not used] for normalizing wm peak w/ FCM)
|   |   |---multires (routines specific to multiresolution pipeline)
|   |   |---singleres (routines specific to single resolution pipeline)
|
|---tests (unit tests, demos)
|   | replica_demo (example single resolution REPLICA training and synthesis)
|   | replica_demo_multires (same, but multires)
|
|---docs (documentation)