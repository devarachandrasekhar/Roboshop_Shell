
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


curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE
VALIDATE $? "Downloaded devolper content"


yum install nodejs -y   &>> $LOGFILE
VALIDATE $? "Installed nodeja"

useradd roboshop    &>> $LOGFILE


mkdir /app  &>> $LOGFILE



curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip   &>> $LOGFILE
VALIDATE $? "Downloaded devolper content"



cd /app     &>> $LOGFILE
#VALIDATE $? "Going to app dir"

#unzip /tmp/catalogue.zip    &>> $LOGFILE
#VALIDATE $? "unzip"




npm install &>> $LOGFILE
VALIDATE $? "npm istall"


cp /home/ec2-user/Roboshop_Shell/catalogue.service  /etc/systemd/system/catalogue.service &>> $LOGFILE
VALIDATE $? "copy catalogue service into ect"




systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "daemon-reload"

systemctl enable catalogue &>> $LOGFILE
VALIDATE $? "enable catalogue"


systemctl start catalogue &>> $LOGFILE
VALIDATE $? "start catalogue"


cp /home/ec2-user/Roboshop_Shell/mongodb-org-4.4.repo /etc/yum.repos.d/mongodb-org-4.4.repo &>> $LOGFILE
VALIDATE $? "copy mongodb.repo into ect folder"


yum install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "mongoorg shll"


mongo --host mongod.practicedevops.store </app/schema/catalogue.js &>> $LOGFILE
VALIDATE $? "Loading data into mogodb"