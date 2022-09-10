function sshisuconfzf
  set PROFILE $argv[1]
  if test -z "$PROFILE"
    set PROFILE "tetsu-varmos-admin"
  end

  set -l TARGET (aws --profile $PROFILE --region ap-northeast-1 ec2 describe-instances | jq -c '.Reservations[].Instances[] | select(.State.Name == "running") | {"Name": .Tags[].Value, "InstanceId": .InstanceId, "PublicIpAddress": .PublicIpAddress, "AZ": .Placement.AvailabilityZone}' | fzf --exit-0 | jq -r ".PublicIpAddress")
  set -l USER (echo -e 'ubuntu\nisucon' | fzf --exit-0)

  echo $USER $TARGET

  if test "$USER" = "ubuntu"
      set -l KEYPATH $HOME/.ssh/isucon.pem
      ssh -o ServerAliveInterval=60 -i $KEYPATH $USER@$TARGET
  else if test "$USER" = "isucon"
      ssh -o ServerAliveInterval=60 $USER@$TARGET
  end
end


