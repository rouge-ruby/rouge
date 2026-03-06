# How to contribute to Rouge

[plugin-example]: https://github.com/rouge-ruby/rouge-plugin-example "Rouge Plugin Example Repository"

1. **Absolutely no LLM code**. Rouge is very difficult to maintain as it is, and if you are not interested in learning enough about the system to maintain your contribution, I am not interested in merging it into Rouge core. Rouge lexers are not particularly difficult to understand with a little bit of time investment, and I am more than willing to answer questions in the Discussion or Issues sections here. On the other hand, you are free to use whatever tooling you like to [write your own plugin][plugin-example].

2. If you are contributing a lexer with large (>100) lists of keywords or builtins, **please ensure that these are generated with a rake task from publicly available documentation, and lazy-load them with a `lazy { ... }` block.** See `tasks/builtins/viml.rake` for an example. Large lists of builtins are a massive maintenance overhead, and also use a lot of memory. Please also do not create massive regular expressions, for example large lists of keywords joined with `|`. If there really is no alternative, please let us know.

3. Please ensure your lexer is for a **publicly available and documented language** that has an active public community. Please provide clear publicly-accessible links to the language syntax spec, keyword lists, or other information you used to make the lexer.

4. Please ensure your lexer is for a language that is not primarily used for **blockchain applications**. [Rouge core does not support these](https://github.com/rouge-ruby/rouge/discussions/1857). Again, you are more than welcome to [publish your own plug-in][plugin-example].

5. If your language is too obscure, is internal, not publicly documented, or taking too long for us to get to, **I encourage you to [write your own plugin][plugin-example]**, which you can use easily with Jekyll, Middleman, or self-hosted GitLab. I am not associated with Gitlab - for that, please contact @tancle. For *truly* internal languages, consider just writing a lexer in your own code! This is the approach I took for my own thesis, for example, to nicely highlight in TeX a description of a language that did not yet exist.

6. Please do not copy/paste other lexers and lightly edit them. If your language is a templating language, please use `TemplateLexer` to support the `?parent=...` argument. If your language embeds another language or is a superset of another language, please subclass the lexer or use delegation as appropriate.
