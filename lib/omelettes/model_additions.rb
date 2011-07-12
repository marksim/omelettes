module Omelettes

  # This module adds the accessible_by class method to a model. It is included in the model adapters.
  module ModelAdditions
    module ClassMethods
      def scramble(column, &block)
        
      end

      def harden(column)
        
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end
end
