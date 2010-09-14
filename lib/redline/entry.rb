require 'json'
require 'active_support/core_ext'

module Redline
  
  class Entry
    attr_reader   :content
    attr_reader   :object, :user
    
    def initialize(content)
      @content = parse(content)
      
    end
    
    def to_json
      @content.to_json
    end
    
    private
    def parse(string)
      if string.is_a?(String)
        string = JSON.parse(string)
        
        [:user, :object].each do |f|
          raise "invalid content : missing field #{f.to_s}" if string["#{f.to_s}_object"].nil? or string["#{f.to_s}_id"].nil?
          instance_eval "@#{f.to_s} = string['#{f}_object'].constantize.find(string['#{f}_id'])"
        end
      else
        string.stringify_keys!
        [:user, :object].each do |f|
          raise "invalid content : missing field #{f.to_s}" if string[f.to_s].nil?
          instance_eval "@#{f.to_s} = string.delete('#{f.to_s}')"
          instance_eval "string['#{f.to_s}_object'] = @#{f.to_s}.class.to_s"
          instance_eval "string['#{f.to_s}_id'] = @#{f.to_s}.id.to_s"
        end
      end
      
      string
    end
  end
end