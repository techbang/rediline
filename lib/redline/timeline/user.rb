module Redline
  module Timeline
    class User
      attr_reader    :field_name, :user

      def initialize(field_name, user)
        @field_name, @user = field_name, user
      end
      
      def each(type)
        raise "you must provide a block" unless block_given?
        (0..count(type)-1).each do |i|
          data = Redline.redis.lindex(key(type), i)
          yield Redline::Entry.new(data)
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
        Redline.redis.llen(key(type))
      end
      
      private
      def key(type)
        "#{field_name.to_s}:#{@user.class.to_s}.#{@user.id.to_s}:#{type}"
      end
    end
  end
end