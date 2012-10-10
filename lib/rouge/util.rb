module Rouge
  class Yielder
    def initialize(&pr)
      @proc = pr
    end

    def <<(*a)
      @proc && @proc.call(*a)
    end
  end

  class InheritableHash < Hash
    def initialize(parent=nil)
      @parent = parent
    end

    def [](k)
      _sup = super
      return _sup if own_keys.include?(k)

      _sup || parent[k]
    end

    def parent
      @parent ||= {}
    end

    def include?(k)
      super or parent.include?(k)
    end

    def each(&b)
      keys.each do |k|
        b.call(k, self[k])
      end
    end

    alias own_keys keys
    def keys
      keys = own_keys.concat(parent.keys)
      keys.uniq!
      keys
    end
  end

  class InheritableList
    include Enumerable

    def initialize(parent=nil)
      @parent = parent
    end

    def parent
      @parent ||= []
    end

    def each(&b)
      return enum_for(:each) unless block_given?

      parent.each(&b)
      own_entries.each(&b)
    end

    def own_entries
      @own_entries ||= []
    end

    def push(o)
      own_entries << o
    end
    alias << push
  end
end
