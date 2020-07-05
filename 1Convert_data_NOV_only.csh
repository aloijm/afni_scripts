#!/bin/tcsh

set rootdir=/Volumes/alojos/Novelty_GLMs/DATA
set subdirs="2725-2O"
#1278	1279	1280	1281	1282	1283 2521T2 2544T2	2550T2 2610 2627	2639
#2578
#1291	1292	1293	1294-2	1295	1296	1297 	2735	2813	2814	2820	2821	2822	2823-2O	2831-2O	2876	2888	2905	2950	

foreach i ($subdirs)
###### general preparation
	cd "$rootdir"/"$i"_Omn_V2/BO*/T1*
	pwd
	Dimon -use_last_elem -infile_prefix '*.IMA' -dicom_org -gert_create_dataset
	mv Out*.BRIK ../../anat+orig.BRIK
	mv Out*.HEAD ../../anat+orig.HEAD
	cd ..

	foreach folder (OBJ*)

		cd "$rootdir"/"$i"_Omn_V2/BO*/"$folder"
		pwd
		Dimon -use_last_elem -infile_prefix '*.IMA' -dicom_org -gert_create_dataset
		cd ..

	end



end
