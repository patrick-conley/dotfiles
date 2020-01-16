function bigfiles -d "Find the largest files in a path"

   find $argv[1] -type f -exec du -Sh '{}' + | sort -rh | head -n $argv[2]

end
