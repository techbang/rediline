module Redline
  module Object
    
    def self.included(model)
      model.send(:extend, ClassMethods)
      
      model.class_eval do
        private
        def redline_key(field_name, entry, type, user=nil)
          raise "no entry provided" if entry.nil?
          user = entry.user if user.nil?
          "#{field_name.to_s}:#{user.class.to_s}.#{user.id.to_s}:#{type}"
        end

        def redline_insert!(entry, key)
          Redline.redis.del(key) unless Redline.redis.type(key) == 'list'
          Redline.redis.rpush(key, entry.to_json)
        end
      end
    end
    
    module ClassMethods
      def redline(field_name, attrs)
        callback = attrs.delete :when
        
        define_method "redline_#{callback}" do
          attrs[:object] = self
          case attrs[:user]
            when Symbol
              attrs[:user] = send(attrs[:user])
            when Proc
              attrs[:user] = attrs[:user].call(self)
            when nil
              attrs[:user] = send(:user)
          end
          
          entry = Redline::Entry.new(attrs)
          entry.user.send(field_name).lists.each_pair do |k, v|
            v.each do |user|
              redline_insert! entry, redline_key(field_name, entry, k, user)
            end
          end
          
          true
        end
        send(callback, "redline_#{callback}")
      end
      
    end
  end
end