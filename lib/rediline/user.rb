module Rediline
  module User
    
    def self.included(model)
      model.extend(ClassMethods)
    end
    module ClassMethods
      def rediline(field_name, &block)
        define_method field_name.to_sym do
          Rediline::Timeline::User.new(field_name.to_sym, self, block)
        end
      end
    end
  end
end