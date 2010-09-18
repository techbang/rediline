module Redline
  module User
    
    def self.included(model)
      model.extend(ClassMethods)
    end
    module ClassMethods
      def redline(field_name)
        define_method field_name.to_sym do
          Redline::Timeline::User.new field_name.to_sym, self.dup
        end
      end
    end
  end
end