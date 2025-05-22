#!/bin/bash

DATE=$(date +%F)
SCRIPT_NAME=$($0)
LOGDIR=/home/ec2-user/Shell_Script/shell_logs 
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

cp mongodb-org-4.4.repo /etc/yum.repos.d/mongodb-org-4.4.repo

VALIDATE $? copied

sudo dnf install -y mongodb-org

VALIDATE $? Install

sudo systemctl start mongod

VALIDATE $? start

systemctl status  mongodb

VALIDATE $? status




VALIDATE ()

if  [ $1 -ne 0 ]
    then
        echo "$2 $R failed $N"
        exit 1
    else
        echo "$2 $G successfull $N"
fi        
