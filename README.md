# Rouge

This project is not yet finished, but this works:

``` ruby
formatter = Rouge::Formatters::HTML.new
Rouge.highlight(File.read('/etc/bash.bashrc'), 'shell', formatter)
```

More features, documentation, lexers, and formatters to come.  Help is appreciated, too, if you think this is awesome :)
