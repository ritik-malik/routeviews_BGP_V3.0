#!/bin/bash

###################### NOTE ########################

# if you are running this script directly, Syntax ->
# ./make_graphs.sh LIMIT
# where LIMIT is max() - min() freq condition for the graphs to be made

####################################################

LIMIT=$1

echo "Making graphs now..." >> logs.txt

for FILE_NAME in $(ls | grep _database.csv)
do
  python3.7 bokeh_graphs.py ${FILE_NAME} ${LIMIT} &
  wait_buffer+=($!)
  echo "Making graphs from FILE : ${FILE_NAME}" >> logs.txt
done

for PID in "${wait_buffer[@]}"; do wait ${PID}; done
wait_buffer=()

echo "DONE!" >> logs.txt
echo "Now extracting EXTRA graphs..." >> logs.txt

##########################################################

mkdir EXTRA
for i in $(find . -name *EXTRA.html)
do
  mv $i EXTRA
done

##########################################################

echo -e "\nCOMPLETED FINAL PHASE 4 successfully!\nSending final email" >> logs.txt
python3 mail.py "COMPLETED FINAL PHASE 4 successfully!\
  Graphs are ready! Go and check them!"

##########################################################
