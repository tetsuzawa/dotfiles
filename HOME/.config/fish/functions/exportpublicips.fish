function exportpublicips
    export (aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[?Tags[?Key==`Name` && starts_with(Value, `isu_`)]].[Tags[?Key==`Name`]|[0].Value, PublicIpAddress]' --output text | awk '{print $1 "=" $2}')
end
