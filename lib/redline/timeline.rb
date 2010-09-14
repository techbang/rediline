module Redline
  class Timeline
    attr_reader    :field_name, :entry,
      :user_object, :user_id
    
    def initialize(field_name, user_object, user_id)
      @field_name, @user_object, @user_id = field_name, user_object, user_id
    end
    
    def log!(attrs)
      attrs[:user_object], attrs[:user_id] = user_object, user_id
      @entry = Redline::Entry.new(attrs)
      insert! entry, key(:egocentric)
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
      "#{field_name.to_s}:#{user_object.to_s}.#{user_id.to_s}:#{type}"
    end
    
    def insert!(entry, key)
      Redline.redis.del(key) unless Redline.redis.type(key) == 'list'
      Redline.redis.rpush(key, entry.to_json)
    end
  end
end