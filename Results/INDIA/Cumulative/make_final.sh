#!/bin/bash

for FILE_NAME in $(ls | grep _database.csv)
do
    python3.7 test.py ${FILE_NAME} 50 201807

    echo $FILE_NAME

done
