module Redline
  module Timeline
    class Object
      attr_reader    :field_name, :object, :entry

      def initialize(field_name, object)
        @field_name, @object = field_name, object
      end

      def log!(attrs)
        attrs[:object] = object
        @entry = Redline::Entry.new(attrs)
        insert! entry, key(:egocentric)
      end

      private
      def key(type)
        raise "no entry provided" if @entry.nil?
        "#{field_name.to_s}:#{@entry.user.class.to_s}.#{@entry.user.id.to_s}:#{type}"
      end

      def insert!(entry, key)
        Redline.redis.del(key) unless Redline.redis.type(key) == 'list'
        Redline.redis.rpush(key, entry.to_json)
      end
    end
  end
end