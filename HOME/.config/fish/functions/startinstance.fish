function startinstance
  set PROFILE $argv[1]
  if test -z "$PROFILE"
    set PROFILE "tetsu-varmos-admin"
  end
  echo "profile: $PROFILE"
  set -l TARGET (aws --profile $PROFILE --region ap-northeast-1 ec2 describe-instances | jq -c '.Reservations[].Instances[] | select(.State.Name == "stopped")  | {InstanceId: .InstanceId} + (.Tags | map({(.Key): .Value}) | add)' | fzf --exit-0 | jq -r ".InstanceId")
  if test -n "$TARGET"
    aws --profile $PROFILE --region ap-northeast-1 ec2 start-instances --instance-ids $TARGET
  end
end
