#!/bin/bash

### CHANGE THE SYNTAX IN NEW UPDATE, TAKE ONLY FOLDER NAME`# DONE

################################# NOTE #####################################

# if you are running this file directly, Syntax ->
# ./mongo_CSV.sh YYYYMM T1 T2 T3 T4 LIMIT ISP_ASN

# old method ->
# ./mongo_CSV.sh ISP_ASN1 ISP_ASN2 ISP_ASN3... X 201912 0600 1000 1600 2000 Y 
# where X, Y are some arbitary value

############################# GLOBAL VARS ##################################

FILES=("$@")

YYMM=${FILES[-7]}                 # YY & MM for folder names (greater than 10)
TIME_1=${FILES[-6]}                 # timestamp 1
TIME_2=${FILES[-5]}                 # timestamp 2
TIME_3=${FILES[-4]}                 # timestamp 3
TIME_4=${FILES[-3]}                 # timestamp 4
LIMIT=${FILES[-2]}		    # limit for graphs
ISP_ASN=${FILES[-1]}                # folder name for ISP_ASN

# old method, not needed now ->
# for i in {1..7}; do unset FILES[-1]; done   # now array only has file names

#############################################################################

echo "Making CSV files now..." >> logs.txt
YYYYMM=${YYMM}01

for F in $(ls ${ISP_ASN})
# for F in ${FILES[@]}  # old
do

  (ASN=$(echo $F | cut -d "_" -f 2)

  for prefix in $(cat ${ISP_ASN}/${F})
  # for prefix in $(cat ${F})   # old
  do
    for i in {1..30}
    do
        for TIME in {"${TIME_1}","${TIME_2}","${TIME_3}","${TIME_4}"}
        do
            echo -n "${YYYYMM},${TIME},${ASN},${prefix}," >> ${F}_database.csv
            mongo --quiet --eval "db.getCollection('${TIME}').find({ PREFIX: '${prefix}' }).count();" ${YYYYMM} >> ${F}_database.csv
        done
        ((YYYYMM++))
    done
    echo "0,0,0,0,0" >> ${F}_database.csv
    echo "Done for ${prefix}"
    YYYYMM=${YYMM}01          # reset the date here for next rpefix
  done) &
  wait_buffer+=($!)
  echo "Making CSV for ${F}" >> logs.txt

done

for PID in "${wait_buffer[@]}"; do wait ${PID}; done
wait_buffer=()

echo "Inserting CSV headers..." >> logs.txt


for F in $(ls | grep _database.csv); do sed  -i '1i DATE,TIME,ASN,PREFIX,FREQ' ${F}; done
# old method
# for F in ${FILES[@]}; do sed  -i '1i DATE,TIME,ASN,PREFIX,FREQ' ${F}_database.csv; done   # add CSV header

echo "DONE!" >> logs.txt

##########################################################

echo -e "\nCOMPLETED PHASE 3 successfully!\nSending an email" >> logs.txt
python3 mail.py "COMPLETED PHASE 3 successfully!\
All CSV files have been made!"

##########################################################

