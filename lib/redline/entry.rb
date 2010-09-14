require 'json'

module Redline
  
  class Entry
    attr_reader   :content
    attr_reader   :object_type, :object_id
    
    def initialize(string)
      @content = string.is_a?(String) ? parse(string) : stringify_keys!(string)
      
      [:object_type, :object_id].each do |f|
        raise "invalid content : missing field #{f}" if content[f.to_s].nil?
        instance_eval "@#{f.to_s} = #{content[f.to_s]}"
      end
    end
    
    def object
      @object ||= object_type.find(object_id)
    end
    
    private
    def parse(string)
      JSON.parse(string)
    end
    
    def stringify_keys!(hash)
      hash.keys.each do |key|
        hash[key.to_s] = hash.delete(key)
      end
      hash
    end
  end
end