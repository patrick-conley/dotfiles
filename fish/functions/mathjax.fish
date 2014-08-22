function mathjax --description 'Run markdown and interpret mathjax'

   set -l md_args

   while test (count $argv) -gt 0
      if test $argv[1] = '--'
         set md_args $md_args $argv[2..-1]
         break
      else if test -z (echo $argv[1] | grep -o '^-')
         set md_args $md_args $argv[1]
         set argv $argv[2..-1]
      end

      switch $argv[1]
         case '-c' '--chem'
            echo '<script type="text/x-mathjax-config"> MathJax.Hub.Config({ TeX: { extensions: ["mhchem.js"] }}); </script>'
            set argv $argv[2..-1]
         case '-*'
            echo "Unknown option $argv[1]" >&2
            echo "Usage: mathjax [--chem] {markdown_py options}" >&2
            return 1
      end
   end

   echo '<script type="text/javascript" src="https://stackedit.io/libs/MathJax/MathJax.js?config=TeX-AMS_HTML"></script>'
   echo '<script type="text/javascript">

   MathJax.Hub.Config({
     tex2jax: {
       inlineMath: [["$","$"]],
       processEscapes: true
     }
   });
   </script>
'

   markdown_py -x mathjax $md_args

end
