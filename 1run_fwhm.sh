export subID="1106 1107 1109 1110 1111"

for i in $subID
do
3dFWHMx -acf -mask GreyMatterMask+tlrc -input "$i"_errts.PA3+tlrc.BRIK >> FWHMcoordinates_GMMask.txt
done