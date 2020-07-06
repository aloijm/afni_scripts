#!/bin/tcsh

set rootdir=/Volumes/alojos/Novelty_GLMs/DATA
set subdirs="1291	1292	1293	1294-2	1295	1296	1297 	2735	2813	2814	2820	2821	2822	2823-2O	2831-2O	2876	2888	2905	2950	2725-2O"
set orig="+orig."
set sep="_"

foreach i ($subdirs)
	#do loop once for BRIK files and once for HEAD files
	foreach ext (BRIK HEAD)	
		#reset number to 0
		set number=0
		
		cd "$rootdir"/"$i"_Omn_V2/BO*
		pwd
		
		set paradigm=OBJ
		cd "$rootdir"/"$i"_Omn_V2/BO*
		foreach folder (OBJ*)
			cd "$rootdir"/"$i"_Omn_V2/BO*/"$folder"
			pwd
			foreach file (Out*.$ext)
				#for each file, add one to number, this will then be put in front of Out*.*
				@ number++
				mv $file ../../"$number$sep$paradigm$orig$ext"	
			end
		
		end

	end

end










