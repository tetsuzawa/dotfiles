function ssmzgokfzf
  set -l target (aws --profile zucks-zgok --region ap-northeast-1 ec2 describe-instances | jq -c '.Reservations[].Instances[] | select(.Tags[].Key == "Name") | select(.State.Name == "running") | {"Name": .Tags[].Value, "InstanceId": .InstanceId }' | fzf --exit-0 | jq -r ".InstanceId")
  if test -n "$target"
    aws --profile zucks-zgok --region ap-northeast-1 ssm start-session --target $target
  end
end
