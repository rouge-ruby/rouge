# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    load_lexer 'javascript.rb'

    class RunKitJS < Javascript
      tag 'runkit_js'
      title "RunKit/JavaScript"
      desc 'a runnable JavaScript parser.'
      aliases 'runkit_javasript', 'runkit'

      def initialize(opts={})
        @node_version = opts.delete(:node_version)
        @read_only = opts.delete(:read_only)
        @package_resolution_timestamp = opts.delete(:package_resolution_timestamp)
        @mode = opts.delete(:mode)

        super(opts)
      end

      def stream_tokens(stream, &b)
        super(stream, &b)
        b.call(Token.make_token('', ''), RunKitScript.new(@node_version, @read_only, @package_resolution_timestamp, @mode))
      end

      class RunKitScript
        def initialize(node_version, read_only, package_resolution_timestamp, mode)
          @node_version = node_version
          @read_only = read_only
          @package_resolution_timestamp = package_resolution_timestamp
          @mode = mode
        end

        def empty?
          false
        end

        def scan(b)
          return 0
        end

        def gsub(a,b)
          read_only_prop = @read_only ? "readOnly: \"" + @read_only.to_s + "\"," : ""
          node_version_prop = @node_version ? "nodeVersion: \"" + @node_version.inspect[1..-2] + "\"," : ""
          package_resolution_timestamp_prop = @package_resolution_timestamp ? "packageResolutionTimestamp: " + @package_resolution_timestamp + "," : ""
          mode_prop = @mode ? "mode: \"" + @mode + "\"," : ""

          return "<script src='https://embed.runkit.com'></script><script>
var script = document.currentScript || (function() {
  var scripts = document.getElementsByTagName('script');
  return scripts[scripts.length - 1];
})();

var parent = script.parentNode;
parent.removeChild(script);
var owner = parent;
while (owner.className !== 'highlight')  owner = owner.parentNode;
owner.innerHTML = '';
owner.style.padding = '0 50px';
owner.style.overflowX = 'hidden';
owner.style.backgroundColor = 'initial';
owner.style.border = 'none';

var notebook = RunKit.createNotebook({
  // the parent element for the new notebook
  element: owner, #{read_only_prop} #{node_version_prop} #{package_resolution_timestamp_prop} #{mode_prop}
  // specify the source of the notebook
  source: RunKit.sourceFromElement(parent)
})
</script>"
        end
      end
    end
  end
end
