function stopinstance
  set PROFILE $argv[1]
  if test -z "$PROFILE"
    set PROFILE "tetsu-varmos-admin"
  end
  set -l TARGET (aws --profile $PROFILE --region ap-northeast-1 ec2 describe-instances | jq -c '.Reservations[].Instances[] | select(.State.Name == "running")  | {InstanceId: .InstanceId} + (.Tags | map({(.Key): .Value}) | add)' | fzf --exit-0 | jq -r ".InstanceId")
  if test -n "$TARGET"
    aws --profile $PROFILE --region ap-northeast-1 ec2 stop-instances --instance-ids $TARGET
  end
end
