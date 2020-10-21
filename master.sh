#!/bin/bash
# receive ISP_ASN name in next update

# download data for a month from routeviews
# server has 40 v-CPUs, so run 3 instances at a time

############ GLOBAL VARS ##############

FILES=("$@")

YYMM_0=${FILES[-7]}              # YY & MM for folder names (less than 10)
YYMM=${FILES[-6]}                 # YY & MM for folder names (greater than 10)
TIME_1=${FILES[-5]}                 # timestamp 1
TIME_2=${FILES[-4]}                 # timestamp 2
TIME_3=${FILES[-3]}                 # timestamp 3
TIME_4=${FILES[-2]}                 # timestamp 4
LIMIT=${FILES[-1]}                  # limit for graphs

#######################################

DATE=1
wait_buffer=()

for i in {1..20}
do

  echo -e "\nIteration number #${i} out of 20" >> logs.txt
  echo -e "__________________________________\n" >> logs.txt
  ### if date is multiple of 3, then wait, do cleaning and mongo import 

  if [ $((${DATE} % 3)) -eq 0 ]
  then

    ((DATE-=2))

    for (( j=0; j<3; j++ ))
    do

      if [ ${DATE} -lt 10  ]
      then
        
        cd ${YYMM_0}${DATE}
        rm routeviews.py
        find . -size 0 -delete      # delete empty files

        for dumps in $(ls)
        do
            echo Trimming ${dumps}
            (awk -F'|' '{ print $2" "$3}' ${dumps} > ${dumps}.tmp            # trim the data
            mv ${dumps}.tmp ${dumps}                                        # remove old and rename AND # replace ' ' with ',' AND # add csv header
            sed -i 's/\ /,/g' ${dumps}
            sed  -i '1i PREFIX,PATH1,PATH2,PATH3,PATH4,PATH5,PATH6,PATH7,PATH8,PATH9,PATH10,PATH11,PATH12,PATH13,PATH14,PATH15,PATH16' ${dumps}) &
            wait_buffer+=($!)
        done

        echo -e "\nHouse keeping in ${YYMM_0}${DATE}\n1. Deleting routeviews.py\n2. Deleting empty files\n3. Trimming dumps\n4. Replacing whitespace with comma\n5. Inserting CSV header\n" >> ../logs.txt

        for PID in "${wait_buffer[@]}"; do wait ${PID}; done    # wait for cleansing of data
        wait_buffer=()    # reset array

        echo -e "House keeping done successfully\nNow importing data for ${YYMM_0}${DATE} in mongoDB, 4 collections at a time..." >> ../logs.txt

        # now mongo import

        FILES_1=rib.${YYMM_0}${DATE}.${TIME_1}_*
        (for F in $FILES_1; do mongoimport -d ${YYMM_0}${DATE} -c ${TIME_1} --type csv --file "$F" --headerline; done) &
        wait_buffer+=($!)
        FILES_2=rib.${YYMM_0}${DATE}.${TIME_2}_*
        (for F in $FILES_2; do mongoimport -d ${YYMM_0}${DATE} -c ${TIME_2} --type csv --file "$F" --headerline; done) &
        wait_buffer+=($!)
        FILES_3=rib.${YYMM_0}${DATE}.${TIME_3}_*
        (for F in $FILES_3; do mongoimport -d ${YYMM_0}${DATE} -c ${TIME_3} --type csv --file "$F" --headerline; done) &
        wait_buffer+=($!)
        FILES_4=rib.${YYMM_0}${DATE}.${TIME_4}_*
        (for F in $FILES_4; do mongoimport -d ${YYMM_0}${DATE} -c ${TIME_4} --type csv --file "$F" --headerline; done) &
        wait_buffer+=($!)
        
        for PID in "${wait_buffer[@]}"; do wait ${PID}; done    # wait for mongoimport
        wait_buffer=()    # reset array

        echo "Imported data successfully!" >> ../logs.txt
        echo "Deleting redundant data..." >> ../logs.txt
        rm *

      else

        cd ${YYMM}${DATE}
        rm routeviews.py
        find . -size 0 -delete      # delete empty files

        for dumps in $(ls)
        do
            echo Trimming ${dumps};
            (awk -F'|' '{ print $2" "$3}' ${dumps} > ${dumps}.tmp;           # trim the data
            mv ${dumps}.tmp ${dumps};                                        # remove old and rename AND # replace ' ' with ',' AND # add csv header
            sed -i 's/\ /,/g' ${dumps}; sed  -i '1i PREFIX,PATH1,PATH2,PATH3,PATH4,PATH5,PATH6,PATH7,PATH8,PATH9,PATH10,PATH11,PATH12,PATH13,PATH14,PATH15,PATH16' ${dumps}) &
            wait_buffer+=($!)
        done

        echo -e "\nHouse keeping in ${YYMM}${DATE}\n1. Deleting routeviews.py\n2. Deleting empty files\n3. Trimming dumps\n4. Replacing whitespace with comma\n5. Inserting CSV header\n" >> ../logs.txt

        for PID in "${wait_buffer[@]}"; do wait ${PID}; done    # wait for cleansing of data
        wait_buffer=()    # reset array

        echo -e "House keeping done successfully\nNow importing data for ${YYMM}${DATE} in mongoDB, 4 collections at a time..." >> ../logs.txt

        # now mongo import

        FILES_1=rib.${YYMM}${DATE}.${TIME_1}_*
        (for F in $FILES_1; do mongoimport -d ${YYMM}${DATE} -c ${TIME_1} --type csv --file "$F" --headerline; done) &
        wait_buffer+=($!)
        FILES_2=rib.${YYMM}${DATE}.${TIME_2}_*
        (for F in $FILES_2; do mongoimport -d ${YYMM}${DATE} -c ${TIME_2} --type csv --file "$F" --headerline; done) &
        wait_buffer+=($!)
        FILES_3=rib.${YYMM}${DATE}.${TIME_3}_*
        (for F in $FILES_3; do mongoimport -d ${YYMM}${DATE} -c ${TIME_3} --type csv --file "$F" --headerline; done) &
        wait_buffer+=($!)
        FILES_4=rib.${YYMM}${DATE}.${TIME_4}_*
        (for F in $FILES_4; do mongoimport -d ${YYMM}${DATE} -c ${TIME_4} --type csv --file "$F" --headerline; done) &
        wait_buffer+=($!)
        
        for PID in "${wait_buffer[@]}"; do wait ${PID}; done    # wait for mongoimport
        wait_buffer=()    # reset array

        echo "Imported data successfully!" >> ../logs.txt
        echo "Deleting redundant data..." >> ../logs.txt
        rm *

      fi

      cd ..
      ((DATE++))

    done

    echo "Process completed for 3 directories, moving to next..." >> logs.txt

  #################### if not multiple of 3 ##################

  else

    for (( j=0; j<3; j++ ))
    do

      if [ ${DATE} -lt 10  ]
      then

        mkdir ${YYMM_0}${DATE}
        cp routeviews.py ${YYMM_0}${DATE}
        cd ${YYMM_0}${DATE}
  
        python3 routeviews.py ${YYMM_0}${DATE}.${TIME_1} &
        wait_buffer+=($!)
        python3 routeviews.py ${YYMM_0}${DATE}.${TIME_2} &
        wait_buffer+=($!)
        python3 routeviews.py ${YYMM_0}${DATE}.${TIME_3} &
        wait_buffer+=($!)
        python3 routeviews.py ${YYMM_0}${DATE}.${TIME_4} &
        wait_buffer+=($!)

        echo "Downloading data for ${YYMM_0}${DATE}.${TIME_1}" >> ../logs.txt
        echo "Downloading data for ${YYMM_0}${DATE}.${TIME_2}" >> ../logs.txt
        echo "Downloading data for ${YYMM_0}${DATE}.${TIME_3}" >> ../logs.txt
        echo -e "Downloading data for ${YYMM_0}${DATE}.${TIME_4}\n" >> ../logs.txt

      else

        mkdir ${YYMM}${DATE}
        cp routeviews.py ${YYMM}${DATE}
        cd ${YYMM}${DATE}

        python3 routeviews.py ${YYMM}${DATE}.${TIME_1} &
        wait_buffer+=($!)
        python3 routeviews.py ${YYMM}${DATE}.${TIME_2} &
        wait_buffer+=($!)
        python3 routeviews.py ${YYMM}${DATE}.${TIME_3} &
        wait_buffer+=($!)
        python3 routeviews.py ${YYMM}${DATE}.${TIME_4} &
        wait_buffer+=($!)

        echo "Downloading data for ${YYMM}${DATE}.${TIME_1}" >> ../logs.txt
        echo "Downloading data for ${YYMM}${DATE}.${TIME_2}" >> ../logs.txt
        echo "Downloading data for ${YYMM}${DATE}.${TIME_3}" >> ../logs.txt
        echo -e "Downloading data for ${YYMM}${DATE}.${TIME_4}\n" >> ../logs.txt

      fi

      cd ..
      ((DATE++))


    done

    echo "Done downloading data for 3 days simultaneously..." >> logs.txt

    for PID in "${wait_buffer[@]}"; do wait ${PID}; done    # wait for data to download
    wait_buffer=()    # reset array

    echo "Done!" >> logs.txt
    ((DATE--))

  fi

done

echo "Deleting empty folders..." >> logs.txt
rm -rf ${YYMM}*

##########################################################

echo -e "\nCOMPLETED PHASE 1 successfully!\nSending an email" >> logs.txt
python3 mail.py "COMPLETED PHASE 1 successfully!\
Data is downloaded & imported to mongoDB!"

##########################################################

# run script to add index

/bin/bash add_index.sh ${YYMM} ${TIME_1} ${TIME_2} ${TIME_3} ${TIME_4}

##########################################################

# echo -e "\nCOMPLETED PHASE 2 successfully!\nSending an email" >> logs.txt
# python3 mail.py "\nCOMPLETED PHASE 2 successfully!\nIndexing has been done for mongoDB!"

##########################################################

# script to search mongo & make CSV

/bin/bash mongo_CSV.sh "${FILES[@]}"

##########################################################

# echo -e "\nCOMPLETED PHASE 3 successfully!\nSending an email" >> logs.txt
# python3 mail.py "\nCOMPLETED PHASE 3 successfully!\nAll CSV files have been made!"

##########################################################

/bin/bash make_graphs.sh ${LIMIT}

##########################################################

# echo -e "\nCOMPLETED FINAL PHASE 4 successfully!\nSending final email" >> logs.txt
# python3 mail.py "\nCOMPLETED FINAL PHASE 4 successfully!\nGraphs are ready!\nGo and check them!"

##########################################################

echo -e "\nEverything is ready for you!\n" >> logs.txt
echo -e "___________________________________________\n" >> logs.txt
