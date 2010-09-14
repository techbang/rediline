require 'json'
require 'active_support/core_ext'

module Redline
  
  class Entry
    attr_reader   :content
    attr_reader   :object_type, :object_id, :user_object, :user_id
    
    def initialize(string)
      @content = string.is_a?(String) ? parse(string) : string.stringify_keys!
      
      @user_object = @content['user_object'].nil? ? User : @content['user_object'].to_s
      [:object_type, :object_id, :user_id].each do |f|
        raise "invalid content : missing field #{f}" if content[f.to_s].nil?
        instance_eval "@#{f.to_s} = #{content[f.to_s]}"
      end
    end
    
    def object
      @object ||= object_type.find(object_id)
    end
    def user
      @user ||= user_object.constantize.find(user_id)
    end
    
    def to_json
      @content.to_json
    end
    
    private
    def parse(string)
      JSON.parse(string)
    end
  end
end