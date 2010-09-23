require 'json'
require 'active_support/core_ext'

module Redline
  
  class Entry
    attr_reader   :content
    
    def initialize(content)
      @content = parse(content)
      @objects = {}
    end
    
    def to_json
      @content.to_json
    end
    
    def method_missing(name, *args)
      return content[name] if content.include?(name)
      if content.include?(:"#{name}_object") && content.include?(:"#{name}_object")
        return @objects[name] ||= content[:"#{name}_object"].constantize.find(content[:"#{name}_id"])
      end
      super
    end
    
    def respond_to?(name, *args)
      return true if content.include?(name.to_s)
      return true if content.include?("#{name}_object") && content.include?("#{name}_object")
      super
    end
    
    private
    def parse(string)
      if string.is_a?(String)
        string = JSON.parse(string).symbolize_keys
        
        [:user_id, :user_object, :object_id, :object_object, :verb].each do |f|
          raise "invalid content : missing field #{f}" if string[f].nil?
        end
      else
        string.symbolize_keys!
        
        [:user, :object, :verb].each do |f|
          raise "invalid content : missing field #{f}" if string[f].nil?
        end
        string[:created_at] =  string[:created_at].nil? ? Time.now.utc.to_s : string[:created_at].to_s
        
        object = string[:object]
        string.keys.each do |k|
          string[k] = string[k].call(object) if string[k].is_a?(Proc)
          
          case string[k]
            when String, Symbol
              next
            else
              string[:"#{k}_object"] = string[k].class.to_s
              string[:"#{k}_id"] = string[k].id.to_s
              string.delete k
          end
        end
      end
      string
    end
  end
end