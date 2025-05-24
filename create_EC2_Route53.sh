# aws CLI command to create the EC2

# aws ec2 run-instances \
#   --image-id ami-09c813fb71547fc4f \
#   --instance-type t2.micro \
#   --security-groups default \
#   --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=MyEC2Instance}]' \
#   --count 1


#NAMES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

NAMES=("mongodb" "redis")

INSTANCE_TYPE=""
IMAGE_ID="ami-09c813fb71547fc4f"
DOMINE_NAME="practicedevops.store"
SECURITY_GROUP_ID=sg-03bc87c4ab7c3d498
HOSTED_ZONE=Z08310291HO6SKKR1U225



for i in "${NAMES[@]}"
do 
    if [[ $i == "mysql" || $i == "mongodb" ]]
    then 
        INSTANCE_TYPE="t3.medium"
    else
        INSTANCE_TYPE="t2.micro"
    fi
    echo "creating $i"

   IP_ADDRESS=$(aws ec2 run-instances \
  --image-id $IMAGE_ID \
  --instance-type $INSTANCE_TYPE \
  --security-group-ids $SECURITY_GROUP_ID \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]")

  echo "created $i instance: $IP_ADDRESS"

   aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE --change-batch '
   {
            "Changes": [{
            "Action": "CREATE",
                        "ResourceRecordSet": {
                            "Name": "'$i.$DOMINE_NAME'",
                            "Type": "A",
                            "TTL": 300,
                            "ResourceRecords": [{"Value": "'$IP_ADDRESS'"}]
                        }}]
    }
    '
done
