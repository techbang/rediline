module Rediline
  module Object
    
    def self.included(model)
      model.send(:extend, ClassMethods)
      
      model.class_eval do
        private
        def rediline_key(field_name, entry, type, user=nil)
          raise "no entry provided" if entry.nil?
          user = entry.user if user.nil?
          "#{field_name.to_s}:#{user.class.to_s}.#{user.id.to_s}:#{type}"
        end

        def rediline_insert!(entry, key)
          Rediline.redis.del(key) unless Rediline.redis.type(key) == 'list'
          Rediline.redis.rpush(key, entry.to_json)
        end
      end
    end
    
    module ClassMethods
      def rediline(field_name, attrs)
        attrs.symbolize_keys!
        callback = attrs.delete :when
        
        define_method "rediline_#{callback}" do
          if attrs.frozen?
            entry = Rediline::Entry.new(attrs.dup)
          else
            attrs[:object] = self
            case attrs[:user]
              when Symbol, String
                attrs[:user] = send(attrs[:user])
              when Proc
                attrs[:user] = attrs[:user].call(self)
              when nil
                attrs[:user] = send(:user)
            end
            attrs.freeze
            entry = Rediline::Entry.new(attrs.dup)
          end
          
          entry.user.send(field_name).lists.each_pair do |k, v|
            v.each do |user|
              rediline_insert! entry, rediline_key(field_name, entry, k, user)
            end
          end
          
          true
        end
        send(callback, "rediline_#{callback}")
      end
      
    end
  end
end