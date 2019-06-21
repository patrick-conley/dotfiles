function svn

   function l_less
      /usr/bin/env less -XF
   end

   function l_svn
      /usr/bin/env svn $argv
   end

   if begin;
         contains "diff" $argv[1]; \
         and not contains -- "--diff-cmd" $argv;
      end

      l_svn $argv | l_less

   else if contains "difftool" $argv[1]
      set -e argv[1]
      l_svn diff --diff-cmd ~/bin/svndiff.sh $argv

   else if contains "diffs" $argv[1]
      set -e argv[1]
      l_svn diff --summarize $argv | l_less

   else if contains "diffstat" $argv[1]
      set -e argv[1]
      l_svn diff --patch-compatible $argv | diffstat | l_less

   else if begin;
         contains "status" $argv[1]; \
         and not contains -- "-v" $argv; \
         and not contains -- "-q" $argv; \
         and not contains -- "--ignore-externals" $argv;
      end

      # Exclude status flags that are always printed for external directories,
      # but include info on modified files
      l_svn $argv | grep -v -e "^\s*X" -e "^Performing status" -e '^\s*$' | l_less

   else if contains "log" $argv[1]
      set -e argv[1]
      /usr/bin/svn log --incremental $argv | l_less

   else if contains $argv[1] "blame" "help" "praise" "propget"
      l_svn $argv | l_less

   else if contains "branch" $argv[1]
      set new_branch $argv[2]

      set current_path (l_svn info --show-item relative-url)
      set current_branch (l_svn info --show-item relative-url (svn info --show-item wc-root))
      if test $current_path != $current_branch
         # Maybe fix this by cd'ing to the root, switching, then cd'ing back
         echo "Error: Won't copy non-root paths"
         return
      end

      if echo $current_branch | grep branches >/dev/null
         echo "Warning: Creating a branch off a branch"
         set new_branch (echo $current_branch | sed 's!/[^/]*$!!')/$new_branch
      else
         set new_branch (echo $current_branch | sed 's!trunk$!branches!')/$new_branch
      end

      if l_svn ls $new_branch >/dev/null ^&1
         echo "Error: Branch already exists"
         return
      end

      l_svn copy $current_branch $new_branch
      l_svn switch $new_branch

   else if contains "switch" $argv[1]
      set new_branch $argv[2]

      # if a branch contains slashes, switch to it explicitly
      if echo $new_branch | grep "/" >/dev/null
         l_svn $argv
         return
      end

      set current_path (l_svn info --show-item relative-url)
      set current_branch (l_svn info --show-item relative-url (svn info --show-item wc-root))
      if test $current_path != $current_branch
         # Maybe fix this by cd'ing to the root, switching, then cd'ing back
         echo "Error: Can't autoswitch to non-root paths"
         return
      end

      if echo $current_branch | grep branches >/dev/null
         if test $new_branch = "trunk"
            # branch to trunk
            l_svn switch (echo $current_branch | sed 's!/branches/[^/]*$!!')/$new_branch
         else
            # branch to branch
            l_svn switch (echo $current_branch | sed 's!/[^/]*$!!')/$new_branch
         end
      else if test $new_branch != "trunk"
         # trunk to branch
         l_svn switch (echo $current_branch | sed 's!trunk$!branches!')/$new_branch
      end

   else if contains "fixmove" $argv[1]
      set src $argv[2]
      set dest $argv[3]

      # if the first arg exists and is not committed, then it's actually the
      # destination
      if begin;
            test -e $argv[2]; \
            and not svn status $argv[2];
         end

            set dest $argv[2]
            set src $argv[3]
      end

      echo From $src
      echo to $dest
      echo

      mv $dest $src
      l_svn add --parents (dirname $dest)
      l_svn mv $src $dest

   else
      l_svn $argv

   end
end
