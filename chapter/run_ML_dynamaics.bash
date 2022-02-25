#!/bin/bash

filename=*.dat # mention a filename from test dataset
cp path_to_test_dataset/$filename input.dat; 
sed -i "0~2d" input.dat;  # delete even lines
awk '{print $1}' input.dat > tmp_5.dat; 
k=`sed -n '/4\.000000000000000000e+00/=' input.dat`; # grab line number of the mentioned time-step
k=`echo "$k+1" | bc -l`; 
sed -i "$k, 500d" input.dat; # delete lines 
awk '{print $4}' input.dat > tmp_1.dat # copy the 4th column which is the population difference (expectation value of sigma_z)
awk -F"\n" '$1=$1' RS="" OFS=" " tmp_1.dat > input.dat
xargs -n1 < input.dat > tmp_1.dat; # transpose from rows to col

# predict dynamics for 161 time-steps
# sym_model.unf is the trained model
# input.dat contains the short-time data
# y_est.dat is the predicted value for the next time-step

for i in {1..161..1};
do
	rm y_est.dat;  # need to remove y_est.dat because MLatom does not replace files
	pathToMLatom/MLatom.py useMlmodel MlmodelIn=sym_model.unf XfileIn=input.dat YestFile=y_est.dat debug > output
        xargs -n1 < input.dat > tmp.dat;   # transpose from rows to col
        tail y_est.dat >> tmp.dat;         # copy y_est.dat to the end of tmp.dat
	tail y_est.dat >> tmp_1.dat;       # copy the predicted value to a temporary file
	sed -i 's/ \+//g' tmp.dat;         # remove spaces
        sed -i "1d" tmp.dat;               # delete the 1st line
	awk -F"\n" '$1=$1' RS="" OFS=" " tmp.dat > input.dat; # copy tmp.dat with the transpose from col to rows
	                                                      # this is our new input 
done
sed -i 's/ \+//g' tmp_1.dat;
paste tmp_5.dat tmp_1.dat > tmp_4.dat;
mv tmp_4.dat pred_dynamics.dat  # the predicted dynamics is saved to pred_dynamics.dat
rm tmp.dat tmp_*.dat 
