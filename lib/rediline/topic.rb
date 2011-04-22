module Rediline
  module Topic
    
    def self.included(model)
      model.extend(ClassMethods)
    end
    module ClassMethods
      def rediline_topic(field_name, &block)
        define_method field_name.to_sym do
          Rediline::Timeline::User.new(field_name.to_sym, self, block)
        end
        
        after_destroy "delete_rediline_#{field_name}"
        private
        define_method "delete_rediline_#{field_name}" do
          send(field_name).destroy
        end
      end
    end
  end
end