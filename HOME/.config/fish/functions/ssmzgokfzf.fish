function ssmzgokfzf
  set -l target (aws --profile zucks-affiliate --region ap-northeast-1 ec2 describe-instances --filter 'Name=instance-state-name,Values=running' --query 'Reservations[].Instances[].{Name:Tags[?Key==`Name`] | [0].Value,InstanceId: InstanceId}' --output json | jq -c .[] | sort | fzf --exit-0 | jq -r .InstanceId)
  if test -n "$target"
    aws --profile zucks-affiliate --region ap-northeast-1 ssm start-session --target $target
  end
end
