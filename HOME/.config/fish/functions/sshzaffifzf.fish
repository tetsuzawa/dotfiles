function sshfzf
  set PROFILE $argv[1]
  if test -z "$PROFILE"
    set PROFILE "zucks-affiliate"
  end
  echo "profile: $PROFILE"

  set -l USER te-takizawa
  set -l KEYPATH $HOME/.ssh/id_rsa
  set -l TARGET (aws --profile $PROFILE --region ap-northeast-1 ec2 describe-instances | jq -c '.Reservations[].Instances[] | select(.Tags[].Key == "Name") | select(.State.Name == "running") | {"Name": .Tags[].Value, "InstanceId": .InstanceId, "PublicIpAddress": .PublicIpAddress, "AZ": .Placement.AvailabilityZone}' | fzf --exit-0 | jq -r ".PublicIpAddress")
  if test -n "$TARGET" -a -n "$USER" -a -n "$KEYPATH"
    ssh -o ServerAliveInterval=60 -i $KEYPATH $USER@$TARGET
  end
end


