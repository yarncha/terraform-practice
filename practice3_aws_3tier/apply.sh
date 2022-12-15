StartTime = $(date +%s)

check = `aws ec2 describe-key-pairs --key-name `
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

terraform apply -auto-approve -state="state/statefile.tfstate" planfile

EndTime = $(date +%s)
echo -e "---Timer----------------------------------\nIt takes \033[0;36m$(($EndTime - $StartTime)) seconds\033[0m to complete this task.\n------------------------------------------"