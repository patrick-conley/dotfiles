function mathjax --description 'Run markdown and interpret mathjax'

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

   markdown_py -x mathjax $argv

end
