module InterfaceLayers
  module Slice
    def self.included(base)
      base.extend ClassMethods
    end

    class Builder
      def initialize(slice)
        @slice = slice
      end

      def build!
        [@slice, valid?]
      end

      def valid?
        @slice.eater && @slice.cake && @slice.identifier && @slice.identifier.length > 3 && @slice.size && @slice.size >= 0
      end

      def identifier=(value)
        @slice.identifier = value
      end

      def size=(value)
        @slice.size = (value == 'Infinity') ? TimeTracking::INFINITE_SIZE : value.to_f
      end

      def eater=(value)
        @slice.eater = TimeTracking::Eater.find(value.to_i)
      end

      def cake=(value)
        @slice.cake = TimeTracking::Cake.find(value.to_i)
      end
    end

    module ClassMethods
      def builder(id=nil)
        if id
          Builder.new TimeTracking::Slice.find(id.to_i)
        else
          Builder.new TimeTracking::Slice.allocate
        end
      end

      def empty_mock
        OpenStruct.new
      end
    end
  end
end
