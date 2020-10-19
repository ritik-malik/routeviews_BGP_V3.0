#!/bin/bash

##################### NOTE #########################
# if you are running this script directly, Syntax ->
# ./add_index.sh 201912 0600 1000 1600 2000
####################################################

YYMM=$1
TIME_1=$2
TIME_2=$3
TIME_3=$4
TIME_4=$5

wait_buffer=()
YYYYMM=${YYMM}01

for i in {1..30}
do
    for TIME in {"${TIME_1}","${TIME_2}","${TIME_3}","${TIME_4}"}
    do

        mongo --quiet --eval "db.getCollection('${TIME}').createIndex({PREFIX:1});" ${YYYYMM} &
        wait_buffer+=($!)
        echo "Making index for ${YYYYMM}.${TIME}" >> logs.txt

    done
    ((YYYYMM++))
done

for PID in "${wait_buffer[@]}"; do wait ${PID}; done
wait_buffer=()

echo "Done!" >> logs.txt

##########################################################

echo -e "\nCOMPLETED PHASE 2 successfully!\nSending an email" >> logs.txt
python3 mail.py "COMPLETED PHASE 2 successfully!\
Indexing has been done for mongoDB!"

##########################################################
