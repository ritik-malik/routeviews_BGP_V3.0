#!/bin/bash
#
# Use this script to run "final_graph.py"
# Make sure that the current folder contains all the CSVs to be used
#
# Usage -> ./make_final.sh
#

for FILE_NAME in $(ls | grep _database.csv)
do
    python3.8 final_graph.py ${FILE_NAME} 50 202010

    echo $FILE_NAME

done
