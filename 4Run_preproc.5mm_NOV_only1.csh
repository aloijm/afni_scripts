#!/bin/tcsh

set rootdir=/Volumes/AS_Passport/Novelty/DATA
set subdirs=(2610	2627	2639	2653	2654	2727)
set subj="Preproc_Omn_V2"
set anat_series="anat+orig"
set epi_datasets="*_*_cat+orig.HEAD"
set motion_limit="0.5" # also set below
set Run3_TR=(266	262	267	274	265	267) ############DONT FORGET TO CHANGE THESE
set Run4_TR=(263	264	266	273	260	259) ###########DONT FORGET TO CHANGE THESE
set loop=0	

set Run3_cat=0
set Run4_cat=0

foreach i ($subdirs)
	@ loop++
	cd "$rootdir"/"$i"_Omn_V2
	pwd
	

	#TR index starts at 0
	@ Run3_cat=$Run3_TR[$loop] - 1
	@ Run4_cat=$Run4_TR[$loop] - 1

	echo truncated TRs for subject $subdirs[$loop] is $Run3_TR[$loop] $Run4_TR[$loop] > trunc.txt
	
	3dTcat 1_OBJ+orig"[0..${Run3_cat}]" -prefix 1_OBJ_cat+orig
	3dTcat 2_OBJ+orig"[0..${Run4_cat}]" -prefix 2_OBJ_cat+orig
	

	afni_proc.py -dsets $epi_datasets	\
		-subj_id $subj			\
		-copy_anat $anat_series		\
		-blocks despike tshift align tlrc volreg blur mask scale	\
		-align_opts_aea -cost lpc+ZZ -giant_move		\
		-volreg_base_dset '1_OBJ_cat+orig[0]'	\
		-volreg_tlrc_warp		\
		-volreg_warp_dxyz 3.0		\
		-blur_size 6

		tcsh -xef proc.Preproc_Omn_V2 | tee output.proc.Preproc_Omn_V2

		cd "$rootdir"/"$i"_Omn_V2/Preproc_Omn_V2.results

		echo truncated TRs for subject $subdirs[$loop] is $Run3_cat $Run4_cat
		
		cat dfile.r01.1D dfile.r02.1D > dfile_PIC.1D

		cat outcount.r01.1D outcount.r02.1D > outcount_PIC.1D

		echo Calculating motion for the Pictures task
		# compute de-meaned motion parameters (for use in regression)
		1d_tool.py -infile dfile_PIC.1D -set_run_lengths $Run3_TR[$loop] $Run4_TR[$loop] \
           -demean -write motion_demean_PIC.1D -overwrite 

		# compute motion parameter derivatives (just to have)
		1d_tool.py -infile dfile_PIC.1D -set_run_lengths $Run3_TR[$loop] $Run4_TR[$loop] \
        	-derivative -demean -write motion_deriv_PIC.1D -overwrite 

		# create censor file motion_Preproc_PSS_censor.1D, for censoring motion 
		1d_tool.py -infile dfile_PIC.1D -set_run_lengths $Run3_TR[$loop] $Run4_TR[$loop] \
   			-show_censor_count -censor_prev_TR \
    		-censor_motion 0.5 motion_Preproc.5_PIC \
    		-overwrite

	

end

