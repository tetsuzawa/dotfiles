function ecsexecfzf
  set PROFILE $argv[1]
  if test -z "$PROFILE"
    set PROFILE (cat ~/.aws/config | ggrep -oP '\[profile ([a-zA-Z0-9_-]+)\]' | cut -d ' ' -f2 | ggrep -oP '[a-zA-Z0-9_-]+' | fzf)
  end
  echo "profile: $PROFILE"

  set CLUSTER $argv[2]
  if test -z "$CLUSTER"
    set CLUSTER (aws --profile $PROFILE ecs list-clusters | jq .clusterArns[] | cut -d '"' -f2 | fzf)
  end
  echo "cluster: $CLUSTER"

  set -l TARGET (aws --profile $PROFILE --region ap-northeast-1 ecs list-tasks --cluster "$CLUSTER" | jq -r '.taskArns[]' | cut -d '"' -f2 | xargs aws --profile $PROFILE ecs describe-tasks --cluster zeon-ksk-receiver --tasks | jq -r '.tasks[] | [.group, "task_definition:" + .taskDefinitionArn, "task_id:" + .taskArn] | @tsv' | sed -E 's/arn:aws:ecs:[-a-z0-9]+:[-0-9]+:(task|task-definition)\/[-a-zA-Z0-9]+(\/|:)//g' | sort -r | fzf | perl -ne 'print $1 if /task_id:([a-z0-9]+)/')
  echo "task: $TARGET"

  set CONTAINER $argv[3]
  if test -z "$CONTAINER"
    set CONTAINER (aws --profile $PROFILE ecs describe-tasks --cluster $CLUSTER --tasks $TARGET | jq -r '.tasks[].containers[].name' | sort | uniq | fzf)
  end
  echo "container: $CONTAINER"

  aws --profile $PROFILE ecs execute-command --cluster $CLUSTER \
                         --task $TARGET \
                         --container $CONTAINER \
                         --interactive \
                         --command "/bin/bash"
end

