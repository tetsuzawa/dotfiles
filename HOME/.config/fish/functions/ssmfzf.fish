function ssmfzf
  set -x PROFILE "$AWS_PROFILE"
  if not set -q PROFILE
      echo run 'export AWS_PROFILE=xxxxx'
      return 1
  end
  echo "profile: $PROFILE"
  set -l TARGET (aws --profile $PROFILE --region ap-northeast-1 ec2 describe-instances | jq -c '.Reservations[].Instances[] | select(.State.Name == "running")  | {InstanceId: .InstanceId} + (.Tags | map({(.Key): .Value}) | add)' | fzf --exit-0 | jq -r ".InstanceId")
  if test -n "$TARGET"
    aws --profile $PROFILE --region ap-northeast-1 ssm start-session --target $TARGET
  end
end
