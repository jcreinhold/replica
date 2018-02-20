---------------------------------------------------------------------------
REPLICA: An MRI image synthesis algorithm
---------------------------------------------------------------------------

The files included implement the algorithm described in [1].
 
This code has been tested on MATLAB 2015 and 2016 versions.
Some of the parallelzing code has changed from 2014 onwards
so those lines need to be edited for backward compatibility.

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
REPLICA_v02
|
|---src (source code)
|   |   
|   |---io (holds code to read in and output NifTI files)
|   |   
|   |---predict (functions for aligning speech parameters)
|   |   |   replica_predict (apply the trained random forest and synthesize images)
|   |
|   |---train (functions for automatically aligning and synthesizing speech)
|   |   |   replica_train (extract features and train the random forest for REPLICA)
|   |
|   |---utilities (miscellaneous functions used in processing)
|   |   |   extract_context_patch (extract a context descriptor, see [1])
|   |   |   wm_peak_normalize_T1w (scale T1w images by fixing the WM hist peak to 1000)
|   |   |   wm_peak_normalize_T2w (scale T2w images by fixing the WM hist peak to 1000)
|   |   |   peakdet (detect local minima and maxima in a vector)
|
|---tests (unit tests, demos)
|   | replica_demo (example REPLICA training and synthesis, 
|   |               a. T2w images from T1w images, and 
|   |               b. FLAIR images from T1w, T2w, and PDw images)
|
|---docs (documentation)