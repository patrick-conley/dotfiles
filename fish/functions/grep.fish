function grep
	/usr/bin/env grep --exclude-dir=".svn" --exclude-dir=".git" $argv
end
