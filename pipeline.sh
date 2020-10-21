#!/bin/bash

# store everthing in the array, pass it and pop out in next script
# add new feature, pass the ISP_ASN name
FILES=()

echo
echo "======================================="
echo "<<<=====WELCOME TO THE PIPELINE=====>>>"
echo "======================================="
echo -e "\nRefer to flow.txt for the flow of pipeline...\n"

read -p "Enter the year & month in format YYYYMM : " YYMM 
read -p "Enter the 1st timestamp : " TIME_1
read -p "Enter the 2nd timestamp : " TIME_2
read -p "Enter the 3rd timestamp : " TIME_3
read -p "Enter the 4th timestamp : " TIME_4
echo -e "\nNaming convention for prefix files = ISP_ASN"
read -p "Enter the folder name : " num

for i in $(ls ${num}); do FILES+=( ${temp} ); done

read -p "Enter the max() - min() % LIMIT for graphs : " LIMIT

YYMM_0=${YYMM}0

echo -e "\nHere's what you entered\n"
echo -e "DATE : ${YYMM}\nTIME1 : ${TIME_1}\nTIME2 : ${TIME_2}\nTIME3 : ${TIME_3}\nTIME4 : ${TIME_4}"
echo -e "FILES : ${FILES[@]}\nLIMIT : ${LIMIT}"

echo -e "\n____________________________________________________________\n"
echo -e '\nAre you sure you want to proceed?\nOnce started the code will run for almost 1 day,\n only way to stop it is to kill through\n`ps -ef | grep master.sh`\n& then `kill -9 PID`...\n'
echo -e "____________________________________________________________\n"

read -p 'Please Type : "YES START THE PIPELINE" : ' ans

###########################################################

if [ "${ans}" = "YES START THE PIPELINE" ]; then

    echo '<<<-------This is the log file maintained by the program-------->>>' >> logs.txt
    echo -e "\nCurrent value choosen by user" >> logs.txt
    echo -e "DATE  : ${YYMM}\nTIME1 : ${TIME_1}\nTIME2 : ${TIME_2}\nTIME3 : ${TIME_3}\nTIME4 : ${TIME_4}" >> logs.txt
    echo -e "FILES : ${FILES[@]}\nLIMIT : ${LIMIT}" >> logs.txt

    echo "Now calling master.sh for main task..." >> logs.txt

    FILES+=(${YYMM_0}); FILES+=(${YYMM}); FILES+=(${TIME_1}); FILES+=(${TIME_2});
    FILES+=(${TIME_3}); FILES+=(${TIME_4}); FILES+=(${LIMIT}); FILES+=(${num})

    nohup ./master.sh "${FILES[@]}" &

    echo -e "\nYou can now sit back and relax while we give you email notifications about the progress...\n"
    echo -e 'Else you can watch the [Official logs in `tail -f logs.txt`] or\n[Unofficial logs in `tail -f nohup.out`]'
    echo -e "You can also close this terminal window safely...\n"

else
    echo -e "Input error detected! Exiting the program...\nBye\n"
fi
