module Redline
  module Object
    
    def self.included(model)
      model.send(:extend, ClassMethods)
      
      model.class_eval do
        private
        def redline_key(field_name, entry, type)
          raise "no entry provided" if entry.nil?
          "#{field_name.to_s}:#{entry.user.class.to_s}.#{entry.user.id.to_s}:#{type}"
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
          redline_insert! entry, redline_key(field_name, entry, :egocentric)
        end
        send(callback, "redline_#{callback}")
      end
      
    end
  end
end