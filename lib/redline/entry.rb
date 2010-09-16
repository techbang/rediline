require 'json'
require 'active_support/core_ext'

module Redline
  
  class Entry
    attr_reader   :content
    
    def initialize(content)
      @content = parse(content)
      
    end
    
    def to_json
      @content.to_json
    end
    
    def user
      @user ||= content['user_object'].constantize.find(content['user_id'])
    end
    def object
      @object ||= content['object_object'].constantize.find(content['object_id'])
    end
    
    def method_missing(name, *args)
      return content[name.to_s] if content.include?(name.to_s)
      super
    end
    
    def respond_to?(name, *args)
      return true if content.include?(name.to_s)
      super
    end
    
    private
    def parse(string)
      if string.is_a?(String)
        string = JSON.parse(string)
        
        [:user_id, :user_object, :object_id, :object_object, :verb].each do |f|
          raise "invalid content : missing field #{f.to_s}" if string[f.to_s].nil?
        end
      else
        string.stringify_keys!
        
        [:user, :object, :verb].each do |f|
          raise "invalid content : missing field #{f.to_s}" if string[f.to_s].nil?
          next if string[f.to_s].is_a?(String) or string[f.to_s].is_a?(Symbol)
          string["#{f}_object"] = string[f.to_s].class.to_s
          string["#{f}_id"] = string[f.to_s].id.to_s
          string.delete f.to_s
        end
      end
      
      string
    end
  end
end