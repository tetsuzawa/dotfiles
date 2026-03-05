function twigo
    set -l branch $argv[1]
    set -l main_dir (dirname (git rev-parse --path-format=absolute --git-common-dir))
    set -l existing_path (git worktree list --porcelain | awk -v branch="refs/heads/$branch" '
        /^worktree / { path = substr($0, 10) }
        $0 == "branch " branch { print path }
    ')

    if test -n "$existing_path"
        cd $existing_path
    else
        cd $main_dir
        and set -l dir (twig add $argv -q)
        and cd $dir
    end

    and claude
end
