StartTime = $(date +%s)

check=`aws ec2 describe-key-pairs --key-name ojt-test`
if [ ! -n "$check" ]
then
    aws ec2 create-key-pair --key-name ojt-test --query 'KeyMaterial' --output text > ojt-test.pem
    aws ec2 wait key-pair-exists --key-names ojt-test
fi
if [ ! -f ojt-test.pem ]
then
    aws ec2 delete-key-pair --key-name ojt-test
    aws ec2 create-key-pair --key-name ojt-test --query 'KeyMaterial' --output text > ojt-test.pem
    aws ec2 wait key-pair-exists --key-names ojt-test
fi
mv ojt-test.pem configurations/
export key_pair=`ssh-keygen -y -f configurations/ojt-test.pem`
count=`grep key_pair var_ec2_terratest.tfvars|wc -l`
if [ $count == 1 ]
then
    echo ""
else
    echo "" >> var_ec2_terratest.tfvars
    echo "key_pair =" "\""$key_pair"\"" >> var_ec2_terratest.tfvars
fi

# terraform plan -state="state/statefile.tfstate" -var-file="var_ec2_terratest.tfvars" -out="planfile"
terraform plan -state="state/statefile.tfstate" -out="planfile"

EndTime = $(date +%s)
echo -e "---Timer----------------------------------\nIt takes \033[0;36m$(($EndTime - $StartTime)) seconds\033[0m to complete this task.\n------------------------------------------"