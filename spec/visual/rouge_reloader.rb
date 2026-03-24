# [jneen] this reloader is responsible for safely hot-loading Rouge in the dev server.
# Previously, we were able to simply remove the Rouge constant and load lib/rouge.rb,
# and all of Rouge would happily be reloaded. However, we have recently switched to
# require_relative, which maintains its own global cache. Meaning that if we were to
# remove the Rouge constant and load lib/rouge.rb, the line
#
# require_relative 'rouge/lexer'
#
# would be a no-op, and hence the constant Rouge::Lexer would not exist.
#
# This reloader clears a portion of that cache by mutating $LOADED_FEATURES.
class FeatureReloader
  MUTEX = Mutex.new

  def self.reload!
    @instance.reload!
  end

  def initialize(const_name, root, path)
    @const_name = const_name
    @root = root
    @path = File.expand_path(path, root)
  end

  def reload!
    STDERR.puts "========= reloading #{@const_name} ========="

    MUTEX.synchronize do
      # remove the global constant
      Object.send(:remove_const, @const_name) if Object.const_defined?(@const_name)

      # clear the cache
      $LOADED_FEATURES.reject! { |f| f.start_with?(@root) }

      # load rouge.rb
      Kernel.load(@path)
    end
  end
end
