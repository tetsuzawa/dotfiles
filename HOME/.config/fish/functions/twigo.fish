function twigo
    set -l dir (twig add $argv -q)
    and cd $dir
end
