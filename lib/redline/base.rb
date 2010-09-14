module Redline
  module Base
    
    def self.included(model)
      model.extend(ClassMethods)
    end
    module ClassMethods
      def redline(field_name)
        define_method field_name.to_sym do
          Redline::Timeline.new
        end
      end
    end
  end
end