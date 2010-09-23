module Rediline
  module Timeline
    class User
      attr_reader    :field_name, :user, :block, :lists

      def initialize(field_name, user, block)
        @field_name, @user, @block = field_name, user
        @lists = {}
        instance_eval(&block)
      end
      
      def each(type)
        raise "you must provide a block" unless block_given?
        (0..count(type)-1).each do |i|
          data = Rediline.redis.lindex(key(type), i)
          yield Rediline::Entry.new(data)
        end
      end

      def to_a(type)
        result = Array.new
        self.each(type) do |entry|
          result << entry
        end
        result
      end

      def count(type)
        Rediline.redis.llen(key(type))
      end
      
      def list(name, &block)
        @lists[name] = instance_eval(&block)
      end
      
      private
      def key(type)
        "#{field_name.to_s}:#{@user.class.to_s}.#{@user.id.to_s}:#{type}"
      end
    end
  end
end