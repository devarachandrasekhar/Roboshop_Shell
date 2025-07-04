#!/bin/bash

DATE=$(date +%F)
SCRIPT_NAME=$0
LOGDIR=/tmp/ 
LOGFILE=$LOGDIR/$SCRIPT_NAME-$DATE.log

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"   


USER=$(id -u)

if  [ $USER -ne 0 ]
    then
        echo "Run with root acess"
        exit 1    
fi


VALIDATE (){
    if  [ $1 -ne 0 ]
    then
        echo -e "$2 $R failed $N"
        exit 1
    else
        echo -e "$2 $G successfull $N"
    fi        
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copied mongo.repo in /etc/yum.repos.d/ "

sudo dnf install -y mongodb-org &>> $LOGFILE

VALIDATE $? "Installed mongodb "

sudo systemctl enable mongod &>> $LOGFILE

VALIDATE $? "enabled mongod"

systemctl start  mongod &>> $LOGFILE

VALIDATE $? "started mongodb"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "Edited MongoDB conf"

systemctl restart  mongod &>> $LOGFILE

VALIDATE $? "restartd mongodb"



