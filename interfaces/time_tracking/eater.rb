module InterfaceLayers
  module Eater
    def self.included(base)
      base.extend ClassMethods
    end

    class Builder
      def initialize(eater)
        @eater = eater
      end

      def build!
        [@eater, valid?]
      end

      def valid?
        @eater.identifier && @eater.identifier.length >= 2
      end

      def identifier=(value)
        @eater.identifier = value
      end
    end

    module ClassMethods
      def builder(id=nil)
        if id
          Builder.new TimeTracking::Eater.find(id.to_i)
        else
          Builder.new TimeTracking::Eater.allocate
        end
      end

      def empty_mock
        OpenStruct.new
      end
    end
  end
end
