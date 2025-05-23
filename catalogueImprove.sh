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





while IFS="|" read -r CHECK_CMD RUN_CMD DESC; do
    echo "Checking: $DESC" >> $LOGFILE
    eval "$CHECK_CMD" &>> $LOGFILE
    if [ $? -ne 0 ]; then
        echo -e "$Y $DESC not present. Running command... $N"
        eval "$RUN_CMD" &>> $LOGFILE
        VALIDATE $? "$DESC created"
    else
        echo -e "$G $DESC already exists. Skipping... $N"
    fi
done <<EOF
id -u roboshop|useradd roboshop|User roboshop
ls -ld /app|mkdir /app|/app directory
test -f /tmp/catalogue.zip|curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip|Catalogue zip file
ttest -f /app/package.json|unzip -o /tmp/catalogue.zip -d /app|Unzipping catalogue
EOF




cd /app/     &>> $LOGFILE
VALIDATE $? "Going to app dir"



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

















=====================USING FOR LOOP===============================================
# #/

# REPEATED_TASKS=(
#   "id -u roboshop"
#   "ls -ld /app"
#   "find /tmp/catalogue.zip"
# )

# for TASK in "${REPEATED_TASKS[@]}"
# do
#   echo "Running: $TASK"
#   $TASK &>>$LOGFILE

#   if [ $? -ne 0 ]; then
#     echo "Task failed: $TASK"

#     # Add conditional logic based on task
#     if [[ "$TASK" == "id -u roboshop" ]]; then
#       useradd roboshop &>>$LOGFILE
#       VALIDATE $? "Creating roboshop user"
#     elif [[ "$TASK" == "ls -ld /app" ]]; then
#       mkdir /app &>>$LOGFILE
#       VALIDATE $? "Creating /app directory"
#     elif [[ "$TASK" == "find /tmp/catalogue.zip" ]]; then
#       curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE
#       VALIDATE $? "Downloading catalogue.zip"
#     fi
#   else
#     echo "Task succeeded: $TASK"
#   fi
# done

# /#

