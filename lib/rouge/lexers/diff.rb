module Rouge
  module Lexers
    class Diff < RegexLexer
      title 'diff'
      desc 'Lexes unified diffs or patches'

      tag 'diff'
      aliases 'patch', 'udiff'
      filenames '*.diff', '*.patch'
      mimetypes 'text/x-diff', 'text/x-patch'

      def self.analyze_text(text)
        return 1   if text.start_with?('Index: ')
        return 1   if text.start_with?('diff ')

        # TODO: Have a look at pygments here, seems better
        return 0.9 if text =~ /\A---.*?\n\+\+\+/m
      end

      state :root do
        rule(/^ .*\n/, Text)
        rule(/^\+.*\n/, Generic::Inserted)
        # Do not highlight the delimiter line
        # before the diffstat in email patches.
        rule(/^-+ .*\n/, Generic::Deleted)
        rule(/^!.*\n/, Generic::Strong)
        rule(/^@.*\n/, Generic::Subheading)
        rule(/^([Ii]ndex|diff).*\n/, Generic::Heading)
        rule(/^=.*\n/, Generic::Heading)
        rule(/.*\n/, Text)
      end
    end
  end
end
