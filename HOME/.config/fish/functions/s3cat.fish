function s3cat
  set TARGET $argv[1]
  aws s3 cp $TARGET - | cat
end

