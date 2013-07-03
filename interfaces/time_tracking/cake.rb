module InterfaceLayers
  module Cake
    def self.included(base)
      base.extend ClassMethods
    end

    class Builder
      def initialize(cake)
        @cake = cake
      end

      def build!
        [@cake, valid?]
      end

      def valid?
        @cake.identifier && @cake.identifier.length >= 3 && @cake.size && @cake.size >= 0
      end

      def identifier=(value)
        @cake.identifier = value
      end

      def size=(value)
        @cake.size = (value == 'Infinity') ? TimeTracking::INFINITE_SIZE : value.to_f
      end

      def parent=(value)
        @cake.parent = TimeTracking::Cake.find(value.to_i)
      end
    end

    module ClassMethods
      def builder(id=nil)
        if id
          Builder.new TimeTracking::Cake.find(id.to_i)
        else
          Builder.new TimeTracking::Cake.allocate
        end
      end

      def empty_mock
        OpenStruct.new
      end
    end
  end
end
