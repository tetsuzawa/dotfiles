function ssmfzf
  set PROFILE $argv[1]
  if test -z "$PROFILE"
    set PROFILE "zucks-affiliate"
  end
  echo "profile: $PROFILE"
  set -l TARGET (aws --profile $PROFILE --region ap-northeast-1 ec2 describe-instances | jq -c '.Reservations[].Instances[] | select(.Tags[].Key == "Name") | select(.State.Name == "running") | {"Name": .Tags[].Value, "InstanceId": .InstanceId }' | fzf --exit-0 | jq -r ".InstanceId")
  if test -n "$TARGET"
    aws --profile $PROFILE --region ap-northeast-1 ssm start-session --target $TARGET
  end
end
