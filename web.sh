
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




yum install nginx -y &>>$LOGFILE
VALIDATE $? "Install nginx"


systemctl enable nginx  &>>$LOGFILE
VALIDATE $? "enable nginx"


systemctl start nginx   &>>$LOGFILE
VALIDATE $? "start nginx"



rm -rf /usr/share/nginx/html/*  &>>$LOGFILE
VALIDATE $? "removing default files"


curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip   &>>$LOGFILE
VALIDATE $? "dowload dev content"



cd /usr/share/nginx/html    &>>$LOGFILE


unzip /tmp/web.zip  &>>$LOGFILE
VALIDATE $? "Extarct"


cp /home/ec2-user/Roboshop_Shell/roboshop.conf  /etc/nginx/default.d/roboshop.conf  &>>$LOGFILE
VALIDATE $? "copy reboshop.conf file into etc"


systemctl restart nginx    &>>$LOGFILE

VALIDATE $? "restart nginx"